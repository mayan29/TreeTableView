//
//  MYTreeTableViewController.m
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYTreeTableViewController.h"
#import "MYTreeTableManager.h"
#import "MYTreeTableViewCell.h"

@interface MYTreeTableViewController ()

@property (nonatomic, strong) MYTreeTableManager *manager;
@property (nonatomic, strong) UIRefreshControl   *myRefreshControl;

@end

@implementation MYTreeTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isSingleCheck    = NO;
        self.isShowArrow      = YES;
        self.isShowCheck      = YES;
        self.isShowLevelColor = NO;
        
        self.normalBackgroundColor = [UIColor whiteColor];
        self.levelColorArray = @[[self getColorWithRed:230 green:230 blue:230],
                                 [self getColorWithRed:238 green:238 blue:238]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.myRefreshControl = [[UIRefreshControl alloc] init];
    self.myRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.myRefreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.myRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)refreshData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if ([self.classDelegate respondsToSelector:@selector(managerInTableViewController:)]) {
            
            self.manager = [self.classDelegate managerInTableViewController:self];
            
            // 遍历外部传来的所选择的 itemId
            for (NSString *itemId in self.checkItemIds) {
                MYTreeItem *item = [self.manager getItemWithItemId:itemId];
                if (item) {
                    [self.manager checkItem:item isCheck:YES];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.myRefreshControl endRefreshing];
        });
    });
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYTreeItem *item = self.manager.showItems[indexPath.row];
    
    MYTreeTableViewCell *cell = [MYTreeTableViewCell cellWithTableView:tableView andTreeItem:item];
    cell.isShowArrow      = self.isShowArrow;
    cell.isShowCheck      = self.isShowCheck;
    cell.isShowLevelColor = self.isShowLevelColor;
    
    if ((item.level < self.levelColorArray.count) && self.isShowLevelColor) {
        cell.backgroundColor = self.levelColorArray[item.level];
    } else {
        cell.backgroundColor = self.normalBackgroundColor;
    }

    __weak typeof(self)wself = self;
    cell.checkButtonClickBlock = ^(MYTreeItem *item) {
        
        [wself.manager checkItem:item];
        [wself.tableView reloadData];
        
        // 如果是单选，除了勾选之外，还需把勾选的 item 传出去
        if (wself.isSingleCheck) {
            if ([wself.classDelegate respondsToSelector:@selector(tableViewController:checkItems:)]) {
                [wself.classDelegate tableViewController:wself checkItems:@[item]];
            }
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    MYTreeItem *item = self.manager.showItems[indexPath.row];
    
    NSInteger updateNum = [self.manager expandItem:item];
    NSArray *updateIndexPaths = [self getUpdateIndexPathsWithCurrentIndexPath:indexPath andUpdateNum:updateNum];
    
    if (item.isExpand) {
        [tableView insertRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    MYTreeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell updateItem];

}


#pragma mark - Private Method

- (NSArray <NSIndexPath *>*)getUpdateIndexPathsWithCurrentIndexPath:(NSIndexPath *)indexPath andUpdateNum:(NSInteger)updateNum {
    
    NSMutableArray *tmpIndexPaths = [NSMutableArray arrayWithCapacity:updateNum];
    for (int i = 0; i < updateNum; i++) {
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
        [tmpIndexPaths addObject:tmp];
    }
    return tmpIndexPaths;
}

- (UIColor *)getColorWithRed:(NSInteger)redNum green:(NSInteger)greenNum blue:(NSInteger)blueNum {
    return [UIColor colorWithRed:redNum/255.0 green:greenNum/255.0 blue:blueNum/255.0 alpha:1.0];
}


#pragma mark - Public Method

- (void)checkAllItem:(BOOL)isCheck {
    [self.manager checkAllItem:isCheck];
    [self.tableView reloadData];
}

- (void)prepareCommit {
    
    // 所勾选的 items
    NSArray *checkItems = [self.manager getAllCheckItem];
    
    if ([self.classDelegate respondsToSelector:@selector(tableViewController:checkItems:)]) {
        [self.classDelegate tableViewController:self checkItems:checkItems];
    }
}


@end
