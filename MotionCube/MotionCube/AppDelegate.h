//
//  AppDelegate.h
//  temp3D
//
//  Created by Christopher Polito on 10/22/13.
//  Copyright (c) 2013 Christopher Polito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class ThreeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    
    ThreeViewController *threeViewController;
    
    
    
    

}

@property (strong, nonatomic) ThreeViewController *threeViewController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
