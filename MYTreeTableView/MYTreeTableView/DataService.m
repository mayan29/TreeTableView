//
//  DataService.m
//  TreeTableView
//
//  Created by mayan on 2020/1/10.
//  Copyright © 2020 mayan. All rights reserved.
//

#import "DataService.h"
#import "MYTreeItem.h"

@implementation DataService

+ (void)requestDataWithCompleted:(void (^)(NSSet<MYTreeItem *> * _Nonnull))completedBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1. 请求数据
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityResource" ofType:@"json"]];
        NSArray *provinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        // 2. 创建 TreeItem 模型
        NSMutableSet *treeItems = [NSMutableSet set];

        // 遍历省份
        [provinceArray enumerateObjectsUsingBlock:^(NSDictionary *province, NSUInteger idx, BOOL * _Nonnull stop) {
            MYTreeItem *provinceItem = [[MYTreeItem alloc] initWithId:province[@"code"]
                                                                 name:province[@"name"]
                                                             parentId:nil
                                                              orderNo:[NSString stringWithFormat:@"%ld", idx]
                                                                 type:@"province"
                                                               isLeaf:NO
                                                                 data:province];
            [treeItems addObject:provinceItem];
            
            // 遍历城市
            [province[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *city, NSUInteger idx, BOOL * _Nonnull stop) {
                MYTreeItem *cityItem = [[MYTreeItem alloc] initWithId:city[@"code"]
                                                                 name:city[@"name"]
                                                             parentId:provinceItem.id
                                                              orderNo:[NSString stringWithFormat:@"%ld", idx]
                                                                 type:@"city"
                                                               isLeaf:NO
                                                                 data:city];
                [treeItems addObject:cityItem];
                
                // 遍历区
                [city[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *district, NSUInteger idx, BOOL * _Nonnull stop) {
                    MYTreeItem *districtItem = [[MYTreeItem alloc] initWithId:district[@"code"]
                                                                     name:district[@"name"]
                                                                 parentId:cityItem.id
                                                                  orderNo:[NSString stringWithFormat:@"%ld", idx]
                                                                     type:@"district"
                                                                   isLeaf:YES
                                                                     data:district];
                    [treeItems addObject:districtItem];
                }];
            }];
        }];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedBlock) {
                completedBlock(treeItems.copy);
            }
        });
    });
}


@end
