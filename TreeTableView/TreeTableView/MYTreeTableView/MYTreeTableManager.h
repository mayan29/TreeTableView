//
//  MYTreeTableManager.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYTreeItem.h"

@interface MYTreeTableManager : NSObject


/** 获取可见的节点 */
@property (nonatomic, readonly, strong) NSMutableArray<MYTreeItem *> *showItems;


/** 初始化 */
- (instancetype)initWithItems:(NSArray<MYTreeItem *> *)items andExpandLevel:(NSInteger)level;

/** 展开/收起 Item，返回所改变的 Item 的个数 */
- (NSInteger)expandItem:(MYTreeItem *)item;
- (NSInteger)expandItem:(MYTreeItem *)item isExpand:(BOOL)isExpand;

/** 勾选/取消勾选 Item */
- (void)checkItem:(MYTreeItem *)item;
- (void)checkItem:(MYTreeItem *)item isCheck:(BOOL)isCheck;
/** 全部勾选/全部取消勾选 */
- (void)checkAllItem:(BOOL)isCheck;
/** 获取所有已经勾选的 Item */
- (NSArray <MYTreeItem *>*)getAllCheckItem;

/** 根据 id 获取 item */
- (MYTreeItem *)getItemWithItemId:(NSNumber *)itemId;


@end
