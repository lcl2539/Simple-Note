//
//  FilePath.m
//  Simple Note
//
//  Created by 鲁成龙 on 16/8/1.
//  Copyright © 2016年 LCL. All rights reserved.
//
#import "textModel.h"
#import "FilePath.h"
@interface FilePath ()
@property (nonatomic,strong)NSFileManager *file;

@end
@implementation FilePath
+ (instancetype)filePath{
    static FilePath *file;
    if (!file) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            file = [[FilePath alloc]init];
            file.file = [NSFileManager defaultManager];
            NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            file.plistPath = [filePath stringByAppendingPathComponent:@"myData.plist"];
        });
    }
    if (![file.file fileExistsAtPath:file.plistPath]) {
        [file.file createFileAtPath:file.plistPath contents:nil attributes:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"explain" ofType:@"plist"]];
        [arr writeToFile:file.plistPath atomically:YES];
    }
    return file;
}

- (void)fileSave:(NSArray *)arr{
    NSMutableArray *arrTemp = [NSMutableArray arrayWithCapacity:arr.count];
    for (textModel *model in arr) {
        [arrTemp addObject:[model dictWithModel]];
    }
    [arrTemp writeToFile:self.plistPath atomically:YES];
}

- (NSMutableArray *)modelArr{
    NSArray *arr = [NSArray arrayWithContentsOfFile:self.plistPath];
    NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *dict in arr) {
        [modelArr addObject:[[textModel alloc]initWithDict:dict]];
    }
    return modelArr;
}
@end
