//
//  MYTreeItem.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MYTreeItemCheckState) {
    MYTreeItemDefault,      // 不选择（默认）
    MYTreeItemChecked,      // 全选
    MYTreeItemHalfChecked,  // 半选
};

@interface MYTreeItem : NSObject

@property (nonatomic, readonly, copy) NSString *name;      // 名称
@property (nonatomic, readonly, copy) NSString *ID;        // 唯一标识
@property (nonatomic, readonly, copy) NSString *parentID;  // 父级节点唯一标识
@property (nonatomic, readonly, copy) NSString *orderNo;   // 序号
@property (nonatomic, readonly, copy) NSString *type;      // 类型
@property (nonatomic, readonly, assign) BOOL isLeaf;       // 是否叶子节点
@property (nonatomic, readonly, strong) id data;           // 原始数据

// 下列数据为 MYTreeTableManager 中内部设置，不能在外部直接设置
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) MYTreeItemCheckState checkState;
@property (nonatomic, weak)   MYTreeItem *parentItem;
@property (nonatomic, strong) NSMutableArray<MYTreeItem *> *childItems;

/** 初始化 */
- (instancetype)initWithName:(NSString *)name ID:(NSString *)ID parentID:(NSString *)parentID orderNo:(NSString *)orderNo type:(NSString *)type isLeaf:(BOOL)isLeaf data:(id)data;

@end
