//
//  keyBoardTopView.h
//  Simple Note
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ColorBtnDelegate <NSObject>

- (void)setColorType:(NSInteger)type;

@end
@interface ColorButtonView : UIView
@property (nonatomic,weak)id<ColorBtnDelegate> delegate;

- (void)setBorder:(NSInteger)index;

@end
