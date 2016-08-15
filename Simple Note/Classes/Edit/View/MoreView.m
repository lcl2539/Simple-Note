//
//  MoreView.m
//  Simple Note
//
//  Created by qingyun on 16/7/8.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define viewBackgroundColor [UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1]
#import "MoreView.h"
@interface MoreView ()
{
    __weak UIButton *_copy;
    __weak UIButton *_deleted;
    __weak ColorButtonView *_colorBtnView;
}
@end
@implementation MoreView

- (void)setIndex:(NSInteger)index{
    _index=index;
    [_colorBtnView setBorder:index];
}

- (void)setDelegate:(id<MoreViewDelegate>)delegate{
    _delegate=delegate;
    _colorBtnView.delegate=_delegate;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self loadSomeSetting];
        [self setBackgroundColor:viewBackgroundColor];
    }
    return self;
}

- (void)loadSomeSetting{
    ColorButtonView *viewTemp=[[ColorButtonView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    _colorBtnView=viewTemp;
    [self addSubview:_colorBtnView];
    [self loadShadows];
    [self loadBtn];
}

- (void)loadShadows{
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowOpacity=0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)loadBtn{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(self.frame.size.width/2, 0,self.frame.size.width/2, self.frame.size.height-40);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0 green:0.749 blue:0.647 alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _deleted=btn;
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame=CGRectMake(0, 0,self.frame.size.width/2, self.frame.size.height-40);
    [btn1 setTitle:@"复制" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor colorWithRed:0 green:0.749 blue:0.647 alpha:1] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    _copy=btn1;
    [_deleted addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_copy addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_copy];
    [self addSubview:_deleted];
}

- (void)btnAction:(UIButton *)btn{
    BOOL isCopy;
    if (btn==_deleted) {
        isCopy=NO;
    }
    else{
        isCopy=YES;
    }
    if ([self.delegate respondsToSelector:@selector(btnAction:)]) {
        [self.delegate btnAction:isCopy];
    }
}

- (void)btnIsEnable:(BOOL)isEnable{
    _deleted.enabled=isEnable;
    _copy.enabled=isEnable;
}
@end
