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
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
    wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [wait setFrame:CGRectMake(self.view.frame.size.width/2-wait.frame.size.width/2, self.view.frame.size.height/2 - wait.frame.size.height/2, wait.frame.size.width, wait.frame.size.height)];
    wait.hidesWhenStopped = YES;
    [self.view addSubview:wait];
    
    int buttonWidth = 100;
    int buttonHeight = 40;
    UIButton *motionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    motionButton.frame = CGRectMake(self.view.bounds.size.width - buttonWidth - 10, self.view.bounds.size.height - buttonHeight - 10, buttonWidth, buttonHeight);
    [[motionButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[motionButton layer] setBorderWidth:3.0];
    [motionButton addTarget:self action:@selector(toggleUpdatePosition) forControlEvents:UIControlEventTouchUpInside];
    motionButton.tag = 101;
    
    [view addSubview:motionButton];
    
    [self setUpGL];
    
    accel = [[Accelerometer alloc] init];
    
    doesUpdatePosition = YES;
    
    [self toggleUpdatePosition];
    
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
    UIButton *motionButton = (UIButton *)[self.view viewWithTag:101];
    
    if (doesUpdatePosition){
        doesUpdatePosition = NO;
        [motionButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [wait stopAnimating];
    }
    else {
        doesUpdatePosition = YES;
        [motionButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [wait startAnimating];
    }
    
    [accel motion];
    
}


- (void) update
{
    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective (GLKMathDegreesToRadians(50.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelMatrix;
    
    if (doesUpdatePosition) {

        modelMatrix = GLKMatrix4MakeTranslation(accel.position.x, accel.position.y, accel.position.z);
        
    }
    else {
        modelMatrix = GLKMatrix4MakeTranslation(0,0,-40);
    }
    
    modelMatrix = GLKMatrix4Multiply(modelMatrix, accel.rotation);

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
