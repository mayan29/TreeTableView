//
//  ExampleThreeViewCell.m
//  MYTreeTableView
//
//  Created by mayan on 2021/4/23.
//

#import "ExampleThreeViewCell.h"
#import "MYTreeItem.h"
#import "MYTreeTableViewLayout.h"

@interface ExampleThreeViewCell () {
    MYTreeItem *_privateItem;
    MYTreeTableViewLayout *_privateLayout;
    id<MYTreeTableViewCellDelegate> _privateDelegate;
}

@end

@implementation ExampleThreeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indentationWidth = 15;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark - Setter and Getter

- (void)setTreeItem:(MYTreeItem *)treeItem {
    _privateItem = treeItem;
    
    self.indentationLevel = treeItem.level;
    self.textLabel.text   = treeItem.name;
}

- (void)setLayout:(MYTreeTableViewLayout *)layout {
    _privateLayout = layout;
}

- (void)setDelegate:(id<MYTreeTableViewCellDelegate>)delegate {
    _privateDelegate = delegate;
}


@end
