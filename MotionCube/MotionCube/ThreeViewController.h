//
//  ThreeViewController.h
//  temp3D
//
//  Created by Christopher Polito on 10/26/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import <GLKit/GLKit.h>

@class Accelerometer;
@class Axes;

@interface ThreeViewController : GLKViewController
{
    
    GLuint vertexBuffer;
    
    Accelerometer *accel;
    
    BOOL doesUpdatePosition;
    
    UIActivityIndicatorView *wait;
    
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setUpGL;
- (void)tearDownGL;

@end
