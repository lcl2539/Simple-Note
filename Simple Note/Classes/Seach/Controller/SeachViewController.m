//
//  SeachViewController.m
//  Simple Note
//
//  Created by qingyun on 16/7/1.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define viewBackgroundColor [UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1]
#define tableViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
#import "SeachViewController.h"
#import "ColorButtonView.h"
#import "textCell.h"
#import "textModel.h"
#import "EditViewController.h"
@interface SeachViewController () <ColorBtnDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,textCellDelegate,EditDelegate>
{
    __weak UISearchBar *_seachTxf;
    __weak UITableView *_seachResult;
    __weak UIView *_colorTypeView;
}
@property (nonatomic,assign)NSInteger colorType;
@property (nonatomic,strong)NSMutableArray *seachData;
@property (nonatomic,strong)NSMutableArray *keyArr;
@end

@implementation SeachViewController

- (NSMutableArray *)seachData{
    if (!_seachData) {
        _seachData=[NSMutableArray new];
    }
    return _seachData;
}

- (NSMutableArray *)keyArr{
    if (!_keyArr) {
        _keyArr=[NSMutableArray new];
    }
    return _keyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSomeSetting];
    [self loadSeachBar];
    [self loadTabelView];
    [self loadColorView];
    self.colorType=4;
}

- (void)loadSomeSetting{
    self.view.backgroundColor=viewBackgroundColor;
    UINavigationBar *bar= self.navigationController.navigationBar;
    bar.layer.shadowColor=[UIColor clearColor].CGColor;
}

- (void)loadSeachBar{
    [self.navigationItem setHidesBackButton:YES];
    UISearchBar *txt=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 30)];
    txt.placeholder=@"搜索";
    _seachTxf=txt;
    self.navigationItem.titleView=_seachTxf;
    [self.navigationController setToolbarHidden:YES animated:YES];
    _seachTxf.delegate=self;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:0 target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = cancelBtn;
    [_seachTxf becomeFirstResponder];
}

- (void)loadColorView{
    ColorButtonView *kbView=[[ColorButtonView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 40)];
    kbView.delegate=self;
    [kbView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBg"]]];
    _colorTypeView=kbView;
    [self.view addSubview:kbView];
}

- (void)loadTabelView{
    
    UITableView *view=[[UITableView alloc]initWithFrame:tableViewFrame];
    _seachResult=view;
    _seachResult.rowHeight=140;
    _seachResult.dataSource=self;
    _seachResult.delegate=self;
    _seachResult.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_seachResult];
}
#pragma mark 👀设置背景色👀
- (void)setColorType:(NSInteger)colorType{
    _colorType=colorType;
    [self seach:_seachTxf.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.seachData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    textCell *cell=[textCell cellWithTableView:tableView];
    cell.model=self.seachData[indexPath.row];
    cell.delegate=self;
    return cell;
}
#pragma mark 我是被点击的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EditViewController *vc=[EditViewController new];
    vc.model=self.originalData[[self.keyArr[indexPath.row] integerValue]];
    vc.indexPath=indexPath;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 👀滑动收起键盘👀
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_seachTxf resignFirstResponder];
    [self didSwipeLeft:nil];
}
#pragma mark 👀数据索引👀
- (void)seach:(NSString *)text{
    [self.seachData removeAllObjects];
    [self.keyArr removeAllObjects];
    for (NSInteger index=0; index<self.originalData.count; index++) {
        textModel *model=self.originalData[index];
        if (self.colorType==4) {
            if ([model.noteText containsString:text]) {
                [self.seachData addObject:model];
                [self.keyArr addObject:@(index)];
            }
        }
        else{
            if ([model.noteText containsString:text]&&model.colorType==self.colorType) {
                [self.seachData addObject:model];
                [self.keyArr addObject:@(index)];
            }
        }
    }
    [_seachResult reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self seach:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.25 animations:^{
        _colorTypeView.frame=CGRectMake(0, 0, _colorTypeView.frame.size.width, _colorTypeView.frame.size.height);
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.25 animations:^{
        _colorTypeView.frame=CGRectMake(0,-40, _colorTypeView.frame.size.width, _colorTypeView.frame.size.height);
    }];
}
#pragma mark 👀我是删除cell👀
- (void)willDelectCell:(textCell *)cell{
    [self deleteCell:[self calculateIndexPathForCell:cell]];
}

- (void)didSwipeLeft:(textCell *)cell{
    NSArray *arr = _seachResult.subviews.firstObject.subviews;
    for (textCell *cellTemp in arr) {
        if (cellTemp != cell) {
            [cellTemp anyCellDidSwipeRight];
        }
    }
}

- (void)longPressActionWithCell:(textCell *)cell{
    [_seachResult selectRowAtIndexPath:[self calculateIndexPathForCell:cell] animated:YES scrollPosition:UITableViewScrollPositionTop];
    _seachResult.allowsMultipleSelection=YES;
}
#pragma mark 👀我是编辑后刷新数据👀
- (void)ViewController:(UIViewController *)viewController model:(textModel *)model indexPath:(NSIndexPath *)indexPath{
    [self.seachData removeObjectAtIndex:indexPath.row];
    [_seachResult deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.seachData insertObject:model atIndex:0];
    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
    [_seachResult insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
    [self.originalData replaceObjectAtIndex:[self.keyArr[indexPath.row]integerValue] withObject:model];
}

- (void)ViewController:(UIViewController *)viewController model:(textModel *)model indexPath:(NSIndexPath *)indexPath isCopy:(BOOL)isCopy{
    if (isCopy) {
        [self addCell:model];
    }
    else{
        [self deleteCell:indexPath];
    }
 }

- (void)deleteCell:(NSIndexPath *)indexPath{
    [_seachData removeObjectAtIndex:indexPath.row];
    [self.originalData removeObjectAtIndex:[_keyArr[indexPath.row] integerValue]];
    [_seachResult deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)addCell:(textModel *)model{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.seachData insertObject:model atIndex:indexPath.row];
    [_seachResult insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.originalData insertObject:model atIndex:indexPath.row];
}

- (NSIndexPath *)calculateIndexPathForCell:(textCell *)cell{
    NSInteger row=cell.frame.origin.y/cell.frame.size.height;
    NSIndexPath *path=[NSIndexPath indexPathForRow:row inSection:0];
    return path;
}

- (void)back{
    if ([self.delegate respondsToSelector:@selector(ViewControlller:data:)]) {
        [self.delegate ViewControlller:self data:self.originalData];
    }
    UINavigationBar *bar= self.navigationController.navigationBar;
    bar.layer.shadowColor=[UIColor blackColor].CGColor;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 👀测试👀
- (void)dealloc{
    NSLog(@"886");
}
@end
