//
//  MyCell.m
//  UITabView
//
//  Created by 鲁成龙 on 16/7/3.
//  Copyright © 2016年 鲁成龙. All rights reserved.
//
#define WhiteColor [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1]
#define GreenColor [UIColor colorWithRed:0.902 green:0.902 blue:0.898 alpha:1]
#define LightBlueColor [UIColor colorWithRed:1 green:1 blue:0.941 alpha:1]
#define CyanColor [UIColor colorWithRed:0.686 green:0.933 blue:0.933 alpha:1]
#import "textCell.h"
#import "XNGMarkdownParser.h"
@interface textCell ()
{
    __weak IBOutlet UILabel *_text;
    __weak IBOutlet UILabel *_date;
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UIButton *_deletedButton;
    __weak IBOutlet UIImageView *_selectionImg;
}
@property (nonatomic,assign)NSInteger color;
@property (nonatomic,copy)UILongPressGestureRecognizer *longPress;
@property (nonatomic,copy)UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic,copy)UISwipeGestureRecognizer *swipeRight;

@end
@implementation textCell

+ (instancetype)cellWithTableView:(UITableView *)tabview{
    textCell *cell = [tabview dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"textCell" owner:nil options:nil] firstObject];
        [cell loadSomeSetting];
        [cell addLongPressGesture];
        [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(tableViewDidLongPress) name:@"longPress" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(tableViewNotLongPress) name:@"notLongPress" object:nil];
    }
    return cell;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadShadow];
}

- (void)setModel:(textModel *)model{
    _model=model;
    _text.attributedText=[self changeString:model.noteText];
    _date.text=model.date;
    _color=model.colorType;
    UIColor *myColor;
    switch (_color) {
        case 0:
            myColor=WhiteColor;
            break;
        case 1:
            myColor=GreenColor;
            break;
        case 2:
            myColor=LightBlueColor;
            break;
        case 3:
            myColor=CyanColor;
            break;
            
        default:
            break;
    }
    _bgView.backgroundColor=myColor;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self selectCell];
}


- (void)loadSomeSetting{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _deletedButton.layer.cornerRadius = 6;
    _selectionImg.alpha = 0;
    [_deletedButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deletedButton setBackgroundColor:[UIColor redColor]];
    [_deletedButton addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    _deletedButton.alpha=0;
}

- (void)loadShadow{
    _bgView.layer.cornerRadius=6;
    _bgView.layer.shadowColor=[UIColor blackColor].CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0, 2);
    _bgView.layer.shadowRadius = 3;
    _bgView.layer.shadowOpacity=0.2;
}

#pragma mark 我是添加手势
- (void)addLongPressGesture{
    UISwipeGestureRecognizer *lG=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
    lG.direction=UISwipeGestureRecognizerDirectionLeft;
    _swipeLeft = lG;
    UISwipeGestureRecognizer *rG=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeAction:)];
    rG.direction=UISwipeGestureRecognizerDirectionRight;
    _swipeRight = rG;
    UILongPressGestureRecognizer *lpG=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPress:)];
    _longPress = lpG;
    [self addGestureRecognizer:_longPress];
    [self addGestureRecognizer:_swipeLeft];
    [self addGestureRecognizer:_swipeRight];
}
#pragma mark 我是长按执行事件
- (void)didLongPress:(UILongPressGestureRecognizer *)longPress{
    if ([self.delegate respondsToSelector:@selector(longPressActionWithCell:)]) {
        [self.delegate longPressActionWithCell:self];
    }
}

- (void)SwipeAction:(UISwipeGestureRecognizer *)gesture{
    CGRect frame=_bgView.frame;
    CGFloat cornerRadius=_bgView.layer.cornerRadius;
    CGFloat alphaValue=0;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self.delegate didSwipeLeft:self];
        frame.origin=CGPointMake(-_bgView.frame.size.width*0.35+30, _bgView.frame.origin.y);
        cornerRadius=0;
        alphaValue=1;
    }
    else{
        frame.origin=CGPointMake(20, _bgView.frame.origin.y);
        cornerRadius=6;
        alphaValue=0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _deletedButton.alpha=alphaValue;
        _bgView.frame=frame;
        _bgView.layer.cornerRadius=cornerRadius;
    }];
}

- (void)anyCellDidSwipeRight{
    if (_bgView.frame.origin.x == 20)return;
    [self SwipeAction:_swipeRight];
}

- (void)deleteCell{
    if ([self.delegate respondsToSelector:@selector(willDelectCell:)]) {
        [self.delegate willDelectCell:self];
    }
}

- (void)selectCell{
    CGFloat alpha;
    if (self.isSelected) {
        alpha = 1;
    }else{
        alpha = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _selectionImg.alpha = alpha;
    }];
}

- (void)tableViewDidLongPress{
    self.longPress.enabled = NO;
    self.swipeLeft.enabled = NO;
    self.swipeRight.enabled = NO;
}

- (void)tableViewNotLongPress{
    self.longPress.enabled = YES;
    self.swipeLeft.enabled = YES;
    self.swipeRight.enabled = YES;
}

- (NSAttributedString *)changeString:(NSString *)str{
    XNGMarkdownParser *parser = [XNGMarkdownParser markDownParser];
    parser.paragraphFont = [UIFont systemFontOfSize:15];
    NSAttributedString *result = [parser attributedStringFromMarkdownString:str];
    return result;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
