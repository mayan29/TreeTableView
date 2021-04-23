//
//  MYTreeTableManager.h
//  TreeTableView
//
//  Created by mayan on 2020/1/8.
//  Copyright © 2020 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MYTreeItem;
@interface MYTreeTableManager : NSObject

#pragma mark - Common Methods

// 初始化
- (instancetype)initWithItems:(NSSet<MYTreeItem *> *)items NS_DESIGNATED_INITIALIZER;
// 关键词搜索 & 更新 showTreeItems
- (void)updateShowTreeItemsWithSearchText:(NSString *)searchText;
// 通过 id 获取节点对象
- (MYTreeItem *)itemWithId:(NSString *)itemId;


#pragma mark - Expansion Methods

// 获取所有已经展开的节点列表
@property (nonatomic, readonly, strong) NSMutableArray<MYTreeItem *> *showTreeItems;
// 设置展开层级级数, 默认为 0
- (void)setExpansionLevel:(NSUInteger)expansionLevel;
// 展开/折叠一个节点, 重复执行此方法, 该节点会不断改变展开、折叠、展开的状态。返回 showTreeItems 中添加/删除的范围
- (NSIndexSet *)expandItem:(MYTreeItem *)item;
// 展开/折叠一个节点, 明确设置展开状态, 重复执行此方法, 该节点会一直设置为 isExpand 的状态。返回 showTreeItems 中添加/删除的范围
- (NSIndexSet *)expandItem:(MYTreeItem *)item isExpand:(BOOL)isExpand;


#pragma mark - Checked Methods

// 获取所有已经勾选的节点集合（包括完全勾选和半勾选）, hiddenCheckSet 为隐藏勾选按钮的集合, 详情参考 MYTreeTableViewLayout
- (NSSet<MYTreeItem *> *)checkedTreeItemsWithHiddenCheckSet:(NSSet<NSString *> *)hiddenCheckSet;
// 设置是否为单选, 默认为 NO（切换该状态，会清空当前已选择的节点）
- (void)setIsSingleCheck:(BOOL)isSingleCheck;
// 单选状态下, 再次点击是否取消选择, 默认 NO
- (void)setIsCancelSingleCheck:(BOOL)isCancelSingleCheck;
// 多选状态下, 勾选一个节点, 其父子节点是否会随之勾选, 默认为 YES（切换该状态, 会清空当前已选择的节点）
- (void)setIsCheckFollow:(BOOL)isCheckFollow;
// 勾选/取消勾选一个节点, 重复执行此方法, 该节点会不断改变勾选、取消勾选、勾选的状态
- (void)checkItem:(MYTreeItem *)item;
// 勾选/取消勾选一个节点, 明确设置勾选状态, 重复执行此方法, 该节点会一直设置为 isCheck 的状态
- (void)checkItem:(MYTreeItem *)item isCheck:(BOOL)isCheck;

@end

NS_ASSUME_NONNULL_END
