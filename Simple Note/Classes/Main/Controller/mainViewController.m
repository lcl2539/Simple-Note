//
//  mainViewController.m
//  Simple Note
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 LCL. All rights reserved.
//
#define viewBackgroundColor [UIColor colorWithRed:0.984 green:0.984 blue:0.984 alpha:1]
#define tableViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)
#import "mainViewController.h"
#import "SeachViewController.h"
#import "textCell.h"
#import "textModel.h"
#import "EditViewController.h"
#import "SettingViewController.h"
#import "FilePath.h"
@interface mainViewController ()<UITableViewDataSource,UITableViewDelegate,textCellDelegate,SeachDelegate,EditDelegate>
{
    __weak UIButton *_creatNew;
    __weak UITableView *_noteList;
}

@property (nonatomic,strong)NSMutableArray *moreSelectedArr;
@end

@implementation mainViewController

- (NSMutableArray *)moreSelectedArr{
    if (!_moreSelectedArr) {
        _moreSelectedArr = [NSMutableArray new];
    }
    return _moreSelectedArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationBar];
    [self loadCreatNewBtn];
    [self loadTextViewList];
    [self loadNavRightItems];
    [self.view bringSubviewToFront:_creatNew];
}

- (void)loadNavigationBar{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    title.text = @"简·记";
    title.font = [UIFont fontWithName:@"PingFang SC" size:25];
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView=title;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.view.backgroundColor = viewBackgroundColor;
    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.layer.shadowColor = [UIColor blackColor].CGColor;
    bar.layer.shadowOffset = CGSizeMake(0, 5);
    bar.layer.shadowRadius = 3;
    bar.layer.shadowOpacity = 0.2;
    bar.layer.shadowPath = [UIBezierPath bezierPathWithRect:bar.bounds].CGPath;
}

- (void)loadNavRightItems{
    if (_noteList.allowsMultipleSelection) {
        UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delect"] style:0 target:self action:@selector(deleteMore)];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"done"] style:0 target:self action:@selector(deleteDone)];
        self.navigationItem.rightBarButtonItems = @[doneItem,deleteItem];
    }else{
        UIBarButtonItem *seachItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSeach)];
        UIBarButtonItem *moreItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:0 target:self action:@selector(goToSetting)];
        self.navigationItem.rightBarButtonItems = @[moreItem,seachItem];
    }
}

- (void)loadCreatNewBtn{
    UIButton *btn = [[UIButton alloc]init];
    _creatNew = btn;
    _creatNew.frame = CGRectMake(self.view.frame.size.width-75, self.view.frame.size.height-135, 50, 50);
    [_creatNew setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
    [_creatNew setBackgroundColor:[UIColor colorWithRed:0 green:0.749 blue:0.647 alpha:1]];
    _creatNew.layer.cornerRadius = 25;
    _creatNew.tintColor = [UIColor redColor];
    [_creatNew addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_creatNew];
}

- (void)loadTextViewList{
    UITableView *noteList=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    noteList.rowHeight=140;
    //noteList.estimatedRowHeight = 100;
    noteList.dataSource=self;
    noteList.delegate=self;
    noteList.separatorStyle=UITableViewCellSeparatorStyleNone;
    _noteList=noteList;
    [self.view addSubview:_noteList];
}

- (void)gotoSeach{
    SeachViewController *seachView=[SeachViewController new];
    seachView.originalData=self.dataArr;
    seachView.delegate=self;
    [self.navigationController pushViewController:seachView animated:YES];
    [self reloadList];
}

- (void)goToSetting{
    SettingViewController *vc=[SettingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    [self reloadList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    textCell *cell = [textCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    [self selectCellWithIndex:indexPath];
    return cell;
}
#pragma mark 👀 创建新笔记👀
- (void)beginEdit{
    EditViewController *vc=[EditViewController new];
    vc.delegate=self;
    vc.isNew=YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self reloadList];
}
#pragma mark  被点击的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.allowsMultipleSelection) {
        [self.moreSelectedArr addObject:indexPath];
        [self selectCellWithIndex:indexPath];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditViewController *vc=[EditViewController new];
        vc.model=self.dataArr[indexPath.row];
        vc.indexPath=indexPath;
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
        [self reloadList];
    }
}
#pragma mark 👀 cell被取消选中状态👀
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.moreSelectedArr.count == 1) {
        [_noteList selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        return;
    }
    if (tableView.allowsMultipleSelection) {
        [self selectCellWithIndex:indexPath];
        [self.moreSelectedArr removeObject:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self didSwipeLeft:nil];
}
#pragma mark 🙏🏻 删除
- (void)willDelectCell:(textCell *)cell{
    [self deleteCell:[self calculateIndexPathForCell:cell]];
}

- (void)didSwipeLeft:(textCell *)cell{
    NSArray *arr = _noteList.subviews.firstObject.subviews;
    for (textCell *cellTemp in arr) {
        if (cellTemp != cell) {
            [cellTemp anyCellDidSwipeRight];
        }
    }
}
#pragma mark  cell长按后
- (void)longPressActionWithCell:(textCell *)cell{
    NSIndexPath *indexPath = [self calculateIndexPathForCell:cell];
    [_noteList selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    if (self.moreSelectedArr.count == 0) {
        [self.moreSelectedArr addObject:indexPath];
        [self selectCellWithIndex:indexPath];
    }
    _noteList.allowsMultipleSelection = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"longPress" object:nil];
    [self loadNavRightItems];
}
#pragma mark 👀 搜索后刷新数据👀
- (void)ViewControlller:(UIViewController *)viewController data:(NSMutableArray *)arr{
    self.dataArr = arr;
    [_noteList reloadData];
}
#pragma mark 👀 编辑后刷新数据👀
- (void)ViewController:(UIViewController *)viewController model:(textModel *)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath) {
        [self deleteCell:indexPath];
    }
    [self addCell:model];
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
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [_noteList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)addCell:(textModel *)model{
    [self.dataArr insertObject:model atIndex:0];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_noteList insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)deleteMore{
    if (self.moreSelectedArr.count>0) {
        for (NSIndexPath *indexPath in self.moreSelectedArr) {
            [self.dataArr removeObjectAtIndex:indexPath.row];
        }
        [_noteList deleteRowsAtIndexPaths:self.moreSelectedArr withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.moreSelectedArr removeAllObjects];
    [self deleteDone];
}

- (void)deleteDone{
    _noteList.allowsMultipleSelection = NO;
    NSArray *arrTemp = [self.moreSelectedArr copy];
    if (self.moreSelectedArr.count > 0) {
        for (NSIndexPath *index in arrTemp) {
            textCell *cell = [_noteList cellForRowAtIndexPath:index];
            [cell selectCell];
            [self.moreSelectedArr removeObject:index];
        }
    }
    [self loadNavRightItems];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notLongPress" object:nil];
}

- (NSIndexPath *)calculateIndexPathForCell:(textCell *)cell{
    NSInteger row = cell.frame.origin.y/cell.frame.size.height;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    return path;
}

- (void)selectCellWithIndex:(NSIndexPath *)indexPath{
    textCell *cell = [_noteList cellForRowAtIndexPath:indexPath];
    [cell selectCell];
}

- (void)reloadList{
    [_noteList reloadData];
}
@end
