//
//  MYTreeTableViewLayout.m
//  TreeTableView
//
//  Created by mayan on 2019/12/17.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "MYTreeTableViewLayout.h"

@implementation MYTreeTableViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _registerClass = NSClassFromString(@"MYTreeTableViewCell");
        _registerClassMap = [NSDictionary dictionary];
        _expansionLevel = 0;
        _isShowExpandedAnimation = YES;
        _isSingleCheck = NO;
        _isCancelSingleCheck = NO;
        _isCheckFollow = YES;
        _isShowCheck = YES;
        _isHiddenCheckTypeSet = [NSSet set];
        _isShowArrow = YES;
        _isShowArrowIfNoChildNode = YES;
        _textColor = UIColor.blackColor;
        _textColorMap = [NSDictionary dictionary];
        _font = [UIFont systemFontOfSize:14];
        _fontMap = [NSDictionary dictionary];
        _numberOfLines = 0;
        _numberOfLinesMap = [NSDictionary dictionary];
        _backgroundColor = UIColor.whiteColor;
        _backgroundColorMap = [NSDictionary dictionary];
        _isShowSearchBar = YES;
        _searchBarHeight = 50.f;
    }
    return self;
}

- (void)setRegisterClass:(Class)registerClass {
    if (registerClass) {
        _registerClass = registerClass;
    }
}

- (void)setRegisterClassMap:(NSDictionary<NSString *,Class> *)registerClassMap {
    if (registerClassMap) {
        _registerClassMap = registerClassMap;
    }
}

- (void)setIsHiddenCheckTypeSet:(NSSet<NSString *> *)isHiddenCheckTypeSet {
    if (isHiddenCheckTypeSet) {
        _isHiddenCheckTypeSet = isHiddenCheckTypeSet;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        _textColor = textColor;
    }
}

- (void)setTextColorMap:(NSDictionary<NSString *,UIColor *> *)textColorMap {
    if (textColorMap) {
        _textColorMap = textColorMap;
    }
}

- (void)setFont:(UIFont *)font {
    if (font) {
        _font = font;
    }
}

- (void)setFontMap:(NSDictionary<NSString *,UIFont *> *)fontMap {
    if (fontMap) {
        _fontMap = fontMap;
    }
}

- (void)setNumberOfLinesMap:(NSDictionary<NSString *,NSNumber *> *)numberOfLinesMap {
    if (numberOfLinesMap) {
        _numberOfLinesMap = numberOfLinesMap;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor) {
        _backgroundColor = backgroundColor;
    }
}

- (void)setBackgroundColorMap:(NSDictionary<NSString *,UIColor *> *)backgroundColorMap {
    if (backgroundColorMap) {
        _backgroundColorMap = backgroundColorMap;
    }
}

- (void)setSearchBarHeight:(CGFloat)searchBarHeight {
    _searchBarHeight = MAX(searchBarHeight, 0);
}


@end
