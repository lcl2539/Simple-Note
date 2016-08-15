//
//  key.h
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/27.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardView : UIView
@property (nonatomic,copy)void (^caretAction)(NSString *);
@property (nonatomic,copy)void (^endEditAction)();
+ (instancetype)keyboardView;
@end
