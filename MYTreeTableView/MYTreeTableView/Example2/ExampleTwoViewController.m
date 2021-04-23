//
//  ExampleTwoViewController.m
//  MYTreeTableView
//
//  Created by mayan on 2021/4/23.
//

#import "ExampleTwoViewController.h"
#import "MYTreeTableView.h"
#import "DataService.h"

@interface ExampleTwoViewController () <MYTreeTableViewDelegate>

@property (nonatomic, strong) MYTreeTableView *tableView;

@end

@implementation ExampleTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 2";
    
    // 1. 自定义样式的参数设置, 你可以根据 MYTreeTableViewLayout.h 的参数说明, 在下面修改参数值试试
    MYTreeTableViewLayout *layout = [[MYTreeTableViewLayout alloc] init];
    layout.isSingleCheck = YES;
    layout.isCancelSingleCheck = YES;
    layout.isHiddenCheckTypeSet = [NSSet setWithObject:@"province"];
    layout.textColor = UIColor.blackColor;
    layout.textColorMap = @{ @"city": self.randomColor, @"district": self.randomColor };
    layout.font = [UIFont systemFontOfSize:16];
    layout.fontMap = @{ @"city": [UIFont systemFontOfSize:20], @"district": [UIFont systemFontOfSize:24] };
    layout.backgroundColor = self.randomColor;
    layout.backgroundColorMap = @{ @"city": self.randomColor, @"district": self.randomColor };
    
    // 更多自定义参数请参照 MYTreeTableViewLayout.h
    
    // 2. 初始化 MYTreeTableView
    self.tableView = [[MYTreeTableView alloc] initWithFrame:self.view.bounds treeTableViewLayout:layout];
    self.tableView.tableView.backgroundColor = layout.backgroundColor;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // 3. 请求数据并刷新 MYTreeTableView 列表
    [self requestData];
}

- (void)requestData {
    [DataService requestDataWithCompleted:^(NSSet<MYTreeItem *> *treeItems) {
        [self.tableView reloadDataWithTreeItems:treeItems];
    }];
}

// 获取随机颜色
- (UIColor *)randomColor {
    NSUInteger red   = arc4random() % 255;
    NSUInteger green = arc4random() % 255;
    NSUInteger blue  = arc4random() % 255;
    return [UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:1];
}

// 弹出提示框
- (void)presentAlertControllerWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [vc addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:vc animated:YES completion:nil];
        });
    });
}


#pragma mark - MYTreeTableViewDelegate

// 截取点击手势, 返回是否允许展开/折叠列表的布尔值, 例如, 用于点击某一个 Cell 实现页面跳转
- (BOOL)treeTableView:(MYTreeTableView *)treeTableView didSelectTreeItem:(MYTreeItem *)item {
    if ([item.type isEqualToString:@"district"]) {
        [self presentAlertControllerWithMessage:[NSString stringWithFormat:@"您点击了 %@", item.name]];
        return NO;
    } else {
        return YES;
    }
}

// 截取勾选手势, 返回是否允许勾选的布尔值, 例如, 用于判断是否应该勾选, 并且在初始化控件的时候还不能在 isHiddenCheckTypeSet 中设置隐藏勾选按钮
- (BOOL)treeTableView:(MYTreeTableView *)treeTableView didCheckTreeItem:(MYTreeItem *)item {
    if ([item.type isEqualToString:@"province"] || [item.type isEqualToString:@"city"]) {
        [self presentAlertControllerWithMessage:@"您不能勾选省份或者城市"];
        return NO;
    } else {
        return YES;
    }
}

@end
