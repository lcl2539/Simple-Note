//
//  FilePath.h
//  Simple Note
//
//  Created by 鲁成龙 on 16/8/1.
//  Copyright © 2016年 LCL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePath : NSObject
@property (nonatomic,strong)NSString *plistPath;
- (void)fileSave:(NSArray *)arr;
- (NSMutableArray *)modelArr;
+ (instancetype)filePath;
@end
