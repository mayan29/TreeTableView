//
//  ExampleThreeViewController.m
//  MYTreeTableView
//
//  Created by mayan on 2021/4/23.
//

#import "ExampleThreeViewController.h"
#import "ExampleThreeViewCell.h"
#import "MYTreeTableView.h"
#import "DataService.h"

@interface ExampleThreeViewController ()

@property (nonatomic, strong) MYTreeTableView *tableView;

@end

@implementation ExampleThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 3";
    
    // 1. 自定义 cell
    MYTreeTableViewLayout *layout = [[MYTreeTableViewLayout alloc] init];
    layout.registerClassMap = @{ @"province": [ExampleThreeViewCell class] };
    
    // 2. 初始化 MYTreeTableView
    self.tableView = [[MYTreeTableView alloc] initWithFrame:self.view.bounds treeTableViewLayout:layout];
    [self.view addSubview:self.tableView];
    
    // 3. 请求数据并刷新 MYTreeTableView 列表
    [self requestData];
}

- (void)requestData {
    [DataService requestDataWithCompleted:^(NSSet<MYTreeItem *> *treeItems) {
        [self.tableView reloadDataWithTreeItems:treeItems];
    }];
}

@end
