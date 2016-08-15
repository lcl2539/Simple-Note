//
//  textModel.h
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/6.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface textModel : NSObject
@property (nonatomic,copy)NSString *noteText;
@property (nonatomic,assign)NSInteger colorType;
@property (nonatomic,copy)NSString *date;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSMutableDictionary *)dictWithModel;
@end
