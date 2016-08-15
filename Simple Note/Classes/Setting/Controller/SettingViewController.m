//
//  SettViewController.m
//  Simple Note
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 LCL. All rights reserved.
//
#import "SettingViewController.h"

@interface SettingViewController ()
@end

@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
