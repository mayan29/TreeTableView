//
//  MYSearchTextField.m
//  TreeTableView
//
//  Created by mayan on 2018/5/11.
//  Copyright © 2018年 mayan. All rights reserved.
//

#import "MYSearchBar.h"

@interface MYSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation MYSearchBar


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
    NSLog(@"搜索 - %@",textField.text);
    
    if ([self.delegate respondsToSelector:@selector(searchBarShouldReturn:)]) {
        [self.delegate searchBarShouldReturn:self];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"搜索－清除");
    
    if ([self.delegate respondsToSelector:@selector(searchBarShouldClear:)]) {
        [self.delegate searchBarShouldClear:self];
    }
    return YES;
}

- (void)showText:(UITextField *)searchTextField {
    NSLog(@"%@", searchTextField.text);
    
    if ([self.delegate respondsToSelector:@selector(searchBarEditingChanged:)]) {
        [self.delegate searchBarEditingChanged:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
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
