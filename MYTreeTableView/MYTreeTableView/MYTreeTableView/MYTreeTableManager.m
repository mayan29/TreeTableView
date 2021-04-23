//
//  MYTreeTableManager.m
//  TreeTableView
//
//  Created by mayan on 2020/1/8.
//  Copyright © 2020 mayan. All rights reserved.
//

#import "MYTreeTableManager.h"
#import "MYTreeItem.h"
#import <objc/runtime.h>

@implementation MYTreeItem (Private)

#pragma mark - Getter and Setter

- (MYTreeItem *)parentItem {
    return objc_getAssociatedObject(self, @"parentItem");
}

- (void)setParentItem:(MYTreeItem *)parentItem {
    objc_setAssociatedObject(self, @"parentItem", parentItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<MYTreeItem *> *)childItems {
    NSArray *childItems = objc_getAssociatedObject(self, @"childItems") ?: [NSArray array];
    return [childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
        return [obj1.orderNo compare:obj2.orderNo];
    }];
}

- (void)setChildItems:(NSArray<MYTreeItem *> *)childItems {
   objc_setAssociatedObject(self, @"childItems", childItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)level {
    return [objc_getAssociatedObject(self, @"level") integerValue];
}

- (void)setLevel:(NSUInteger)level {
    objc_setAssociatedObject(self, @"level", @(level), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isExpanded {
    if (self.searchText.length > 0) {
        return [objc_getAssociatedObject(self, @"isSearchExpanded") boolValue];
    } else {
        return [objc_getAssociatedObject(self, @"isExpanded") boolValue];
    }
}

- (void)setIsExpanded:(BOOL)isExpanded {
    if (self.searchText.length > 0) {
        objc_setAssociatedObject(self, @"isSearchExpanded", @(isExpanded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, @"isExpanded", @(isExpanded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MYTreeItemCheckState)checkState {
    return [objc_getAssociatedObject(self, @"checkState") integerValue];
}

- (void)setCheckState:(MYTreeItemCheckState)checkState {
    objc_setAssociatedObject(self, @"checkState", @(checkState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)searchText {
    return objc_getAssociatedObject(self, @"searchText");
}

- (void)setSearchText:(NSString * _Nonnull)searchText {
    objc_setAssociatedObject(self, @"searchText", searchText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 刷新当前节点是否是关键字节点, 和当前节点的父节点是否是关键字节点的父节点
    if (searchText.length > 0) {
        self.isSearchItem = [self.name containsString:searchText];
        if (self.isSearchItem) {
            MYTreeItem *parentItem = self.parentItem;
            while (parentItem) {
                parentItem.isSearchParentItem = YES;
                parentItem = parentItem.parentItem;
            }
        }
    } else {
        self.isSearchItem = NO;
        self.isSearchParentItem = NO;
    }
}

- (BOOL)isSearchItem {
    return [objc_getAssociatedObject(self, @"isSearchItem") boolValue];
}

- (void)setIsSearchItem:(BOOL)isSearchItem {
    objc_setAssociatedObject(self, @"isSearchItem", @(isSearchItem), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSearchParentItem {
    return [objc_getAssociatedObject(self, @"isSearchParentItem") boolValue];
}

- (void)setIsSearchParentItem:(BOOL)isSearchParentItem {
    objc_setAssociatedObject(self, @"isSearchParentItem", @(isSearchParentItem), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<MYTreeItem *> *)searchChildItems {
    NSMutableArray *searchChildItems = [NSMutableArray array];
    for (MYTreeItem *item in self.childItems) {
        if (item.isSearchItem || item.isSearchParentItem) {
            [searchChildItems addObject:item];
        }
    }
    return searchChildItems.copy;
}


#pragma mark - Private Method

// 当前节点是否是该节点的父节点
- (BOOL)isParentOfItem:(MYTreeItem *)item {
    MYTreeItem *parentItem = item.parentItem;
    while (parentItem) {
        if ([parentItem.id isEqualToString:self.id]) {
            return YES;
        } else {
            parentItem = parentItem.parentItem;
        }
    }
    return NO;
}

// 通过子节点的勾选状态来获取当前节点的勾选状态
- (MYTreeItemCheckState)checkStateByChildCheckState {
    NSUInteger defaultNum = 0;
    NSUInteger checkedNum = 0;

    for (MYTreeItem *childItem in self.childItems) {
        
        if (childItem.checkState == MYTreeItemHalfChecked) {
            return MYTreeItemHalfChecked;
        } else if (childItem.checkState == MYTreeItemDefault) {
            defaultNum++;
        } else if (childItem.checkState == MYTreeItemChecked) {
            checkedNum++;
        }
        
        if (defaultNum > 0 && checkedNum > 0) {
            return MYTreeItemHalfChecked;
        }
    }
    
    return (defaultNum == self.childItems.count) ? MYTreeItemDefault : MYTreeItemChecked;
}

@end


@interface MYTreeTableManager ()

@property (nonatomic, strong) NSArray<MYTreeItem *> *treeItems;
@property (nonatomic, strong) NSDictionary<NSString *, MYTreeItem *> *treeItemsMap;
@property (nonatomic, strong) NSMutableArray<MYTreeItem *> *privateShowTreeItems;
@property (nonatomic, strong) NSMutableArray<MYTreeItem *> *privateSearchShowTreeItems;
@property (nonatomic, strong) NSMutableSet<MYTreeItem *> *checkedTreeItems;

@property (nonatomic, assign) NSUInteger expansionLevel;  // 展开层级级数
@property (nonatomic, assign) BOOL isSingleCheck;  // 是否为单选状态
@property (nonatomic, assign) BOOL isCheckFollow;  // 多选状态下，勾选一个节点，其父子节点是否会随之勾选
@property (nonatomic, assign) BOOL isCancelSingleCheck;  // 单选状态下，再次点击是否取消选择
@property (nonatomic, strong) NSString *searchText;  // 搜索文本

@end

@implementation MYTreeTableManager

#pragma mark - Init

- (instancetype)init NS_UNAVAILABLE {
    NSAssert(NO, @"MYTreeItem error: initialize with `initWithItems:`");
    return nil;
}

- (instancetype)initWithItems:(NSSet<MYTreeItem *> *)items {
    self = [super init];
    if (self) {
        // 1. 创建 map
        NSMutableDictionary *itemsMap = [NSMutableDictionary dictionary];
        for (MYTreeItem *item in items) {
            [itemsMap setObject:item forKey:item.id];
        }
        _treeItemsMap = itemsMap;
        
        // 2. 设置父子关系，并得到顶级节点数组
        NSMutableArray *treeItems = [NSMutableArray array];
        for (MYTreeItem *item in items) {
            MYTreeItem *parentItem = _treeItemsMap[item.parentId];
            if (parentItem) {
                item.parentItem = parentItem;
                if (![parentItem.childItems containsObject:item]) {
                    NSMutableArray *childItems = parentItem.childItems.mutableCopy;
                    [childItems addObject:item];
                    parentItem.childItems = childItems;
                }
            } else {
                [treeItems addObject:item];
            }
        }
        _treeItems = [treeItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }];
        
        // 3. 设置层级级数
        for (MYTreeItem *item in items) {
            NSUInteger level = 0;
            MYTreeItem *p = item.parentItem;
            while (p) {
                level++;
                p = p.parentItem;
            }
            item.level = level;
        }
        
        // 4. 其他
        _privateShowTreeItems       = _treeItems.mutableCopy;
        _privateSearchShowTreeItems = [NSMutableArray array];
        _checkedTreeItems           = [NSMutableSet set];
        _expansionLevel             = 0;
        _isSingleCheck              = NO;
        _isCheckFollow              = YES;
        _isCancelSingleCheck        = NO;
    }
    return self;
}


#pragma mark - Public Method

// 关键词搜索 & 更新 showTreeItems
- (void)updateShowTreeItemsWithSearchText:(NSString *)searchText {
    _searchText = searchText;
    
    // 更新所有节点的筛选关键字
    for (MYTreeItem *item in _treeItemsMap.allValues) {
        item.searchText = searchText;
    }
    
    // 更新 _privateSearchShowTreeItems
    if (self.isSearch) {
        NSMutableArray *searchShowTreeItems = [NSMutableArray array];
        for (MYTreeItem *item in _treeItems) {
            [self addTreeItem:item toSearchShowTreeItems:searchShowTreeItems];
        }
        _privateSearchShowTreeItems = searchShowTreeItems;
    } else {
        _privateSearchShowTreeItems = [NSMutableArray array];
    }
}

// 通过 id 获取节点对象
- (MYTreeItem *)itemWithId:(NSString *)itemId {
    return _treeItemsMap[itemId];
}

- (NSMutableArray<MYTreeItem *> *)showTreeItems {
    return self.isSearch > 0 ? _privateSearchShowTreeItems : _privateShowTreeItems;
}

// 设置展开层级级数
- (void)setExpansionLevel:(NSUInteger)expansionLevel {
    _expansionLevel = expansionLevel;
    
    NSMutableArray *showTreeItems = [NSMutableArray array];
    for (MYTreeItem *item in _treeItems) {
        [self addTreeItem:item toShowTreeItems:showTreeItems];
    }
    _privateShowTreeItems = showTreeItems;
}

// 展开/折叠一个节点
- (NSIndexSet *)expandItem:(MYTreeItem *)item {
    return [self expandItem:item isExpand:!item.isExpanded];
}

// 展开/折叠一个节点，明确设置展开状态
- (NSIndexSet *)expandItem:(MYTreeItem *)item isExpand:(BOOL)isExpand {
    if (!(item.isExpanded ^ isExpand)) return nil;
    
    item.isExpanded = isExpand;
    
    NSUInteger index = self.isSearch ? [_privateSearchShowTreeItems indexOfObject:item] : [_privateShowTreeItems indexOfObject:item];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    if (isExpand) {  // 展开
        NSArray<MYTreeItem *> *childItems = self.isSearch ? item.searchChildItems : item.childItems;
        [childItems enumerateObjectsUsingBlock:^(MYTreeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isExpanded = NO;
            [indexSet addIndex:(index + idx + 1)];
        }];
        if (self.isSearch) {
            [_privateSearchShowTreeItems insertObjects:childItems atIndexes:indexSet];
        } else {
            [_privateShowTreeItems insertObjects:childItems atIndexes:indexSet];
        }
    } else {  // 折叠
        NSMutableArray *showTreeItems = self.isSearch ? _privateSearchShowTreeItems : _privateShowTreeItems;
        [showTreeItems enumerateObjectsUsingBlock:^(MYTreeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > index) {
                if ([item isParentOfItem:obj]) {
                    [indexSet addIndex:idx];
                } else {
                    *stop = YES;
                }
            }
        }];
        [showTreeItems removeObjectsAtIndexes:indexSet];
    }
    return indexSet.copy;
}

// 获取所有已经勾选的节点集合（包括完全勾选和半勾选）
- (NSSet<MYTreeItem *> *)checkedTreeItemsWithHiddenCheckSet:(NSSet<NSString *> *)hiddenCheckSet {
    NSMutableSet *set = [NSMutableSet set];
    for (MYTreeItem *item in _checkedTreeItems) {
        if (![item isContainWithTypeSet:hiddenCheckSet]) {
            [set addObject:item];
        }
    }
    return set.copy;
}

// 设置是否为单选
- (void)setIsSingleCheck:(BOOL)isSingleCheck {
    if (_isSingleCheck != isSingleCheck) {
        // 清空所有勾选状态
        [self emptyAllCheckedTreeItems];
    }
    _isSingleCheck = isSingleCheck;
}

// 单选状态下，再次点击是否取消选择，默认 NO
- (void)setIsCancelSingleCheck:(BOOL)isCancelSingleCheck {
    _isCancelSingleCheck = isCancelSingleCheck;
}

// 多选状态下，勾选一个节点，其父子节点是否会随之勾选
- (void)setIsCheckFollow:(BOOL)isCheckFollow {
    if (_isSingleCheck == NO && _isCheckFollow != isCheckFollow) {
        // 清空所有勾选状态
        [self emptyAllCheckedTreeItems];
    }
    _isCheckFollow = isCheckFollow;
}

// 勾选/取消勾选一个节点
- (void)checkItem:(MYTreeItem *)item {
    if (item.checkState == MYTreeItemChecked) {
        if (_isSingleCheck) {
            if (_isCancelSingleCheck) {
                [self checkItem:item isCheck:NO];
            }
        } else {
            [self checkItem:item isCheck:NO];
        }
    } else {
        [self checkItem:item isCheck:YES];
    }
}

// 勾选/取消勾选一个节点，明确设置勾选状态
- (void)checkItem:(MYTreeItem *)item isCheck:(BOOL)isCheck {
    if (!((item.checkState == MYTreeItemChecked) ^ isCheck)) return;
    
    if (_isSingleCheck) {  // 单选
        // 清空所有勾选状态
        [self emptyAllCheckedTreeItems];
        
        if (isCheck) {
            item.checkState = MYTreeItemChecked;
            [_checkedTreeItems addObject:item];
        }
    } else {  // 多选
        if (_isCheckFollow) {
            // 1. 设置当前节点勾选状态，并更新其下面所有子节点的勾选状态
            [self setCheckState:((item.checkState == MYTreeItemChecked) ? MYTreeItemDefault : MYTreeItemChecked) withTreeItem:item];
            // 2. 设置当前节点的所有父节点的勾选状态
            [self updateParentCheckStateByTreeItem:item.parentItem];
        } else {
            if (isCheck) {
                item.checkState = MYTreeItemChecked;
                if (![_checkedTreeItems containsObject:item]) {
                    [_checkedTreeItems addObject:item];
                }
            } else {
                item.checkState = MYTreeItemDefault;
                [_checkedTreeItems removeObject:item];
            }
        }
    }
}


#pragma mark - Private Method

// 递归 - 根据展开层级级数将节点添加到 showTreeItems 中
- (void)addTreeItem:(MYTreeItem *)item toShowTreeItems:(NSMutableArray *)showTreeItems {
    if (item.level <= _expansionLevel) {
        item.isExpanded = !(item.level == _expansionLevel);
        [showTreeItems addObject:item];
        
        item.childItems = [item.childItems sortedArrayUsingComparator:^NSComparisonResult(MYTreeItem *obj1, MYTreeItem *obj2) {
            return [obj1.orderNo compare:obj2.orderNo];
        }];
        for (MYTreeItem *childItem in item.childItems) {
            [self addTreeItem:childItem toShowTreeItems:showTreeItems];
        }
    }
}

// 递归 - 根据关键字将节点添加到 searchShowTreeItems 中
- (void)addTreeItem:(MYTreeItem *)item toSearchShowTreeItems:(NSMutableArray *)searchShowTreeItems {
    if (item.isSearchItem || item.isSearchParentItem) {
        item.isExpanded = YES;
        [searchShowTreeItems addObject:item];
    }
    if (item.isSearchParentItem) {
        for (MYTreeItem *childItem in item.childItems) {
            [self addTreeItem:childItem toSearchShowTreeItems:searchShowTreeItems];
        }
    }
}

// 递归 - 设置当前节点勾选状态，并更新其下面所有子节点的勾选状态
- (void)setCheckState:(MYTreeItemCheckState)state withTreeItem:(MYTreeItem *)item {
    // 1. 设置当前节点勾选状态
    item.checkState = state;
    // 2. 如果当前节点添加到 _checkedTreeItems 中，或者从 _checkedTreeItems 中移除
    if (item.checkState == MYTreeItemChecked) {
        if (![_checkedTreeItems containsObject:item]) {
            [_checkedTreeItems addObject:item];
        }
    } else {
        [_checkedTreeItems removeObject:item];
    }
    // 3. 遍历其子节点，再次重复操作
    for (MYTreeItem *childItem in item.childItems) {
        [self setCheckState:state withTreeItem:childItem];
    }
}

// 递归 - 更新当前节点勾选状态，并同样更新其所有父节点的勾选状态
- (void)updateParentCheckStateByTreeItem:(MYTreeItem *)item {
    if (item) {
        // 1. 设置当前节点勾选状态
        item.checkState = item.checkStateByChildCheckState;
        // 2. 如果当前节点添加到 _checkedTreeItems 中，或者从 _checkedTreeItems 中移除
        if (item.checkState == MYTreeItemChecked) {
            if (![_checkedTreeItems containsObject:item]) {
                [_checkedTreeItems addObject:item];
            }
        } else {
            [_checkedTreeItems removeObject:item];
        }
        // 3. 遍历其父节点，再次重复操作
        if (item.parentItem) {
            [self updateParentCheckStateByTreeItem:item.parentItem];
        }
    }
}

// 清空所有勾选状态
- (void)emptyAllCheckedTreeItems {
    for (MYTreeItem *item in _checkedTreeItems) {
        item.checkState = MYTreeItemDefault;
    }
    _checkedTreeItems = [NSMutableSet set];
}

// 判断是关键字搜索状态还是普通状态
- (BOOL)isSearch {
    return _searchText.length > 0;
}


@end
