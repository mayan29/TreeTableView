//
//  MYTreeItem.h
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYTreeItem : NSObject

@property (nonatomic, readonly, copy) NSString *id;        // 唯一标识
@property (nonatomic, readonly, copy) NSString *name;      // 名称
@property (nonatomic, readonly, copy) NSString *parentId;  // 父级节点 id
@property (nonatomic, readonly, copy) NSString *orderNo;   // 序号（用于同一层级排序）
@property (nonatomic, readonly, copy) NSString *type;      // 类型
@property (nonatomic, readonly, assign) BOOL isLeaf;       // 是否叶子节点
@property (nonatomic, readonly, strong) id data;           // 原始数据

// 唯一初始化方法
- (instancetype)initWithId:(NSString *)id name:(NSString * __nullable)name parentId:(NSString * __nullable)parentId orderNo:(NSString *)orderNo type:(NSString *)type isLeaf:(BOOL)isLeaf data:(id)data NS_DESIGNATED_INITIALIZER;
// 当前节点是否存在于传入的集合中
- (BOOL)isContainWithTypeSet:(NSSet<NSString *> *)set;

@end


typedef NS_ENUM(NSUInteger, MYTreeItemCheckState) {
    MYTreeItemDefault,      // 不选择（默认）
    MYTreeItemChecked,      // 全选
    MYTreeItemHalfChecked,  // 半选
};

@interface MYTreeItem (Private)

@property (nonatomic, readonly, strong) MYTreeItem *parentItem;                   // 父节点
@property (nonatomic, readonly, strong) NSArray<MYTreeItem *> *childItems;        // 子节点
@property (nonatomic, readonly, assign) NSUInteger level;                         // 层级级数
@property (nonatomic, readonly, assign) BOOL isExpanded;                          // 是否展开
@property (nonatomic, readonly, assign) MYTreeItemCheckState checkState;          // 勾选状态
@property (nonatomic, readonly, strong) NSString *searchText;                     // 筛选的关键字
@property (nonatomic, readonly, assign) BOOL isSearchItem;                        // 是否是筛选关键字节点
@property (nonatomic, readonly, assign) BOOL isSearchParentItem;                  // 是否是筛选关键字节点的父节点

- (NSArray<MYTreeItem *> *)searchChildItems;  // 获取筛选关键字后的子节点

@end

NS_ASSUME_NONNULL_END
