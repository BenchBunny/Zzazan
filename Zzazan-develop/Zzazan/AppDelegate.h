//
//  AppDelegate.h
//  Zzazan
//
//  Created by Yiming Jiang on 1/31/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ZZActivityViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) ZZActivityViewController *activityView;
@property (nonatomic, strong) UINavigationController *navController;



@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

