//
//  MYTreeTableViewCell.m
//  MYTreeTableView
//
//  Created by mayan on 2018/4/4.
//  Copyright © 2018年 mayan. All rights reserved.
//  https://github.com/mayan29/TreeTableView


#import "MYTreeTableViewCell.h"
#import "MYTreeItem.h"

@interface MYTreeTableViewCell ()

@property (nonatomic, strong) MYTreeItem *treeItem;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation MYTreeTableViewCell


#pragma mark - Init

+ (instancetype)cellWithTableView:(UITableView *)tableView andTreeItem:(MYTreeItem *)item {
    
    static NSString *ID = @"MYTreeTableViewCell";
    MYTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYTreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.treeItem = item;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font   = [UIFont systemFontOfSize:14];
        self.indentationWidth = 15;
        self.selectionStyle   = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat minX = 15 + self.indentationLevel * self.indentationWidth;
    
    if (!self.treeItem.isLeaf) {
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.origin.x = minX;
        self.imageView.frame = imageViewFrame;
    }
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = minX + (self.treeItem.isLeaf ? 0 : (self.imageView.bounds.size.width + 2));
    self.textLabel.frame = textLabelFrame;
}


#pragma mark - Setter

- (void)setTreeItem:(MYTreeItem *)treeItem {
    _treeItem = treeItem;
    
    self.indentationLevel = treeItem.level;
    self.textLabel.text   = treeItem.name;
    self.imageView.image  = treeItem.isLeaf ? nil : [UIImage imageNamed:@"MYTreeTableView.bundle/arrow"];
    self.accessoryView    = self.checkButton;
   
    [self refreshArrow];
    [self.checkButton setImage:[self getCheckImage] forState:UIControlStateNormal];
}

- (void)setIsShowArrow:(BOOL)isShowArrow {
    _isShowArrow = isShowArrow;
    
    if (!isShowArrow && self.imageView.image) {
        self.imageView.image = nil;
    }
}

- (void)setIsShowCheck:(BOOL)isShowCheck {
    _isShowCheck = isShowCheck;
    
    if (!isShowCheck && self.accessoryView) {
        self.accessoryView = nil;
    }
}


#pragma mark - Public Method

- (void)updateItem {
    // 刷新 title 前面的箭头方向
    [UIView animateWithDuration:0.25 animations:^{
        [self refreshArrow];
    }];
}


#pragma mark - Lazy Load

- (UIButton *)checkButton {
    if (!_checkButton) {
        
        UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [checkButton setImage:[self getCheckImage] forState:UIControlStateNormal];
        checkButton.adjustsImageWhenHighlighted = NO;
        checkButton.frame = CGRectMake(0, 0, self.contentView.bounds.size.height, self.contentView.bounds.size.height);
        CGFloat aEdgeInset = (checkButton.frame.size.height - checkButton.imageView.image.size.height) / 2;
        checkButton.contentEdgeInsets = UIEdgeInsetsMake(aEdgeInset, aEdgeInset, aEdgeInset, aEdgeInset);
        
        _checkButton = checkButton;
    }
    return _checkButton;
}


#pragma mark - Private Method

- (void)refreshArrow {
    
    if (self.treeItem.isExpand) {
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)checkButtonClick:(UIButton *)sender {
    if (self.checkButtonClickBlock) {
        self.checkButtonClickBlock(self.treeItem);
    }
}

- (UIImage *)getCheckImage {

    switch (self.treeItem.checkState) {
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


@end
