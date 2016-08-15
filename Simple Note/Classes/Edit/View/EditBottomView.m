//
//  EditTopView.m
//  Simple Note
//
//  Created by qingyun on 16/7/8.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define btnSize 40
#define labWidth 200
#define viewBackgroundColor [UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1]
#import "EditBottomView.h"
#import "Masonry.h"
@interface EditBottomView ()
{
    __weak UIButton *_moreBtn;
    __weak UILabel *_dateLab;
}

@end
@implementation EditBottomView

- (void)setLastDate:(NSString *)lastDate{
    _lastDate=lastDate;
    _dateLab.text=[NSString stringWithFormat:@"最后修改日期:%@",_lastDate];
    if (!_lastDate) {
        _dateLab.text=@"";
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self loadSomeSetting];
    }
    return self;
}

- (void)loadSomeSetting{
    UIButton *moreBtn=[UIButton new];
    UILabel *datelab=[UILabel new];
    _moreBtn=moreBtn;
    _dateLab=datelab;
    [self loadDateLab];
    [self loadMoreBtn];
    [self loadShadows];
    [self setBackgroundColor:viewBackgroundColor];
    
}

- (void)loadShadows{
    self.layer.shadowColor=[UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowOpacity=0.2;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}


- (void)loadMoreBtn{
    [_moreBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_dateLab);
        make.leading.equalTo(_dateLab.mas_trailing);
        make.trailing.equalTo(self.mas_trailing);
    }];
}

- (void)loadDateLab{
    _dateLab.textAlignment=NSTextAlignmentCenter;
    _dateLab.font=[UIFont systemFontOfSize:12];
    _dateLab.textColor=[UIColor grayColor];
    [self addSubview:_dateLab];
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing).offset(-40);
    }];
}

- (void)editBtnAction{
    [self.delegate endEditButtonAction];
}

- (void)moreBtnAction{
    [self.delegate moreButtonAction];
}
@end
