//
//  AppDelegate.h
//  scanCardProject
//
//  Created by JXInfo on 2021/9/30.
//  Copyright © 2021 JXInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

