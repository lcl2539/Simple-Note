
//
//  key.m
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/27.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import "KeyboardView.h"
@interface KeyboardView ()

@end
@implementation KeyboardView

+ (instancetype)keyboardView{
    KeyboardView *view = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardView" owner:nil options:nil] firstObject];
    return view;
}

- (IBAction)caretWithBtn:(UIButton *)sender {
    if (self.caretAction) {
        self.caretAction(sender.currentTitle);
    }
}
- (IBAction)endEdit {
    if (self.endEditAction) {
        self.endEditAction();
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
