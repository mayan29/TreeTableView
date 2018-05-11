//
//  MYTreeItem.m
//  MYTreeTableView
//
//  Created by mayan on 2018/4/3.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYTreeItem.h"

@implementation MYTreeItem

- (instancetype)initWithName:(NSString *)name id:(NSNumber *)id parentId:(NSNumber *)parentId orderNo:(NSNumber *)orderNo type:(NSString *)type isLeaf:(BOOL)isLeaf data:(id)data {
    
    self = [super init];
    if (self) {
        _name       = name;
        _id         = id;
        _parentId   = parentId;
        _orderNo    = orderNo;
        _type       = type;
        _isLeaf     = isLeaf;
        _data       = data;
        _level      = 0;
        _isExpand   = NO;
        _checkState = MYTreeItemDefault;
        _childItems = [NSMutableArray array];
    }
    return self;
}

@end
