//
//  EditViewController.m
//  Simple Note
//
//  Created by 鲁成龙 on 16/7/6.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define viewBackgroundColor [UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1]
#define WhiteColor [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1]
#define GreenColor [UIColor colorWithRed:0.902 green:0.902 blue:0.898 alpha:1]
#define LightBlueColor [UIColor colorWithRed:1 green:1 blue:0.941 alpha:1]
#define CyanColor [UIColor colorWithRed:0.686 green:0.933 blue:0.933 alpha:1]
#import "EditViewController.h"
#import "ColorButtonView.h"
#import "EditBottomView.h"
#import "MoreView.h"
#import "EditScrollView.h"
#import "KeyboardView.h"
#import <Foundation/Foundation.h>
@interface EditViewController ()<ColorBtnDelegate,BottomViewDelegate,MoreViewDelegate>
{
    __weak EditScrollView *_editTxF;
    __weak EditBottomView *_bottomView;
    __weak MoreView *_moreView;
    UIButton *_quitEdit;
    UIButton *_editFinish;
}
@property (nonatomic,assign)NSInteger colorType;

@end
@implementation EditViewController

- (textModel *)model{
    if (!_model) {
        _model = [[textModel alloc]init];
    }
    return _model;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadSomeSetting];
    [self loadEditScrollView];
    [self loadBottomView];
    [self loadMoreView];
    [self loadModelSetting];
    [self loadNavLeftItem];
    [self loadKeyboardView];
    [self.view bringSubviewToFront:_bottomView];
}

- (void)loadModelSetting{
    if (self.model.noteText.length==0) {
        [_moreView btnIsEnable:NO];
        [_editTxF -> _editTextView becomeFirstResponder];
    }
    else{
        _editTxF -> _editTextView.text=self.model.noteText;
        [_editTxF setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
        _moreView.index=self.model.colorType;
        [self setColorType:self.model.colorType];
    }
}

- (void)loadSomeSetting{
    self.view.backgroundColor=viewBackgroundColor;
    self.navigationItem.hidesBackButton=YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor cyanColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)loadEditScrollView{
    EditScrollView *view = [[EditScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view
                                                                           .frame.size.width, self.view.frame.size.height-104)];
    _editTxF = view;
    [self.view addSubview:_editTxF];
}

- (void)loadBottomView{
    EditBottomView *btmView=[[EditBottomView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_editTxF.frame), self.view.frame.size.width, 40)];
    btmView.lastDate=_model.date;
    _bottomView=btmView;
    [self.view addSubview:_bottomView];
    _bottomView.delegate=self;
}

- (void)loadMoreView{
    MoreView *viewTemp=[[MoreView alloc]initWithFrame:CGRectMake(0, _bottomView.frame.origin.y, self.view.frame.size.width,100)];
    _moreView=viewTemp;
    _moreView.delegate=self;
    _moreView.alpha=0;
    [self.view addSubview:_moreView];
}

- (void)loadKeyboardView{
    __unsafe_unretained EditViewController *weakSelf = self;
    KeyboardView *keybord = [KeyboardView keyboardView];
    keybord.caretAction = ^(NSString *str){
        NSRange range = weakSelf->_editTxF->_editTextView.selectedRange;
        NSMutableString *editStr = [weakSelf->_editTxF->_editTextView.text mutableCopy];
        [editStr insertString:str atIndex:range.location];
        weakSelf->_editTxF->_editTextView.text = editStr;
        weakSelf->_editTxF->_editTextView.selectedRange = NSMakeRange(range.location+1, 0);
    };
    keybord.endEditAction = ^(){
        [weakSelf->_editTxF->_editTextView resignFirstResponder];
    };
    _editTxF->_editTextView.inputAccessoryView = keybord;
}

- (void)loadNavLeftItem{
    _quitEdit=[self creatBtn:@"返回"];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithCustomView:_quitEdit];
    self.navigationItem.leftBarButtonItem=btn;
}

- (void)loadNavRightItem{
    _editFinish=[self creatBtn:@"完成"];
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithCustomView:_editFinish];
    self.navigationItem.rightBarButtonItem=btn;
}

- (UIButton *)creatBtn:(NSString *)str{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.titleLabel.font=[UIFont systemFontOfSize:20];
    [btn addTarget:self action:@selector(editFinish:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn sizeToFit];
    return btn;
}

- (void)setColorType:(NSInteger)type{
    _colorType=type;
    UIColor *color;
    switch (_colorType) {
        case 0:
            color=WhiteColor;
            break;
        case 1:
            color=GreenColor;
            break;
        case 2:
            color=LightBlueColor;
            break;
        case 3:
            color=CyanColor;
            break;
        case 4:
            color=viewBackgroundColor;
            break;
        default:
            break;
    }
    [self.view setBackgroundColor:color];
    _bottomView.backgroundColor=color;
    _moreView.backgroundColor=color;
    [_quitEdit setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)editFinish:(UIButton *)btn{
    if ([btn.currentTitle isEqualToString:@"完成"] && _editTxF -> _editTextView.text.length > 0) {
        self.model.noteText = _editTxF -> _editTextView.text;
        self.model.colorType = self.colorType;
        self.model.date = [self nowDate];
        if ([self.delegate respondsToSelector:@selector(ViewController:model:indexPath:)]) {
            [self.delegate ViewController:self model:self.model indexPath:self.indexPath];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardShow:(NSNotification *)notification{
    NSValue *boundsValue=notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect kbBounds=[boundsValue CGRectValue];
    [UIView animateWithDuration:0.25 animations:^{
        _editTxF.frame=CGRectMake(0, 0, _editTxF.frame.size.width, self.view.frame.size.height-kbBounds.size.height);
        [_quitEdit setTitle:@"取消" forState:UIControlStateNormal];
        if (!_editFinish) {
            [self loadNavRightItem];
        }
    }];
    self.model.date=[self nowDate];
    _bottomView.lastDate=self.model.date;
}

- (void)keyboardHide{
    _editTxF.frame=CGRectMake(0, 0, _editTxF.frame.size.width,self.view.frame.size.height-104);
}
#pragma mark 👀我是收起键盘👀
- (void)endEditButtonAction{
    if (_editTxF -> _editTextView.isFirstResponder) {
        [_editTxF ->_editTextView resignFirstResponder];
    }
    else{
        [_editTxF -> _editTextView becomeFirstResponder];
    }
    _moreView.alpha=0;
}
#pragma mark 👀我是更多👀
- (void)moreButtonAction{
    if (_moreView.alpha==0) {
        _bottomView.layer.shadowOpacity=0;
        [UIView animateWithDuration:0.25 animations:^{
            _moreView.alpha=1;
            _moreView.frame=CGRectMake(0, _bottomView.frame.origin.y-100, self.view.frame.size.width,100);
        }];
        _moreView.layer.shadowOpacity=0.2;
        NSString *str = _editTxF -> _editTextView.text;
        if (str.length==0&&!self.isNew) {
            [_moreView btnIsEnable:NO];
        }else if(str.length>0&&self.isNew){
            [_moreView btnIsEnable:NO];
        }
        else if(str.length>0&&!self.isNew){
            [_moreView btnIsEnable:YES];
        }
        if (!self.model.date) {
            self.model=[textModel new];
        }
        self.model.date=[self nowDate];
        _bottomView.lastDate=self.model.date;
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.layer.shadowOpacity=0.2;
            _moreView.layer.shadowOpacity=0;
        _moreView.alpha=0;
        _moreView.frame=CGRectMake(0, _bottomView.frame.origin.y, self.view.frame.size.width,100);
        }];
    }
}
#pragma mark 👀我是获取时间👀
- (NSString *)nowDate{
    NSDate *now=[NSDate date];
    NSDateFormatter *f=[NSDateFormatter new];
    f.dateFormat=@"yyyy-MM-dd";
    return [f stringFromDate:now];
}

- (void)btnAction:(BOOL)isCopy{
    if ([self.delegate respondsToSelector:@selector(ViewController:model:indexPath:isCopy:)]) {
        self.model.date=[self nowDate];
        [self.delegate ViewController:self model:self.model indexPath:self.indexPath isCopy:isCopy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
@end
