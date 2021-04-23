//
//  MYTreeTableViewCell.m
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "MYTreeTableViewCell.h"
#import "MYTreeItem.h"
#import "MYTreeTableViewLayout.h"

@interface MYTreeTableViewCell () {
    MYTreeItem *_privateItem;
    MYTreeTableViewLayout *_privateLayout;
    id<MYTreeTableViewCellDelegate> _privateDelegate;
}
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation MYTreeTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.numberOfLines = 0;
        self.indentationWidth = 15;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat minX = 15 + self.indentationLevel * self.indentationWidth;
    
    if (!_privateItem.isLeaf) {
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.origin.x = minX;
        self.imageView.frame = imageViewFrame;
    }
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = minX + (_privateItem.isLeaf ? 0 : self.imageView.bounds.size.width) + 2;
    self.textLabel.frame = textLabelFrame;
}


#pragma mark - Setter and Getter

- (void)setTreeItem:(MYTreeItem *)treeItem {
    _privateItem = treeItem;
        
    [self setCommonData];
}

- (void)setLayout:(MYTreeTableViewLayout *)layout {
    _privateLayout = layout;
    
    [self setCommonData];
}

- (void)setDelegate:(id<MYTreeTableViewCellDelegate>)delegate {
    _privateDelegate = delegate;
}


#pragma mark - Private Method

- (void)setCommonData {
    if (!_privateItem || !_privateLayout) return;
    
    self.backgroundColor         = _privateLayout.backgroundColorMap[_privateItem.type] ?: _privateLayout.backgroundColor;
    self.textLabel.textColor     = _privateLayout.textColorMap[_privateItem.type] ?: _privateLayout.textColor;
    self.textLabel.font          = _privateLayout.fontMap[_privateItem.type] ?: _privateLayout.font;
    self.textLabel.numberOfLines = _privateLayout.numberOfLinesMap[_privateItem.type].integerValue ?: _privateLayout.numberOfLines;
    self.indentationLevel        = _privateItem.level;
    self.textLabel.text          = _privateItem.name;
    self.accessoryView           = self.checkButton;
    self.imageView.image         = self.arrowImage;
    
    if (_privateLayout.isShowExpandedAnimation) {
        typeof(_privateItem)weakPrivateItem = _privateItem;
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(weakPrivateItem.isExpanded ? M_PI_2 : 0);
        }];
    } else {
        self.imageView.transform = CGAffineTransformMakeRotation(_privateItem.isExpanded ? M_PI_2 : 0);
    }
}

- (UIImage *)arrowImage {
    if (_privateLayout.isShowArrow) {
        if (_privateItem.isLeaf) {
            return nil;
        } else {
            if (_privateLayout.isShowArrowIfNoChildNode) {
                return [UIImage imageNamed:@"MYTreeTableView.bundle/arrow"];
            } else {
                if (_privateItem.childItems.count) {
                    return [UIImage imageNamed:@"MYTreeTableView.bundle/arrow"];
                } else {
                    return nil;
                }
            }
        }
    } else {
        return nil;
    }
}

- (UIButton *)checkButton {
    if (_privateLayout.isShowCheck) {
        if (![_privateItem isContainWithTypeSet:_privateLayout.isHiddenCheckTypeSet]) {
            if (!_checkButton) {
                _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [_checkButton setImage:[self checkImageWithState:_privateItem.checkState] forState:UIControlStateNormal];
                _checkButton.adjustsImageWhenHighlighted = NO;
                _checkButton.frame = CGRectMake(0, 0, self.contentView.bounds.size.height, self.contentView.bounds.size.height);
                CGFloat aEdgeInset = (_checkButton.frame.size.height - _checkButton.imageView.image.size.height) / 2;
                _checkButton.contentEdgeInsets = UIEdgeInsetsMake(aEdgeInset, aEdgeInset, aEdgeInset, aEdgeInset);
            }
            [_checkButton setImage:[self checkImageWithState:_privateItem.checkState] forState:UIControlStateNormal];
            return _checkButton;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (UIImage *)checkImageWithState:(NSUInteger)state {
    switch (state) {
        case MYTreeItemDefault:
            return [UIImage imageNamed:@"MYTreeTableView.bundle/checkbox-uncheck"];
            break;
        case MYTreeItemChecked:
            return [UIImage imageNamed:@"MYTreeTableView.bundle/checkbox-checked"];
            break;
        case MYTreeItemHalfChecked:
            return [UIImage imageNamed:@"MYTreeTableView.bundle/checkbox-partial"];
            break;
        default:
            return nil;
            break;
    }
}

- (void)checkButtonClick:(UIButton *)sender {
    if ([_privateDelegate respondsToSelector:@selector(treeTableViewCell:treeItem:didClickCheckButton:)]) {
        [_privateDelegate treeTableViewCell:self treeItem:_privateItem didClickCheckButton:self.checkButton];
    }
}


@end
