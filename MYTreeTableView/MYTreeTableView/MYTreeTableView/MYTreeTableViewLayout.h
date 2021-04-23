//
//  MYTreeTableViewLayout.h
//  TreeTableView
//
//  Created by mayan on 2019/12/17.
//  Copyright © 2019 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYTreeTableViewLayout : NSObject

// 自定义 Cell, 默认为 MYTreeTableViewCell, 如果设置了 registerClassMap, 并声明了相应类型的 Class, 则优先于 registerClassMap 中的值
@property (nonatomic, strong) Class registerClass;
// 自定义 Cell, key 为模型对象的类型 type, value 为对应的 Cell 的 Class, 没有设置对应类型的 Class 默认为 MYTreeTableViewCell
@property (nonatomic, strong) NSDictionary<NSString *, Class> *registerClassMap;

// 初始化展开的层级级数, 默认为 0
@property (nonatomic, assign) NSUInteger expansionLevel;
// 是否显示展开/折叠动画, 默认 YES
@property (nonatomic, assign) BOOL isShowExpandedAnimation;

// 是否单选, 默认 NO
@property (nonatomic, assign) BOOL isSingleCheck;
// 单选状态下, 再次点击是否取消选择, 默认 NO
@property (nonatomic, assign) BOOL isCancelSingleCheck;
// 多选状态下, 勾选一个节点, 其父子节点是否会随之勾选, 默认为 YES
@property (nonatomic, assign) BOOL isCheckFollow;

// 是否显示文字后方的勾选框, 默认 YES
@property (nonatomic, assign) BOOL isShowCheck;
// 不显示文字后方的勾选框的集合, 集合中的 item 为模型对象的类型 type
@property (nonatomic, strong) NSSet<NSString *> *isHiddenCheckTypeSet;
// 是否显示文字前方的箭头图片, 默认 YES
@property (nonatomic, assign) BOOL isShowArrow;
// 是否没有子节点也显示箭头, 默认 YES
@property (nonatomic, assign) BOOL isShowArrowIfNoChildNode;

// 设置文字颜色, 默认黑色, 如果设置了 textColorMap, 并声明了相应类型的颜色, 则优先于 textColorMap 中的值
@property (nonatomic, strong) UIColor *textColor;
// 设置文字颜色, 默认黑色, key 为模型对象的类型 type, value 为对应的文字颜色
@property (nonatomic, strong) NSDictionary<NSString *, UIColor *> *textColorMap;
// 设置文字大小, 默认 14
@property (nonatomic, strong) UIFont *font;
// 设置文字大小, 默认 14, key 为模型对象的类型 type, value 为对应的文字大小
@property (nonatomic, strong) NSDictionary<NSString *, UIFont *> *fontMap;
// 设置文字折行行数, 默认 0
@property (nonatomic, assign) NSUInteger numberOfLines;
// 设置文字折行行数, 默认 0, key 为模型对象的类型 type, value 为对应的文字折行行数
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *numberOfLinesMap;
// 设置背景颜色, 默认白色
@property (nonatomic, strong) UIColor *backgroundColor;
// 设置背景颜色, 默认白色, key 为模型对象的类型 type, value 为对应的背景颜色
@property (nonatomic, strong) NSDictionary<NSString *, UIColor *> *backgroundColorMap;

// 是否显示搜索框, 默认为 YES
@property (nonatomic, assign) BOOL isShowSearchBar;
// 设置搜索框高度, 默认为 40
@property (nonatomic, assign) CGFloat searchBarHeight;

@end

NS_ASSUME_NONNULL_END
