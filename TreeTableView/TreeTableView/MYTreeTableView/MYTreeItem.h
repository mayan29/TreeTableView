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

@property (nonatomic, readonly, copy)   NSString *name;
@property (nonatomic, readonly, strong) NSNumber *id;
@property (nonatomic, readonly, strong) NSNumber *parentId;
@property (nonatomic, readonly, strong) NSNumber *orderNo;  // 序号
@property (nonatomic, readonly, strong) NSString *type;
@property (nonatomic, readonly, assign) BOOL isLeaf;
@property (nonatomic, readonly, strong) id data;

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) MYTreeItemCheckState checkState;  // 勾选状态
@property (nonatomic, assign) BOOL isExpand;  // 是否为展开状态
@property (nonatomic, weak)   MYTreeItem *parentItem;
@property (nonatomic, strong) NSMutableArray<MYTreeItem *> *childItems;



/** 初始化 */
- (instancetype)initWithName:(NSString *)name id:(NSNumber *)id parentId:(NSNumber *)parentId orderNo:(NSNumber *)orderNo type:(NSString *)type isLeaf:(BOOL)isLeaf data:(id)data;

@end
