//
//  MYTreeTableViewCell.h
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MYTreeTableViewCell, MYTreeItem, MYTreeTableViewLayout;
@protocol MYTreeTableViewCellDelegate <NSObject>

- (void)treeTableViewCell:(MYTreeTableViewCell *)cell treeItem:(MYTreeItem *)treeItem didClickCheckButton:(UIButton *)button;

@end


@protocol MYTreeTableViewCell <NSObject>

@required
- (void)setTreeItem:(MYTreeItem *)treeItem;
- (void)setLayout:(MYTreeTableViewLayout *)layout;
- (void)setDelegate:(id<MYTreeTableViewCellDelegate>)delegate;

@end


@interface MYTreeTableViewCell : UITableViewCell <MYTreeTableViewCell>

@end

NS_ASSUME_NONNULL_END
