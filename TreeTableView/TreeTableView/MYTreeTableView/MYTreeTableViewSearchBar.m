//
//  MYSearchTextField.m
//  TreeTableView
//
//  Created by mayan on 2018/5/11.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import "MYTreeTableViewSearchBar.h"

@interface MYTreeTableViewSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation MYTreeTableViewSearchBar


#pragma mark - Lazy Load

- (UITextField *)textField
{
    if (!_textField) {
        
        CGFloat x = 5;
        CGFloat y = 5;
        CGFloat w = self.bounds.size.width - 10;
        CGFloat h = self.bounds.size.height - 10;
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _textField.backgroundColor    = self.backgroundColor;
        _textField.textColor          = [self getColorWithRed:51 green:51 blue:51];
        _textField.font               = [UIFont systemFontOfSize:15];
        _textField.placeholder        = @"请输入关键字搜索";
        _textField.borderStyle        = UITextBorderStyleRoundedRect;
        _textField.returnKeyType      = UIReturnKeySearch;
        _textField.secureTextEntry    = NO;
        _textField.clearButtonMode    = UITextFieldViewModeAlways;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.delegate           = self;
        _textField.leftView           = [self getLeftViewWithTextFieldHeight:h];
        _textField.leftViewMode       = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(showText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textField];
    }
    return self;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(treeTableViewSearchBarShouldReturn:)]) {
        [self.delegate treeTableViewSearchBarShouldReturn:self];
    }
    return YES;
}

- (void)showText:(UITextField *)searchTextField {
    
    if ([self.delegate respondsToSelector:@selector(treeTableViewSearchBarEditingChanged:)]) {
        [self.delegate treeTableViewSearchBarEditingChanged:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(treeTableViewSearchBarShouldBeginEditing:)]) {
        [self.delegate treeTableViewSearchBarShouldBeginEditing:self];
    }
    return YES;
}


#pragma mark - Public Method

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)resignFirstResponder {
    [self.textField resignFirstResponder];
}


#pragma mark - Private Method

- (UIView *)getLeftViewWithTextFieldHeight:(CGFloat)height {
    
    CGFloat iconHeight = height;
    CGFloat iconMargin = iconHeight / 4;
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    iconButton.frame = CGRectMake(0, 0, iconHeight, iconHeight);
    iconButton.userInteractionEnabled = NO;
    iconButton.contentEdgeInsets = UIEdgeInsetsMake(iconMargin, iconMargin, iconMargin, iconMargin);
    [iconButton setImage:[UIImage imageNamed:@"MYTreeTableView.bundle/search"] forState:UIControlStateNormal];
    
    return (UIView *)iconButton;
}

- (UIColor *)getColorWithRed:(NSInteger)redNum green:(NSInteger)greenNum blue:(NSInteger)blueNum {
    return [UIColor colorWithRed:redNum/255.0 green:greenNum/255.0 blue:blueNum/255.0 alpha:1.0];
}


@end
