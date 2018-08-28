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

/** 点击 search 键 */
- (void)treeTableViewSearchBarShouldReturn:(MYTreeTableViewSearchBar *)searchBar;
/** 点击清除数据键 */
- (void)treeTableViewSearchBarShouldClear:(MYTreeTableViewSearchBar *)searchBar;
/** 实时查询搜索框中的文字 */
- (void)treeTableViewSearchBarEditingChanged:(MYTreeTableViewSearchBar *)searchBar;
/** 监控点击搜索框，埋点用 */
- (void)treeTableViewSearchBarShouldBeginEditing:(MYTreeTableViewSearchBar *)searchBar;

@end


@interface MYTreeTableViewSearchBar : UIView

@property (nonatomic, weak) id <MYTreeTableViewSearchBarDelegate> delegate;
/** 设置文字 */
@property (nonatomic, copy) NSString *text;
/** 落下键盘 */
- (void)resignFirstResponder;

@end
