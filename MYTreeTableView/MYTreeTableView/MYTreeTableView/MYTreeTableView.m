//
//  MYTreeTableView.m
//  TreeTableView
//
//  Created by mayan on 2019/12/6.
//  Copyright © 2019 mayan. All rights reserved.
//

#import "MYTreeTableView.h"
#import "MYTreeTableViewCell.h"
#import "MYTreeTableManager.h"

@interface MYTreeTableView () <UITableViewDelegate, UITableViewDataSource, MYTreeTableViewCellDelegate, UISearchBarDelegate>

@property (nonatomic, strong) MYTreeTableViewLayout *layout;
@property (nonatomic, strong) MYTreeTableManager *manager;

@end

@implementation MYTreeTableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithLayout:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInitWithLayout:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame treeTableViewLayout:(MYTreeTableViewLayout *)layout {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithLayout:layout];
    }
    return self;
}

- (void)commonInitWithLayout:(MYTreeTableViewLayout *)layout {
    self.layout = layout;
    
    if (!self.layout) {
        self.layout = [[MYTreeTableViewLayout alloc] init];
    }
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    for (Class class in self.layout.registerClassMap.allValues) {
        [_tableView registerClass:class forCellReuseIdentifier:NSStringFromClass(class)];
    }
    [_tableView registerClass:self.layout.registerClass forCellReuseIdentifier:NSStringFromClass(self.layout.registerClass)];
    [_tableView registerClass:[MYTreeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MYTreeTableViewCell class])];
    [self addSubview:_tableView];
    
    if (self.layout.isShowSearchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.searchTextField.font = [UIFont systemFontOfSize:14];
        _searchBar.delegate = self;
        [self addSubview:_searchBar];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(self.layout.searchBarHeight, 0, 0, 0);
    self.searchBar.frame = CGRectMake(0, MAX(- self.tableView.contentOffset.y - self.layout.searchBarHeight, self.searchBar.frame.origin.y), self.bounds.size.width, self.layout.searchBarHeight);
}


#pragma mark - Public Methods

- (void)reloadDataWithTreeItems:(NSSet<MYTreeItem *> *)items {
    self.manager = [[MYTreeTableManager alloc] initWithItems:items];
    [self.manager setExpansionLevel:self.layout.expansionLevel];
    [self.manager setIsSingleCheck:self.layout.isSingleCheck];
    [self.manager setIsCancelSingleCheck:self.layout.isCancelSingleCheck];
    [self.manager setIsCheckFollow:self.layout.isCheckFollow];
    
    [self.tableView reloadData];
}

- (void)reloadDataWithSearchText:(NSString *)searchText {
    [self.manager updateShowTreeItemsWithSearchText:searchText];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showTreeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYTreeItem *item = self.manager.showTreeItems[indexPath.row];
    Class class = self.layout.registerClassMap[item.type] ?: self.layout.registerClass;
    
    UITableViewCell<MYTreeTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(class) forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(MYTreeTableViewCell)]) {
        [cell setTreeItem:item];
        [cell setLayout:self.layout];
        [cell setDelegate:self];
    } else {
        NSAssert(NO, @"MYTreeTableView error: 自定义 Cell 需要遵守 MYTreeTableViewCell 协议");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchBar resignFirstResponder];
    
    MYTreeItem *item = self.manager.showTreeItems[indexPath.row];

    if ([self.delegate respondsToSelector:@selector(treeTableView:didSelectTreeItem:)]) {
        if (![self.delegate treeTableView:self didSelectTreeItem:item]) {
            return;
        }
    }
    
    NSIndexSet *indexSet = [self.manager expandItem:item];
    
    UITableViewCell<MYTreeTableViewCell> *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.treeItem = item;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:idx inSection:indexPath.section];
        [indexPaths addObject:tmpIndexPath];
    }];
    
    if (self.layout.isShowExpandedAnimation) {
        if (item.isExpanded) {
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        [tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}


#pragma mark - MYTreeTableViewCellDelegate

- (void)treeTableViewCell:(MYTreeTableViewCell *)cell treeItem:(MYTreeItem *)treeItem didClickCheckButton:(UIButton *)button {
    [self.searchBar resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(treeTableView:didCheckTreeItem:)]) {
        if (![self.delegate treeTableView:self didCheckTreeItem:treeItem]) {
            return;
        }
    }
    
    [self.manager checkItem:treeItem];
    [self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self reloadDataWithSearchText:searchText];
}
 
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"222");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"333");
}

@end
