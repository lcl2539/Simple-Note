//
//  MyCell.h
//  UITabView
//
//  Created by 鲁成龙 on 16/7/3.
//  Copyright © 2016年 鲁成龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textModel.h"
@class textCell;
@protocol textCellDelegate <NSObject>
- (void)willDelectCell:(textCell *)cell;
- (void)didSwipeLeft:(textCell *)cell;
@required
- (void)longPressActionWithCell:(textCell *)cell;
@end
@interface textCell : UITableViewCell

@property (nonatomic,strong)textModel *model;
@property (nonatomic,weak)id<textCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tabview;

- (void)selectCell;
- (void)anyCellDidSwipeRight;
@end
