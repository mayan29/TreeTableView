//
//  DemoTableViewController.m
//  TreeTableView
//
//  Created by mayan on 2018/5/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "DemoTableViewController.h"

@interface DemoTableViewController () <MYTreeTableViewControllerParentClassDelegate>

@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建 提交 和 全选 按钮
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitItemClick)];
    UIBarButtonItem *allCheckItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(allCheckItemClick)];
    self.navigationItem.rightBarButtonItems = @[commitItem, allCheckItem];
    
    
    self.classDelegate = self;
}

// 点击右上角 提交
- (void)commitItemClick {
    [self prepareCommit];
}

// 点击右上角 全选
- (void)allCheckItemClick {
    [self checkAllItem:YES];
}


#pragma mark - MYTreeTableViewControllerParentClassDelegate

- (MYTreeTableManager *)managerInTableViewController:(MYTreeTableViewController *)tableViewController {
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"json"]];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *data in dataArray) {
        MYTreeItem *item = [[MYTreeItem alloc] initWithName:data[@"name"]
                                                         id:data[@"id"]
                                                   parentId:data[@"pid"]
                                                    orderNo:data[@"order_no"]
                                                       type:data[@"type"]
                                                     isLeaf:[data[@"type"] isEqualToString:@"ControlPoint"]
                                                       data:data];
        [items addObject:item];
    }
    return [[MYTreeTableManager alloc] initWithItems:items andExpandLevel:0];
}

- (void)tableViewController:(MYTreeTableViewController *)tableViewController checkItems:(NSArray<MYTreeItem *> *)items {
    
    // 这里加一个隔离带目的是可以在这里做出个性化操作，然后再将数据传出
    if ([self.delegate respondsToSelector:@selector(tableViewController:checkItems:)]) {
        [self.delegate tableViewController:self checkItems:items];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
