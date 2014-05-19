//
//  Utility.h
//  temp3D
//
//  Created by Christopher Polito on 10/24/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Axes.h"

#define kIntegrationSimpson @"simpson"
#define kIntegrationRectangle @"rectangle"

@interface Utility : NSObject


+(double) sum:(NSArray *)array;
+(double) average:(NSArray *)array;
+(Axes *) averageAxes:(NSArray *)array;
+(double) std:(NSArray *)array;
+(double) extrm:(NSArray *) array max:(BOOL) which;
+(double) cosineToSine:(double)cosine;
+(Axes *) rectangle:(NSArray *)array time:(NSArray *)time;
+(Axes *) simpson:(NSArray *)array time:(NSArray *)time;

@end
