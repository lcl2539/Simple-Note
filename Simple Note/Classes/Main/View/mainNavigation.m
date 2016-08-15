//
//  mainViewController.m
//  Simple Note
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import "mainNavigation.h"

@interface mainNavigation ()

@end

@implementation mainNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+(void)initialize{
    UINavigationBar *bar=[UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    bar.translucent=NO;
    [bar setBarTintColor:[UIColor colorWithRed:0 green:0.749 blue:0.647 alpha:1]];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
