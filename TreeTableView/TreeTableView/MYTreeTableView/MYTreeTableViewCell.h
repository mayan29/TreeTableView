//
//  MYTreeTableViewCell.h
//  MYTreeTableView
//
//  Created by mayan on 2018/4/4.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import <UIKit/UIKit.h>

@class MYTreeItem;
@interface MYTreeTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView andTreeItem:(MYTreeItem *)item;
- (void)updateItem;

@property (nonatomic, copy)   void (^checkButtonClickBlock)(MYTreeItem *item);
@property (nonatomic, assign) BOOL isShowArrow;
@property (nonatomic, assign) BOOL isShowCheck;
@property (nonatomic, assign) BOOL isShowLevelColor;


@end
