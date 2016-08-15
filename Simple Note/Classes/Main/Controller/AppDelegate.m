//
//  AppDelegate.m
//  Simple Note
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import "AppDelegate.h"
#import "mainNavigation.h"
#import "mainViewController.h"
#import "FilePath.h"
@interface AppDelegate ()
{
    __weak mainViewController *_mainVC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mainViewController *mainVCTemp=[[mainViewController alloc]init];
    _mainVC = mainVCTemp;
    FilePath *path = [FilePath filePath];
    _mainVC.dataArr = [path modelArr];
    if(!_mainVC.dataArr){
        _mainVC.dataArr = [[NSMutableArray alloc]init];
    }
    mainNavigation *mainNav=[[mainNavigation alloc]initWithRootViewController:_mainVC];
    self.window.rootViewController=mainNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}

- (void)saveData{
    FilePath *file = [FilePath filePath];
    [file fileSave:_mainVC.dataArr];
}

@end
