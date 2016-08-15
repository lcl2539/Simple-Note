//
//  ColorButton.m
//  Simple Note
//
//  Created by qingyun on 16/7/2.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define WhiteColor [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1]
#define GreenColor [UIColor colorWithRed:0.902 green:0.902 blue:0.898 alpha:1]
#define LightBlueColor [UIColor colorWithRed:1 green:1 blue:0.941 alpha:1]
#define CyanColor [UIColor colorWithRed:0.686 green:0.933 blue:0.933 alpha:1]
#import "ColorButton.h"

@implementation ColorButton
- (instancetype)initWithFrame:(CGRect)frame andColor:(NSInteger)colorNum{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color;
        switch (colorNum) {
            case 0:
                color=WhiteColor;
                break;
            case 1:
                color=GreenColor;
                break;
            case 2:
                color=LightBlueColor;
                break;
            case 3:
                color=CyanColor;
                break;
            case 4:
                color=[UIColor whiteColor];
                [self setImage:[UIImage imageNamed:@"allColor"] forState:UIControlStateNormal];
                [self setImage:[UIImage imageNamed:@"allColor"] forState:UIControlStateHighlighted];
                break;
            default:
                break;
        }
        [self setBackgroundColor:color];
        [self loadSomeSetting];
    }
    return self;
}

+ (instancetype)creatNewColorButtonWitnFrame:(CGRect)frame andColor:(NSInteger)colorNum{
    return [[ColorButton alloc]initWithFrame:frame andColor:colorNum];
}

- (void)loadSomeSetting{
    self.layer.cornerRadius=15;
    self.layer.masksToBounds=YES;
    self.layer.borderWidth=0.2;
    self.layer.borderColor=[UIColor grayColor].CGColor;
    
}


@end
