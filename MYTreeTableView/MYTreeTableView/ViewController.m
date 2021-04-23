//
//  ViewController.m
//  MYTreeTableView
//
//  Created by mayan on 2021/4/23.
//

#import "ViewController.h"
#import "ExampleOneViewController.h"
#import "ExampleTwoViewController.h"
#import "ExampleThreeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


#pragma mark - UITabBarDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = UIColor.blackColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = UIColor.grayColor;
        cell.detailTextLabel.numberOfLines = 0;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Example 1 - 默认设置";
            cell.detailTextLabel.text = @"几行代码展示基本功能, 让你大概了解这个控件是干啥的";
            break;
        case 1:
            cell.textLabel.text = @"Example 2 - 自定义样式";
            cell.detailTextLabel.text = @"多种自定义参数设置和手势交互判断, 基本能满足大多数开发者的需求了";
            break;
        case 2:
            cell.textLabel.text = @"Example 3 - 自定义 cell";
            cell.detailTextLabel.text = @"实在满足不了你, 就自己实现 cell 吧, 适用于对 UI 界面有强烈要求的开发者";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[ExampleOneViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[ExampleTwoViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[ExampleThreeViewController alloc] init] animated:YES];
            break;
    }
}

@end
