//
//  EditScrollView.m
//  Simple Note
//
//  Created by qingyun on 2016/7/22.
//  Copyright © 2016年 LCL. All rights reserved.
//
#import "EditScrollView.h"
#import "Masonry.h"
#import "XNGMarkdownParser.h"
@interface EditScrollView ()<UIScrollViewDelegate,UITextViewDelegate>
{
    __weak UITextView *_readTextView;
    XNGMarkdownParser *_parser;
}
@end
@implementation EditScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self loadSomeSetting];
    }
    return self;
}

- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    [self scrollViewDidEndDecelerating:self];
}

- (void)loadSomeSetting{
    self.contentSize = CGSizeMake(self.frame.size.width * 2, 0);
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    _parser = [XNGMarkdownParser markDownParser];
    [self setBackgroundColor:[UIColor clearColor]];
    [self loadEditTextView];
    [self loadReadTextView];
}

- (void)loadEditTextView{
    _editTextView = [self creatTextView];
    _editTextView.delegate = self;
    [self addSubview:_editTextView];
    [_editTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.leading.mas_equalTo(self.mas_leading);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (void)loadReadTextView{
    _readTextView = [self creatTextView];
    [self addSubview:_readTextView];
    _readTextView.allowsEditingTextAttributes = YES;
    _readTextView.editable = NO;
    [_readTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(_editTextView);
        make.top.mas_equalTo(_editTextView.mas_top);
        make.leading.mas_equalTo(_editTextView.mas_trailing);
    }];
}

- (UITextView *)creatTextView{
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor=[UIColor clearColor];
    textView.textColor=[UIColor blackColor];
    textView.font=[UIFont systemFontOfSize:20];
    textView.allowsEditingTextAttributes=YES;
    return textView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.contentOffset.x == self.frame.size.width) {
        _readTextView.attributedText = [_parser attributedStringFromMarkdownString:_editTextView.text];
        [_editTextView resignFirstResponder];
    }
}

- (void)dealloc{
    
    NSLog(@"%s",__func__);
}

@end
