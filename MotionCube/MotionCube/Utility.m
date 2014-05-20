//
//  Utility.m
//  temp3D
//
//  Created by Christopher Polito on 10/24/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import "Utility.h"

@implementation Utility


// sum across an array of doubles
+(double) sum:(NSArray *)array{
    
    double sum = 0;
    
    for (int i = 0; i<[array count]; i++)
    {
        sum += [[array objectAtIndex:i] doubleValue];
    }
    
    return sum;
}


// average components of Axes objects across an array
+(Axes *) averageAxes:(NSArray *)array {
    
    NSMutableArray *xArray = [[NSMutableArray alloc] init];
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    NSMutableArray *zArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        
        [xArray addObject:[NSNumber numberWithDouble:((Axes *)[array objectAtIndex:i]).x]];
        [yArray addObject:[NSNumber numberWithDouble:((Axes *)[array objectAtIndex:i]).y]];
        [zArray addObject:[NSNumber numberWithDouble:((Axes *)[array objectAtIndex:i]).z]];
    }
    
    double xAverage = [Utility average:xArray];
    double yAverage = [Utility average:yArray];
    double zAverage = [Utility average:zArray];
    
    return [[Axes alloc] initWithX:xAverage Y:yAverage Z:zAverage];
}

//average an array of doubles
+(double) average:(NSArray *)array{
    
    return [Utility sum:array]/[array count];
    
}


// standard deviation of an array of doubles
+(double) std:(NSArray *)array {
    
    double avg = [Utility average:array];
    
    NSMutableArray *diff = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++){
        
        double value = [[array objectAtIndex:i] doubleValue];
        
        [diff addObject:[NSNumber numberWithDouble:(value - avg)*(value - avg)]];
        
    }
    
    return sqrt([Utility average:diff]);
    
}

// maximum and minimum of an array
+(double) extrm:(NSArray *) array max:(BOOL) which {
    
    double result;
    
    if (which){
        
        //maximum
        result = -1;
        
        for (int i = 0; i < [array count]; i++){
            if ([[array objectAtIndex:i] doubleValue] > result){
                result = [[array objectAtIndex:i] doubleValue];
            }
        }
        
    }else {
        
        //minimum
        result = 361;
        
        for (int i = 0; i < [array count]; i++){
            if ([[array objectAtIndex:i] doubleValue] < result){
                result = [[array objectAtIndex:i] doubleValue];
            }
        }
    }
    
    return result;
}

// convert cosine to sine
+(double) cosineToSine:(double)cosine
{
    
    return sqrt(1-cosine*cosine);
    
}

// get length of an Axes object
+(double) length:(Axes *)axes {
    
    return axes.x*axes.x + axes.y*axes.y + axes.z*axes.z;
}



// integration method, from previous unsuccesful attempt
+(Axes *) rectangle:(NSArray *)array time:(NSArray *)time {
    
    double intX = 0;
    double intY = 0;
    double intZ = 0;
    
    Axes *average;
    double timeSlice;
    
    for (int i = 0; i < [array count]-1; i++) {
        
        average = [Axes average:[[NSArray alloc] initWithObjects:[array objectAtIndex:i], [array objectAtIndex:i+1], nil]];
        
        timeSlice = [[time objectAtIndex:i+1] doubleValue] - [[time objectAtIndex:i] doubleValue];
        
        intX += average.x*timeSlice;
        intY += average.y*timeSlice;
        intZ += average.z*timeSlice;
        
    }
    
    
    return [[Axes alloc] initWithX:intX Y:intY Z:intZ];
}


// integration method, from previous unsuccessful attempt,
+(Axes *) simpson:(NSArray *)array time:(NSArray *)time {
    
    if ([array count] == 3) {
        
        double timeSlice = [[time objectAtIndex:2] doubleValue] - [[time objectAtIndex:0] doubleValue];
    
        double intX = timeSlice/6*(((Axes *)[array objectAtIndex:0]).x + 4*((Axes *)[array objectAtIndex:1]).x + ((Axes *)[array objectAtIndex:2]).x);
        double intY = timeSlice/6*(((Axes *)[array objectAtIndex:0]).y + 4*((Axes *)[array objectAtIndex:1]).y + ((Axes *)[array objectAtIndex:2]).y);
        double intZ = timeSlice/6*(((Axes *)[array objectAtIndex:0]).z + 4*((Axes *)[array objectAtIndex:1]).z + ((Axes *)[array objectAtIndex:2]).z);
        
        return [[Axes alloc] initWithX:intX Y:intY Z:intZ];
    
    }
    else {
        
        NSLog(@"incorrect number for simpson");
        
        return [[Axes alloc] initWithZero];
        
    }
}



@end
