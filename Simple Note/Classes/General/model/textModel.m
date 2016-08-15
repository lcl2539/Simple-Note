//
//  textModel.m
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/6.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import "textModel.h"

@implementation textModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.noteText=dict[@"text"];
        self.date=dict[@"data"];
        self.colorType=[dict[@"color"] integerValue];
    }
    return self;
}

- (NSMutableDictionary *)dictWithModel{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.noteText forKey:@"text"];
    [dict setObject:self.date forKey:@"data"];
    [dict setObject:@(self.colorType) forKey:@"color"];
    return dict;
}
@end
