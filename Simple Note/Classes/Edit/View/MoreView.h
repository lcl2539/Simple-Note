//
//  MoreView.h
//  Simple Note
//
//  Created by qingyun on 16/7/8.
//  Copyright © 2016年 LCL. All rights reserved.
//
#import "ColorButtonView.h"
#import <UIKit/UIKit.h>
@protocol MoreViewDelegate  <NSObject,ColorBtnDelegate>
- (void)btnAction:(BOOL)isCopy;
@end
@interface MoreView : UIView
@property (nonatomic,weak)id<MoreViewDelegate> delegate;
@property (nonatomic,assign)NSInteger index;
- (void)btnIsEnable:(BOOL)isEnable;
@end
