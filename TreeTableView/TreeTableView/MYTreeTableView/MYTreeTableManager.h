//
//  MYTreeTableManager.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import <Foundation/Foundation.h>
#import "MYTreeItem.h"

@interface MYTreeTableManager : NSObject

/** 初始化，ExpandLevel 为 0 全部折叠，为 1 展开一级，以此类推，为 NSIntegerMax 全部展开 */
- (instancetype)initWithItems:(NSSet<MYTreeItem *> *)items andExpandLevel:(NSInteger)level;

/** 获取所有的 items */
@property (nonatomic, strong, readonly) NSMutableArray<MYTreeItem *> *allItems;
/** 获取可见的 items */
@property (nonatomic, strong, readonly) NSMutableArray<MYTreeItem *> *showItems;
/** 获取指定的 item */
- (MYTreeItem *)getItemById:(NSString *)itemId;
/** 获取所有已经勾选的 item */
@property (nonatomic, strong, readonly) NSArray<MYTreeItem *> *allCheckItem;

/** 展开/折叠到多少层级 */
- (void)expandItemWithLevel:(NSInteger)expandLevel completed:(void(^)(NSArray *noExpandArray))noExpandCompleted andCompleted:(void(^)(NSArray *expandArray))expandCompleted;
/** 展开/收起 item，返回所改变的 item 的个数 */
- (NSInteger)expandItem:(MYTreeItem *)item;
- (NSInteger)expandItem:(MYTreeItem *)item isExpand:(BOOL)isExpand;

/** 勾选/取消勾选 item */
- (void)checkItem:(MYTreeItem *)item isChildItemCheck:(BOOL)isChildItemCheck;
- (void)checkItem:(MYTreeItem *)item isCheck:(BOOL)isCheck isChildItemCheck:(BOOL)isChildItemCheck;
/** 全部勾选/全部取消勾选 */
- (void)checkAllItem:(BOOL)isCheck;

/** 筛选 */
- (void)filterField:(NSString *)field isChildItemCheck:(BOOL)isChildItemCheck;


@end
