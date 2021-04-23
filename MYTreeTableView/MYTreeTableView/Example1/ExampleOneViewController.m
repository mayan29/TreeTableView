//
//  ExampleOneViewController.m
//  MYTreeTableView
//
//  Created by mayan on 2021/4/23.
//

#import "ExampleOneViewController.h"
#import "MYTreeTableView.h"
#import "DataService.h"

@interface ExampleOneViewController ()

@property (nonatomic, strong) MYTreeTableView *tableView;

@end

@implementation ExampleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 1";
    
    // 1. 初始化 MYTreeTableView
    self.tableView = [[MYTreeTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    
    // 2. 请求数据并刷新 MYTreeTableView 列表
    [self requestData];
}

- (void)requestData {
    [DataService requestDataWithCompleted:^(NSSet<MYTreeItem *> *treeItems) {
        [self.tableView reloadDataWithTreeItems:treeItems];
    }];
}

@end
