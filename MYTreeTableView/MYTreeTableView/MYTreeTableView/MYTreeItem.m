//
//  MYTreeItem.m
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "MYTreeItem.h"

@implementation MYTreeItem

#pragma mark - Init

- (instancetype)init NS_UNAVAILABLE {
    NSAssert(NO, @"MYTreeItem error: initialize with `initWithId:name:parentId:orderNo:type:data:`");
    return nil;
}

- (instancetype)initWithId:(NSString *)id name:(NSString *)name parentId:(NSString *)parentId orderNo:(NSString *)orderNo type:(nonnull NSString *)type isLeaf:(BOOL)isLeaf data:(nonnull id)data {
    self = [super init];
    if (self) {
        _id         = [NSString stringWithFormat:@"%@", id];
        _name       = [NSString stringWithFormat:@"%@", name];
        _parentId   = [NSString stringWithFormat:@"%@", parentId];
        _orderNo    = [NSString stringWithFormat:@"%@", orderNo];
        _type       = [NSString stringWithFormat:@"%@", type];
        _isLeaf     = isLeaf;
        _data       = data;
    }
    return self;
}

// 当前节点是否存在于传入的集合中
- (BOOL)isContainWithTypeSet:(NSSet<NSString *> *)set {
    for (NSString *type in set) {
        if ([self.type isEqualToString:type]) {
            return YES;
        }
    }
    return NO;
}

@end



