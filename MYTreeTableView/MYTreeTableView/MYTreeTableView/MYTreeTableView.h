//
//  MYTreeTableView.h
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYTreeTableViewLayout.h"
#import "MYTreeItem.h"

NS_ASSUME_NONNULL_BEGIN

@class MYTreeTableView;
@protocol MYTreeTableViewDelegate <NSObject>

// 截取点击手势, 返回是否允许展开/折叠列表的布尔值, 例如, 用于点击某一个 Cell 实现页面跳转
- (BOOL)treeTableView:(MYTreeTableView *)treeTableView didSelectTreeItem:(MYTreeItem *)item;
// 截取勾选手势, 返回是否允许勾选的布尔值, 例如, 用于判断是否应该勾选, 并且在初始化控件的时候还不能在 isHiddenCheckTypeSet 中设置隐藏勾选按钮
- (BOOL)treeTableView:(MYTreeTableView *)treeTableView didCheckTreeItem:(MYTreeItem *)item;

@end


@interface MYTreeTableView : UIView

// 如需自定义 treeTableView 的样式，使用该方法初始化，在 treeTableViewLayout 中设置
- (instancetype)initWithFrame:(CGRect)frame treeTableViewLayout:(MYTreeTableViewLayout *)layout;
// 初始化数据 & 刷新列表
- (void)reloadDataWithTreeItems:(NSSet<MYTreeItem *> *)items;
// 关键词搜索 & 刷新列表
- (void)reloadDataWithSearchText:(NSString *)searchText;

@property (nonatomic, readonly, strong) UISearchBar *searchBar;
@property (nonatomic, readonly, strong) UITableView *tableView;
@property (nonatomic, weak) id<MYTreeTableViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
