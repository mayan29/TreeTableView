//
//  MYSearchTextField.h
//  TreeTableView
//
//  Created by mayan on 2018/5/11.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView
//
//  这里不用 UISearchBar 是因为 UITextField 的灵活性更高


#import <UIKit/UIKit.h>

@class MYTreeTableViewSearchBar;
@protocol MYTreeTableViewSearchBarDelegate <NSObject>

/** 点击搜索框 - 用于埋点 */
- (void)treeTableViewSearchBarDidBeginEditing:(MYTreeTableViewSearchBar *)searchBar;
/** 点击搜索键 */
- (void)treeTableViewSearchBarShouldReturn:(MYTreeTableViewSearchBar *)searchBar;
/** 实时查询搜索框中的文字 */
- (void)treeTableViewSearchBarDidEditing:(MYTreeTableViewSearchBar *)searchBar;

@end


@interface MYTreeTableViewSearchBar : UIView

@property (nonatomic, weak) id<MYTreeTableViewSearchBarDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *text;  // 获取当前搜索框中的文字
- (void)resignFirstResponder;  // 落下键盘

@end
