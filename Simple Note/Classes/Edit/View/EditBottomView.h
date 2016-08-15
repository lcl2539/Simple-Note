//
//  EditTopView.h
//  Simple Note
//
//  Created by qingyun on 16/7/8.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomViewDelegate <NSObject>

- (void)endEditButtonAction;
- (void)moreButtonAction;

@end
@interface EditBottomView : UIView
@property (nonatomic,copy)NSString *lastDate;
@property (nonatomic,weak)id<BottomViewDelegate> delegate;

@end
