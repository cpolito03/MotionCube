//
//  ThreeViewController.m
//  temp3D
//
//  Created by Christopher Polito on 10/26/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import "ThreeViewController.h"
#import "Accelerometer.h"


#define BUFFER_OFFSET(i) ((char *)NULL + (i))



// cube vertices, each face is two triangles (6 points)
GLfloat gCubeVertexData[216] =
{
   //x      y      z             nx     ny     nz
     1.0f, -1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
     1.0f,  1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
     1.0f, -1.0f,  1.0f,         1.0f,  0.0f,  0.0f,
     1.0f, -1.0f,  1.0f,         1.0f,  0.0f,  0.0f,
     1.0f,  1.0f,  1.0f,         1.0f,  0.0f,  0.0f,
     1.0f,  1.0f, -1.0f,         1.0f,  0.0f,  0.0f,
    
     1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
     1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
     1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  1.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,         0.0f,  1.0f,  0.0f,
    
    -1.0f,  1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f,  1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f, -1.0f,        -1.0f,  0.0f,  0.0f,
    -1.0f, -1.0f,  1.0f,        -1.0f,  0.0f,  0.0f,
    
    -1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
     1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
    -1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,
    -1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,
     1.0f, -1.0f, -1.0f,         0.0f, -1.0f,  0.0f,
     1.0f, -1.0f,  1.0f,         0.0f, -1.0f,  0.0f,
    
     1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
    -1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
     1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
     1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
    -1.0f,  1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
    -1.0f, -1.0f,  1.0f,         0.0f,  0.0f,  1.0f,
    
     1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
     1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
     1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f, -1.0f, -1.0f,         0.0f,  0.0f, -1.0f,
    -1.0f,  1.0f, -1.0f,         0.0f,  0.0f, -1.0f
};


@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedCal) name:@"doneCalibrating" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAccelParams:) name:@"paramsSet" object:nil];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //calibrating loading view
    wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [wait setFrame:CGRectMake(self.view.frame.size.width/2-wait.frame.size.width/2, self.view.frame.size.height/2 - wait.frame.size.height/2, wait.frame.size.width, wait.frame.size.height)];
    wait.hidesWhenStopped = YES;
    [self.view addSubview:wait];
    
    
    //  button creation
    int buttonWidth = 100;
    int buttonHeight = 40;
    UIButton *motionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    motionButton.frame = CGRectMake(self.view.bounds.size.width - buttonWidth - 10, self.view.bounds.size.height - buttonHeight - 10, buttonWidth, buttonHeight);
    [[motionButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[motionButton layer] setBorderWidth:3.0];
    [motionButton addTarget:self action:@selector(toggleUpdatePosition) forControlEvents:UIControlEventTouchUpInside];
    motionButton.tag = 101;
    
    [view addSubview:motionButton];
    
    
    
    UIButton *paramsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [paramsButton setFrame:CGRectMake(view.frame.size.width - 100, 30, 100, 30)];
    [paramsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [paramsButton addTarget:self action:@selector(gotoSettings) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:paramsButton];
    
    
    [self setUpGL];
    
    
    // object to read acceleration data and integrate position
    accel = [[Accelerometer alloc] init];
    
    params = [[AccelParams alloc] init];
    
    params.factor = 3;
    params.friction = YES;
    params.mu = 0.1;
    params.bounce = YES;
    params.totalToStop = 1;
    
    [accel setParams:params];
    
    [self toggleUpdatePosition];
    
}

-(void) gotoSettings {
    
    ParamsViewController *paramsView = [[ParamsViewController alloc] init];
    
    paramsView.params  = params;
    
    [self presentViewController:paramsView animated:YES completion:nil];
    
}

-(void) setAccelParams:(NSNotification *) notification {
    
    params = (AccelParams *) notification.object;
    
    [accel setParams:params];
    
}




-(void) finishedCal {
    
    [wait stopAnimating];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    self.context = nil;
}


- (void)setUpGL
{
    
    //create cube
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT,  GL_FALSE, 24, BUFFER_OFFSET(12));
    
    
}



- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &vertexBuffer);
    
    self.effect = nil;
}

-(void) toggleUpdatePosition
{
    
    [accel toggleUpdatePosition];
    
    UIButton *motionButton = (UIButton *)[self.view viewWithTag:101];
    
    if (accel.updatePosition){
        //change button image for state
        [motionButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    else {
        [motionButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    }
    
    
    [accel motion];
    
    
    
}


- (void) update
{
    // set up aspect perspective
    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective (GLKMathDegreesToRadians(50.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelMatrix;
    
    if (!accel.updatePosition) {
        // if not updating position, set to x=0, y=0, z=-40
        [accel setPosition];
    }
    
    // read accel objects position
    modelMatrix = GLKMatrix4MakeTranslation(accel.position.x, accel.position.y, accel.position.z);
    
    // combine translation with rotation
    modelMatrix = GLKMatrix4Multiply(modelMatrix, accel.rotation);

    //set transformation matrix
    self.effect.transform.modelviewMatrix = modelMatrix;
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.6f, 0.6f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
