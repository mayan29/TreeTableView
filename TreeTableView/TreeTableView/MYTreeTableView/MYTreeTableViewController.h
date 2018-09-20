//
//  MYTreeTableViewController.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import <UIKit/UIKit.h>
#import "MYTreeTableManager.h"

@class MYTreeTableViewController;


// 子类中实现的 delegate
@protocol MYTreeTableViewControllerParentClassDelegate <NSObject>

/** 获取数据，创建模型，创建 manager */
- (MYTreeTableManager *)managerInTableViewController:(MYTreeTableViewController *)tableViewController;
/** 如果是单选，点击 cell 会直接调用，如果是多选，通过 prepareCommit 方法会调用 */
- (void)tableViewController:(MYTreeTableViewController *)tableViewController checkItems:(NSArray <MYTreeItem *>*)items;
/** 监控点击搜索框，埋点用 */
- (void)searchBarDidBeginEditingInTableViewController:(MYTreeTableViewController *)tableViewController;
/** 监听 cell 点击事件 */
- (void)tableViewController:(MYTreeTableViewController *)tableViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/** 监听 cell 的 checkbox 点击事件 */
- (void)tableViewController:(MYTreeTableViewController *)tableViewController didSelectCheckBoxRowAtIndexPath:(NSIndexPath *)indexPath;

@end

// 上一页面中实现的 delegate
@protocol MYTreeTableViewControllerDelegate <NSObject>

- (void)tableViewController:(MYTreeTableViewController *)tableViewController checkItems:(NSArray <MYTreeItem *>*)items;

@end


@interface MYTreeTableViewController : UITableViewController

@property (nonatomic, weak) id<MYTreeTableViewControllerParentClassDelegate> classDelegate;
@property (nonatomic, weak) id<MYTreeTableViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isSingleCheck;              // 是否是单选，默认 NO
@property (nonatomic, assign) BOOL isCancelSingleCheckSwitch;  // 是否单选时再次点击取消选择，默认 NO
@property (nonatomic, assign) BOOL isShowArrow;                // 是否显示文字前方的箭头图片，默认 YES
@property (nonatomic, assign) BOOL isShowCheck;                // 是否显示文字后方的勾选框，默认 YES
@property (nonatomic, assign) BOOL isShowLevelColor;           // 是否展示层级颜色，从 0 级开始排序，默认 NO
@property (nonatomic, assign) BOOL isShowSearchBar;            // 是否显示搜索框，默认 YES
@property (nonatomic, assign) BOOL isRealTimeSearch;           // 是否实时查询，默认 YES
@property (nonatomic, assign) BOOL isShowExpandAnimation;      // 是否显示展开/折叠动画，默认 YES

@property (nonatomic, strong) NSArray <NSString *>*checkItemIds;    // 从外部传进来的所选择的 itemIds
@property (nonatomic, strong) NSArray <UIColor *>*levelColorArray;  // 层级颜色，默认一级和二级分别为深灰色和浅灰色
@property (nonatomic, strong) UIColor *normalBackgroundColor;       // 默认背景色，默认为白色

/** 全部勾选/全部取消勾选 */
- (void)checkAllItem:(BOOL)isCheck;
/** 全部展开/全部折叠 */
- (void)expandAllItem:(BOOL)isExpand;
/** 展开/折叠到多少层级 */
- (void)expandItemWithLevel:(NSInteger)expandLevel;
/** 准备提交，调用代理方法 */
- (void)prepareCommit;
/** 获取当前显示的 showItems */
- (NSArray *)getShowItems;
/** 获取所有的 Items */
- (NSArray *)getAllItems;
/** 获取所有勾选的 Items */
- (NSArray *)getCheckItems;


@end
