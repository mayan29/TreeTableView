//
//  MYTreeTableManager.m
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import "MYTreeTableManager.h"
#import "MYTreeItem.h"

@interface MYTreeTableManager ()

@property (nonatomic, strong) NSDictionary<NSString *, MYTreeItem *> *itemsMap;
@property (nonatomic, strong) NSMutableArray <MYTreeItem *>*topItems;
@property (nonatomic, strong) NSMutableArray <MYTreeItem *>*tmpItems;
@property (nonatomic, assign) NSInteger maxLevel;   // 获取最大等级
@property (nonatomic, assign) NSInteger showLevel;  // 设置最大的等级

@end

@implementation MYTreeTableManager


#pragma mark - Init

- (instancetype)initWithItems:(NSSet<MYTreeItem *> *)items andExpandLevel:(NSInteger)level
{
    self = [super init];
    if (self) {
        
        // 1. 建立 MAP
        [self setupItemsMapByItems:items];
        
        // 2. 建立父子关系，并得到顶级节点
        [self setupTopItemsWithFilterField:nil];
        
        // 3. 设置等级
        [self setupItemsLevel];
        
        // 4. 根据展开等级设置 showItems
        [self setupShowItemsWithShowLevel:level];
    }
    return self;
}

// 建立 MAP
- (void)setupItemsMapByItems:(NSSet *)items {
    
    NSMutableDictionary *itemsMap = [NSMutableDictionary dictionary];
    for (MYTreeItem *item in items) {
        [itemsMap setObject:item forKey:item.ID];
    }
    self.itemsMap = itemsMap.copy;
}

// 建立父子关系，并得到顶级节点
- (void)setupTopItemsWithFilterField:(NSString *)field {
    
    self.tmpItems = self.itemsMap.allValues.mutableCopy;
    
    // 建立父子关系
    NSMutableArray *topItems = [NSMutableArray array];
    for (MYTreeItem *item in self.tmpItems) {
        
        item.isExpand = NO;
        
        MYTreeItem *parent = self.itemsMap[item.parentID];
        if (parent) {
            item.parentItem = parent;
            if (![parent.childItems containsObject:item]) {
                [parent.childItems addObject:item];
            }
        } else {
            [topItems addObject:item];
        }
    }
    
    // 顶级节点排序
    self.topItems = [topItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
        return [obj1.orderNo compare:obj2.orderNo];
    }].mutableCopy;
    
    // 所有 item 排序
    for (MYTreeItem *item in self.tmpItems) {
        item.childItems = [item.childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
    }
}

// 设置等级
- (void)setupItemsLevel {
    
    for (MYTreeItem *item in self.tmpItems) {
        int tmpLevel = 0;
        MYTreeItem *p = item.parentItem;
        while (p) {
            tmpLevel++;
            p = p.parentItem;
        }
        item.level = tmpLevel;
        
        // 设置最大等级
        _maxLevel = MAX(_maxLevel, tmpLevel);
    }
}

// 根据展开等级设置 showItems
- (void)setupShowItemsWithShowLevel:(NSInteger)level {
    
    _showLevel = MAX(level, 0);
    _showLevel = MIN(level, _maxLevel);
 
    NSMutableArray *showItems = [NSMutableArray array];
    for (MYTreeItem *item in self.topItems) {
        [self addItem:item toShowItems:showItems andAllowShowLevel:_showLevel];
    }
    _showItems = showItems;
}

- (void)addItem:(MYTreeItem *)item toShowItems:(NSMutableArray *)showItems andAllowShowLevel:(NSInteger)level {
    
    if (item.level <= level) {
        
        [showItems addObject:item];
        
        item.isExpand = !(item.level == level);
        item.childItems = [item.childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (MYTreeItem *childItem in item.childItems) {
            [self addItem:childItem toShowItems:showItems andAllowShowLevel:level];
        }
    }
}


#pragma mark - Expand Item

// 展开/收起 Item，返回所改变的 Item 的个数
- (NSInteger)expandItem:(MYTreeItem *)item {
    return [self expandItem:item isExpand:!item.isExpand];
}

- (NSInteger)expandItem:(MYTreeItem *)item isExpand:(BOOL)isExpand {
    
    if (item.isExpand == isExpand) return 0;
    item.isExpand = isExpand;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    // 如果展开
    if (isExpand) {
        for (MYTreeItem *tmpItem in item.childItems) {
            [self addItem:tmpItem toTmpItems:tmpArray];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.showItems indexOfObject:item] + 1, tmpArray.count)];
        [self.showItems insertObjects:tmpArray atIndexes:indexSet];
    }
    // 如果折叠
    else {
        for (MYTreeItem *tmpItem in self.showItems) {
            
            BOOL isParent = NO;
            
            MYTreeItem *parentItem = tmpItem.parentItem;
            while (parentItem) {
                if (parentItem == item) {
                    isParent = YES;
                    break;
                }
                parentItem = parentItem.parentItem;
            }
            if (isParent) {
                [tmpArray addObject:tmpItem];
            }
        }
        [self.showItems removeObjectsInArray:tmpArray];
    }
    
    return tmpArray.count;
}
- (void)addItem:(MYTreeItem *)item toTmpItems:(NSMutableArray *)tmpItems {
    
    [tmpItems addObject:item];
    
    if (item.isExpand) {
        
        item.childItems = [item.childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (MYTreeItem *tmpItem in item.childItems) {
            [self addItem:tmpItem toTmpItems:tmpItems];
        }
    }
}

// 展开/折叠到多少层级
- (void)expandItemWithLevel:(NSInteger)expandLevel completed:(void (^)(NSArray *))noExpandCompleted andCompleted:(void (^)(NSArray *))expandCompleted {
    
    expandLevel = MAX(expandLevel, 0);
    expandLevel = MIN(expandLevel, self.maxLevel);
    
    // 先一级一级折叠
    for (NSInteger level = self.maxLevel; level >= expandLevel; level--) {
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.showItems.count; i++) {
            
            MYTreeItem *item = self.showItems[i];
            if (item.isExpand && item.level == level) {
                [itemArray addObject:item];
            }
        }
        
        if (itemArray.count) {
            if (noExpandCompleted) {
                noExpandCompleted(itemArray);
            }
        }
    }
    
    // 再一级一级展开
    for (NSInteger level = 0; level < expandLevel; level++) {
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.showItems.count; i++) {
            
            MYTreeItem *item = self.showItems[i];
            if (!item.isExpand && item.level == level) {
                [itemArray addObject:item];
            }
        }
        
        if (itemArray.count) {
            if (expandCompleted) {
                expandCompleted(itemArray);
            }
        }
    }
}


#pragma mark - Check Item

// 勾选/取消勾选 Item
- (void)checkItem:(MYTreeItem *)item isChildItemCheck:(BOOL)isChildItemCheck {
    [self checkItem:item isCheck:!(item.checkState == MYTreeItemChecked) isChildItemCheck:isChildItemCheck];
}

- (void)checkItem:(MYTreeItem *)item isCheck:(BOOL)isCheck isChildItemCheck:(BOOL)isChildItemCheck {
    
    if (item.checkState == MYTreeItemChecked && isCheck) return;
    if (item.checkState == MYTreeItemDefault && !isCheck) return;
    
    // 勾选/取消勾选所有子 item
    [self checkChildItemWithItem:item isCheck:isCheck isChildItemCheck:isChildItemCheck];
    // 刷新父 item 勾选状态
    [self refreshParentItemWithItem:item isChildItemCheck:isChildItemCheck];
}
// 递归，勾选/取消勾选子 item
- (void)checkChildItemWithItem:(MYTreeItem *)item isCheck:(BOOL)isCheck isChildItemCheck:(BOOL)isChildItemCheck {
    
    item.checkState = isCheck ? MYTreeItemChecked : MYTreeItemDefault;
    
    for (MYTreeItem *tmpItem in item.childItems) {
        // 如果是多选，勾选了 item 可以作用于子 item
        if (isChildItemCheck) {
            [self checkChildItemWithItem:tmpItem isCheck:isCheck isChildItemCheck:isChildItemCheck];
        } else {
            [self checkChildItemWithItem:tmpItem isCheck:NO isChildItemCheck:isChildItemCheck];
        }
    }
}
// 递归，刷新父 item 勾选状态
- (void)refreshParentItemWithItem:(MYTreeItem *)item isChildItemCheck:(BOOL)isChildItemCheck {
    
    if (isChildItemCheck) {
        
        NSInteger defaultNum = 0;
        NSInteger checkedNum = 0;
        
        for (MYTreeItem *tmpItem in item.parentItem.childItems) {
            
            switch (tmpItem.checkState) {
                case MYTreeItemDefault:
                    defaultNum++;
                    break;
                case MYTreeItemChecked:
                    checkedNum++;
                    break;
                case MYTreeItemHalfChecked:
                    break;
            }
        }
        
        if (defaultNum == item.parentItem.childItems.count) {
            item.parentItem.checkState = MYTreeItemDefault;
        }
        else if (checkedNum == item.parentItem.childItems.count) {
            item.parentItem.checkState = MYTreeItemChecked;
        }
        else {
            item.parentItem.checkState = MYTreeItemHalfChecked;
        }
        
    } else {
        item.parentItem.checkState = MYTreeItemDefault;
    }
    
    if (item.parentItem) {
        [self refreshParentItemWithItem:item.parentItem isChildItemCheck:isChildItemCheck];
    }
}

// 全部勾选/全部取消勾选
- (void)checkAllItem:(BOOL)isCheck {
    
    for (MYTreeItem *item in _showItems) {
        // 防止重复遍历
        if (item.level == 0) {
            [self checkChildItemWithItem:item isCheck:isCheck isChildItemCheck:YES];
        }
    }
}


#pragma mark - Filter Item

// 筛选
- (void)filterField:(NSString *)field isChildItemCheck:(BOOL)isChildItemCheck {
    
    [self setupTopItemsWithFilterField:field];
    
    // 筛选
    if (field.length) {
        
        for (MYTreeItem *item in self.tmpItems) {
            
            NSArray *childItems  = [self getAllChildItemsWithItem:item];
            if ([self isContainField:field andItems:childItems]) {
                item.isExpand = YES;
                continue;
            }
            
            if ([self isContainField:field andItems:@[item]]) {
                continue;
            }
            
            NSArray *parentItems = [self getAllParentItemsWithItem:item];
            if ([self isContainField:field andItems:parentItems]) {
                continue;
            }
            
            // 如果都不存在
            [item.parentItem.childItems removeObject:item];
            
            if ([self.topItems containsObject:item]) {
                [self.topItems removeObject:item];
            }
            
            for (MYTreeItem *item in childItems) {
                [item.parentItem.childItems removeObject:item];
            }
        }
    }
    
    // 设置 showItems
    if (field.length) {
        NSMutableArray *showItems = [NSMutableArray array];
        for (MYTreeItem *item in self.topItems) {
            [self addItem:item toShowItems:showItems];
        }
        _showItems = showItems;
    }
    else {
        [self setupShowItemsWithShowLevel:_showLevel];
    }
    
    // 刷新勾选状态
    for (MYTreeItem *item in self.tmpItems) {
        // 刷新父 item 勾选状态
        [self refreshParentItemWithItem:item isChildItemCheck:isChildItemCheck];
    }
}
- (void)addItem:(MYTreeItem *)item toShowItems:(NSMutableArray *)showItems {
    
    [showItems addObject:item];
    
    if (item.childItems.count) {
        
        item.childItems = [item.childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }].mutableCopy;
        
        for (MYTreeItem *childItem in item.childItems) {
            if (item.isExpand) {
                [self addItem:childItem toShowItems:showItems];
            }
        }
    }
}


#pragma mark - Get

// 根据 id 获取 item
- (MYTreeItem *)getItemById:(NSString *)itemId {
    
    if (itemId) {
        return self.itemsMap[itemId];
    } else {
        return nil;
    }
}

// 获取所有已经勾选的 item
- (NSArray<MYTreeItem *> *)allCheckItem {
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (MYTreeItem *item in _showItems) {
        // 防止重复遍历
        if (item.level == 0) {
            [self getAllCheckItem:tmpArray andItem:item];
        }
    }
    
    return tmpArray.copy;
}
// 递归，将已经勾选的 Item 添加到临时数组中
- (void)getAllCheckItem:(NSMutableArray <MYTreeItem *>*)tmpArray andItem:(MYTreeItem *)tmpItem {
    
    if (tmpItem.checkState == MYTreeItemDefault) return;
    if (tmpItem.checkState == MYTreeItemChecked) [tmpArray addObject:tmpItem];
    
    for (MYTreeItem *item in tmpItem.childItems) {
        [self getAllCheckItem:tmpArray andItem:item];
    }
}


#pragma mark - Other

// 获取该 item 下面所有子 item
- (NSArray *)getAllChildItemsWithItem:(MYTreeItem *)item {
    
    NSMutableArray *childItems = [NSMutableArray array];
    
    [self addItem:item toChildItems:childItems];
    
    return childItems;
}
// 递归，获取该 item 下面所有子 item
- (void)addItem:(MYTreeItem *)item toChildItems:(NSMutableArray *)childItems {
    
    for (MYTreeItem *childItem in item.childItems) {
        
        [childItems addObject:childItem];
        [self addItem:childItem toChildItems:childItems];
    }
}

// 获取该 item 的所有父 item
- (NSArray *)getAllParentItemsWithItem:(MYTreeItem *)item {
    
    NSMutableArray *parentItems = [NSMutableArray array];
    
    MYTreeItem *parentItem = item.parentItem;
    while (parentItem) {
        [parentItems addObject:parentItem];
        parentItem = parentItem.parentItem;
    }
    
    return parentItems;
}

// item 数组中是否包含该字段
- (BOOL)isContainField:(NSString *)field andItems:(NSArray *)items {
    
    BOOL isContain = NO;
    for (MYTreeItem *item in items) {
        if ([item.name containsString:field]) {
            isContain = YES;
            break;
        }
    }
    return isContain;
}


@end
