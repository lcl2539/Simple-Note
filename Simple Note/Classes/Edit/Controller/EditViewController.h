//
//  EditViewController.h
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/6.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textModel.h"
@protocol EditDelegate <NSObject>
- (void)ViewController:(UIViewController *)viewController model:(textModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)ViewController:(UIViewController *)viewController model:(textModel *)model indexPath:(NSIndexPath *)indexPath isCopy:(BOOL)isCopy;
@end
@interface EditViewController : UIViewController
@property (nonatomic,strong)textModel *model;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak)id<EditDelegate> delegate;
@property (nonatomic,assign)BOOL isNew;
@end
