//
//  SeachViewController.h
//  Simple Note
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SeachDelegate <NSObject>
- (void)ViewControlller:(UIViewController *)viewController data:(NSMutableArray *)arr;
@end
@interface SeachViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *originalData;
@property (nonatomic,weak)id<SeachDelegate> delegate;
@end
