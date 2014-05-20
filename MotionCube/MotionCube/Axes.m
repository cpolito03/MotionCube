//
//  Axes.m
//  temp3D
//
//  Created by Christopher Polito on 10/27/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import "Axes.h"

@implementation Axes

@synthesize x,y,z;


-(id) initWithZero {
    
    self = [super init];
    
    if (self) {
        
        self.x = 0;
        self.y = 0;
        self.z = 0;
        
    }
    
    return self;
}

-(id) initWithX:(double) xCoord Y:(double) yCoord Z:(double) zCoord{
    
    self = [super init];
    
    if (self){
        
        self.x = xCoord;
        self.y = yCoord;
        self.z = zCoord;
    
    }
    
    return self;
    
}

-(Axes *) copy {
    
    return [[Axes alloc] initWithX:self.x Y:self.y Z:self.z];
    
}

-(void) setX:(double) xCoord Y:(double)yCoord Z:(double) zCoord{
    
    self.x = xCoord;
    self.y = yCoord;
    self.z = zCoord;
    
}

// sum components of Axes objects across an array
+(Axes *)sum:(NSArray *)array{
    
    Axes *sum = [[Axes alloc] initWithZero];
    
    for (int i = 0; i<[array count]; i++)
    {
        sum.x += ((Axes *)[array objectAtIndex:i]).x;
        sum.y += ((Axes *)[array objectAtIndex:i]).y;
        sum.z += ((Axes *)[array objectAtIndex:i]).z;
    }
    
    return sum;
    
}

//average components of Axes objects across an array
+(Axes *)average:(NSArray *)array {
    
    Axes *result = [[Axes alloc] init];
    
    Axes *sum = [Axes sum:array];

    result.x = sum.x/[array count];
    result.y = sum.y/[array count];
    result.z = sum.z/[array count];
    
    return result;
}

// modify current object
-(void) plus:(Axes *)axes{
    
    self.x += axes.x;
    self.y += axes.y;
    self.z += axes.z;
    
}

//modify current object

-(void) minus:(Axes *)axes{
    
    self.x -= axes.x;
    self.y -= axes.y;
    self.z -= axes.z;
    
}


//modify current object
-(void) multiplyScalar:(double) scalar{
    
    self.x *= scalar;
    self.y *= scalar;
    self.z *= scalar;
}


// add and create new
-(Axes *) axesByAdding:(Axes *)axes{
    
    Axes *newAxes = [[Axes alloc] init];
    
    newAxes.x = self.x + axes.x;
    newAxes.y = self.y + axes.y;
    newAxes.z = self.z + axes.z;
    
    return newAxes;
    
}

// subtract and create new
-(Axes *) axesBySubtracting:(Axes *)axes{
    
    Axes *newAxes = [[Axes alloc] init];
    
    newAxes.x = self.x - axes.x;
    newAxes.y = self.y - axes.y;
    newAxes.z = self.z - axes.z;
    
    return newAxes;
    
}

// scale and create new
-(Axes *) axesByMultiplyScalar:(double) scalar {
    
    Axes *newAxes = [[Axes alloc] init];
    
    newAxes.x = self.x*scalar;
    newAxes.y = self.y*scalar;
    newAxes.z = self.z*scalar;
    
    return newAxes;
    
}


// get length of vector
-(double) length{
    
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z);
}


// vector dot product
-(double) dot:(Axes *) axes{
    
    return self.x*axes.x + self.y*axes.y + self.z*axes.z;
}

// vector cross product, unfinished
-(Axes *) cross:(Axes *)axes{
    
    return [[Axes alloc] initWithZero];
}

@end
