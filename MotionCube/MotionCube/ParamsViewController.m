//
//  ParamsViewController.m
//  MotionCube
//
//  Created by Christopher Polito on 5/22/14.
//  Copyright (c) 2014 Christopher Polito. All rights reserved.
//

#import "ParamsViewController.h"

@interface ParamsViewController ()

@end

@implementation ParamsViewController


@synthesize params;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init {
    
    self = [super init];
    
    if (self) {
        
        params = [[AccelParams alloc] init];
    }
    
    return self;
}

-(NSString *) getPathWithName:(NSString *) name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    
    return [docDir stringByAppendingPathComponent: name];
    
}


-(void) deleteData {
    
    NSString *path = [self getPathWithName:kFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
}

-(void) saveAll {
    
    NSLog(@" ");
    NSLog(@"SAVE ALL -----------------------------------");
    
    NSString *path = [self getPathWithName:kFileName];
    
    if (params) {
        [NSKeyedArchiver archiveRootObject:params toFile:path];
    }
    else {
        NSLog(@"No data to archive");
    }
    
}

-(void) retrieveAll {
    
    NSString *path = [self getPathWithName:kFileName];
    
    params = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (!params) {
        params = [[AccelParams alloc] init];
        
        params.factor = 3;
        params.friction = YES;
        params.mu = 0.1;
        params.bounce = YES;
        params.totalToStop = 1;
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.view addSubview:subview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    toolbar = [[UIView alloc] init];
    [toolbar setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, 50)];
    [toolbar setBackgroundColor:[UIColor grayColor]];
    toolbar.tag = 300;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(toolbar.frame.size.width - 70-10, 5, 70, 40)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:button];
    
    [self.view addSubview:toolbar];
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    [factorSlider setValue:params.factor animated:NO];
    [muSlider setValue:params.mu animated:NO];
    [frictionSwitch setOn:params.friction];
    [bounceSwitch setOn:params.bounce];
    [stopSlider setValue:params.totalToStop animated:NO];
    
    if (frictionSwitch.on) {
        frictionView.contentOffset = CGPointMake(0, 0);
    }
    else {
        frictionView.contentOffset = CGPointMake(0, frictionView.frame.size.height/2);
    }
    
    NSLog(@"totalToStop is %d", params.totalToStop);
    NSLog(@"stop slider is %f", stopSlider.value);
}

-(IBAction)save:(id)sender {
    
    
    params.factor = factorSlider.value;
    params.mu = muSlider.value;
    params.friction = frictionSwitch.on;
    params.bounce = bounceSwitch.on;
    params.totalToStop = floor(stopSlider.value);
    
    NSLog(@"totalToStop is %d", params.totalToStop);
    NSLog(@"stop slider is %f", stopSlider.value);
    
    [self saveAll];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paramsSet" object:params];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)frictionChanged:(id)sender {
    
    if (((UISwitch*)sender).on) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        
        frictionView.contentOffset = CGPointMake(0, 0);
        
        [UIView commitAnimations];
        
    }
    else {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        
        frictionView.contentOffset = CGPointMake(0, frictionView.frame.size.height/2);
        
        [UIView commitAnimations];
    
        
        
    }
}

-(void) resign {
 
    //[factorField resignFirstResponder];
    //[muField resignFirstResponder];
    
}

-(void) keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    
    [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height - keyboardFrame.size.height - toolbar.frame.size.height)];
    
    [toolbar setFrame:CGRectMake(toolbar.frame.origin.x, keyboardFrame.origin.y - toolbar.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height)];
    
	[UIView commitAnimations];
	
}

-(void) keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height + keyboardFrame.size.height + toolbar.frame.size.height)];
    
    [toolbar setFrame:CGRectMake(toolbar.frame.origin.x, self.view.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height)];
    
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
