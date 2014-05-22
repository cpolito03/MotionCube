//
//  Axes.h
//  temp3D
//
//  Created by Christopher Polito on 10/27/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Axes : NSObject
{
    
    //vector object
    
    double x;
    double y;
    double z;
    
}

@property (readwrite, nonatomic) double x;
@property (readwrite, nonatomic) double y;
@property (readwrite, nonatomic) double z;

-(id) initWithZero;
-(id) initWithX:(double) xCoord Y:(double) yCoord Z:(double) zCoord;
-(id) initWithPosition;
-(Axes *) copy;

-(void) setX:(double) xCoord Y:(double)yCoord Z:(double) zCoord;
+(Axes *)sum:(NSArray *)array;
+(Axes *)average:(NSArray *)array;
-(void) plus:(Axes *)axes;
-(void) minus:(Axes *)axes;
-(void) multiplyScalar:(double) scalar;
-(Axes *) axesByAdding:(Axes *)axes;
-(Axes *) axesBySubtracting:(Axes *)axes;
-(Axes *) axesByMultiplyScalar:(double) scalar;
-(double) length;

@end
