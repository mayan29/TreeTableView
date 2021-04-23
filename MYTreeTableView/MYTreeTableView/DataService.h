//
//  DataService.h
//  TreeTableView
//
//  Created by mayan on 2020/1/10.
//  Copyright © 2020 mayan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MYTreeItem;
@interface DataService : NSObject

// 模拟请求数据
+ (void)requestDataWithCompleted:(void (^)(NSSet<MYTreeItem *> *))completedBlock;

@end

NS_ASSUME_NONNULL_END
