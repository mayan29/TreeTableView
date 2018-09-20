//
//  ViewController.m
//  TreeTableView
//
//  Created by mayan on 2018/5/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "ViewController.h"
#import "DemoTableViewController.h"
#import "MYTreeItem.h"

@interface ViewController () <MYTreeTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *isShowExpandAnimation;
@property (weak, nonatomic) IBOutlet UISwitch *isShowArrowIfNoChildNodeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isShowArrowSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isShowCheckSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isSingleCheckSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isCancelSingleCheckSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isShowLevelColorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isShowSearchBarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isRealTimeSearchSwitch;

@property (weak, nonatomic) IBOutlet UILabel  *showLabel;

@property (nonatomic, strong) NSArray <MYTreeItem *>*checkItems;  // 所选择的 items 传出来的数据

@end

@implementation ViewController

// 点击右上角 进入列表
- (IBAction)gotoTreeTableViewController:(UIBarButtonItem *)sender {
    
    // 这里的个性化设置也可以移到 DemoTableViewController 中的 viewDidLoad 执行
    DemoTableViewController *vc = [[DemoTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.delegate                  = self;
    vc.isSingleCheck             = self.isSingleCheckSwitch.isOn;
    vc.isCancelSingleCheckSwitch = self.isCancelSingleCheckSwitch.isOn;
    vc.isShowArrow               = self.isShowArrowSwitch.isOn;
    vc.isShowCheck               = self.isShowCheckSwitch.isOn;
    vc.isShowLevelColor          = self.isShowLevelColorSwitch.isOn;
    vc.isShowSearchBar           = self.isShowSearchBarSwitch.isOn;
    vc.checkItemIds              = [self getItemIds];
    vc.isShowExpandAnimation     = self.isShowExpandAnimation.isOn;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)getItemIds {
    
    // demo 中的逻辑判断没有处理的那么严谨，多选切换成单选后，当前多选选择的数据全部清空
    if (self.isSingleCheckSwitch.isOn && self.checkItems.count > 1) {
        self.checkItems = [NSArray array];
        self.showLabel.text = @"已选择了 0 个 items";
    }
    
    NSMutableArray *itemIds = [NSMutableArray array];
    for (MYTreeItem *item in self.checkItems) {
        [itemIds addObject:item.ID];
    }
    return itemIds.copy;
}


#pragma mark - MYTreeTableViewControllerDelegate

- (void)tableViewController:(MYTreeTableViewController *)tableViewController checkItems:(NSArray<MYTreeItem *> *)items {
    
    self.checkItems = items;
    self.showLabel.text = [NSString stringWithFormat:@"已选择了 %lu 个 items", (unsigned long)items.count];
}


@end
