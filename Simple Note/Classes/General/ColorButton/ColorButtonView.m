//
//  keyBoardTopView.m
//  Simple Note
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define gapX (self.frame.size.width-30*5)/7
#import "ColorButtonView.h"
#import "ColorButton.h"
@implementation ColorButtonView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self loadSomeSetting];
    }
    return self;
}
- (void)loadSomeSetting{
    self.backgroundColor=[UIColor clearColor];
    for (NSInteger index=0; index<5; index++) {
        ColorButton *btn=[ColorButton creatNewColorButtonWitnFrame:CGRectMake(gapX+index*(40+gapX), 3, 30, 30) andColor:index];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (index==4) {
            [self click:btn];
        }
        btn.tag=index;
        [self addSubview:btn];
    }
}

- (void)click:(UIButton *)btn{
    [self setBtnBorder:btn];
    if ([self.delegate respondsToSelector:@selector(setColorType:)]) {
        [self.delegate setColorType:btn.tag];
    }
}

- (void)setBtnBorder:(UIButton *)button{
    for (UIButton *btn in self.subviews) {
        btn.layer.borderWidth=0.2;
        btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    button.layer.borderWidth=1;
    button.layer.borderColor=[UIColor orangeColor].CGColor;
}

- (void)setBorder:(NSInteger)index{
    for (UIButton *btn in self.subviews) {
        if (btn.tag==index) {
         [self setBtnBorder:btn];   
        }
    }
}
@end
