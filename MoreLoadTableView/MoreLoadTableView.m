//
//  MoreLoadTableView.m
//  https://github.com/TakayoshiMiyamoto/MoreLoadTableView.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import "MoreLoadTableView.h"

static const NSInteger kDefaultShowSectionCount = 4;
static const NSInteger kDefaultShowRowCount = 10;

static const CGFloat kDefaultHeightForRow = 44.f;
static const CGFloat kDefaultHeightForMoreSection = 44.f;
static const CGFloat kDefaultHeightForMoreRow = 30.f;
static const CGFloat kDefaultHeightHeader = 22.f;
static const CGFloat kDefaultHeightFooter = 22.f;

static const NSInteger kDefaultCellFontSize = 18;

@interface MoreLoadTableView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger sectionTotalCount;
@property (nonatomic, assign) NSInteger sectionMaxCount;

@property (nonatomic, copy) NSMutableDictionary *rowTotalCounts;
@property (nonatomic, copy) NSMutableDictionary *rowMaxCounts;

@property (nonatomic, assign) BOOL useHeader;
@property (nonatomic, assign) BOOL useFooter;
@property (nonatomic, assign) BOOL moreLoading;

@end

@implementation MoreLoadTableView {
    dispatch_once_t _onceToken;
}

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self _initializeTableView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self _initializeTableView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self _initializeTableView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (!self) {
        return nil;
    }
    [self _initializeTableView];
    return self;
}

- (void)drawRect:(CGRect)rect {
    __weak __typeof__(self) weakSelf = self;
    dispatch_once(&_onceToken, ^{
        __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf _setup];
    });
}

#pragma mark - Public methods

- (void)refresh {
    [self _setup];
}

#pragma mark - Private methods

- (void)_setup {
    if (!_moreDataSource || !_moreDelegate) {
        return;
    }

    [self _initialize];
    
    // Create row count list
    [self _createRowCountList];

    [self reloadData];
}

- (void)_initialize {
    // Initialize flags
    _useHeader = [[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:titleForHeaderInSection:)] ||
        [[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:viewForHeaderInSection:)];
    _useFooter = [[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:titleForFooterInSection:)] ||
        [[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:viewForFooterInSection:)];
    _moreLoading = NO;
    
    // Initialize section count
    NSInteger sectionCount = [[self moreDataSource] numberOfSectionsInMoreLoadTableView:self];
    _sectionMaxCount = sectionCount;
    if (_sectionMaxCount > _showSectionCount) {
        sectionCount = _showSectionCount;
    }
    _sectionTotalCount = sectionCount;
    
    // Initialize counts
    if (_showSectionCount < 1) {
        _showSectionCount = kDefaultShowSectionCount;
    }
    if (_showRowCount < 1) {
        _showRowCount = kDefaultShowRowCount;
    }
    
    // Initialize dictionaries
    if (_rowTotalCounts) {
        [_rowTotalCounts removeAllObjects];
        _rowTotalCounts = nil;
    }
    _rowTotalCounts = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
    if (_rowMaxCounts) {
        [_rowMaxCounts removeAllObjects];
        _rowMaxCounts = nil;
    }
    _rowMaxCounts = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
}

- (void)_createRowCountList {
    for (NSInteger section = 0; section < _sectionTotalCount; section++) {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
        
        NSInteger rowCount = [[self moreDataSource] moreLoadTableView:self numberOfRowsInSection:section];
        
        NSInteger rowTotalCount;
        if (rowCount < _showRowCount) {
            rowTotalCount = rowCount;
        }
        else {
            rowTotalCount = _showRowCount;
        }
        
        // Save row count
        [_rowTotalCounts setValue:[NSNumber numberWithInteger:rowTotalCount] forKey:key];
        // Save max count of row
        [_rowMaxCounts setValue:[NSNumber numberWithInteger:rowCount] forKey:key];
    }
}

- (void)_updateCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == _sectionTotalCount) {
        // ************************************************
        // More Section
        // ************************************************
        
        cell.textLabel.text = _sectionMoreText ? _sectionMoreText : @"More Section";
        cell.textLabel.textColor = _sectionMoreTextColor ? _sectionMoreTextColor : [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = _sectionMoreFont ? _sectionMoreFont : [UIFont systemFontOfSize:kDefaultCellFontSize];
        
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = _sectionMoreBackgroundColor ? _sectionMoreBackgroundColor : [UIColor whiteColor];
        
        if (_moreLoading && [[self moreDelegate] respondsToSelector:@selector(moreLoadTableViewDidFinishMoreLoad)]) {
            _moreLoading = NO;
            [[self moreDelegate] moreLoadTableViewDidFinishMoreLoad];
        }
        return;
    }
    
    NSInteger row = indexPath.row;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    
    if (row == rowTotalCount) {
        // ************************************************
        // More Row
        // ************************************************
        
        cell.textLabel.text = _rowMoreText ? _rowMoreText : @"More Row";
        cell.textLabel.textColor = _rowMoreTextColor ? _rowMoreTextColor : [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = _rowMoreFont ? _rowMoreFont : [UIFont systemFontOfSize:14];
        
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = _rowMoreBackgroundColor ? _rowMoreBackgroundColor : [UIColor whiteColor];
        
        if (_moreLoading && [[self moreDelegate] respondsToSelector:@selector(moreLoadTableViewDidFinishMoreLoad)]) {
            _moreLoading = NO;
            [[self moreDelegate] moreLoadTableViewDidFinishMoreLoad];
        }
    }
    else {
        cell.textLabel.text = nil;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont systemFontOfSize:kDefaultCellFontSize];
        
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.backgroundColor = [UIColor whiteColor];
        
        [[self moreDataSource] moreLoadTableViewCell:&cell cellForRowAtIndexPath:indexPath];
        
        if (row == rowTotalCount) {
            if (_moreLoading &&
                [[self moreDelegate] respondsToSelector:@selector(moreLoadTableViewDidFinishMoreLoad)]) {
                _moreLoading = NO;
                [[self moreDelegate] moreLoadTableViewDidFinishMoreLoad];
            }
        }
    }
}

- (void)_initializeTableView {
    self.dataSource = self;
    self.delegate = self;
}

#pragma mark - Action methods

- (void)_moreLoadTableViewSidSelectMoreSectionCell {
    _moreLoading = YES;
    
    if ([[self moreDelegate] respondsToSelector:@selector(moreLoadTableViewDidStartMoreLoad)]) {
        [[self moreDelegate] moreLoadTableViewDidStartMoreLoad];
    }
    
    // Reset section count
    if (_sectionMaxCount > _sectionTotalCount + _showSectionCount) {
        _sectionTotalCount += _showSectionCount;
    }
    else {
        _sectionTotalCount = _sectionMaxCount;
    }
    
    // Create row count list
    [self _createRowCountList];
    
    [self reloadData];
}

- (void)_moreLoadTableViewSidSelectMoreRowCellAtIndexPath:(NSIndexPath *)indexPath {
    _moreLoading = YES;
    
    if ([[self moreDelegate] respondsToSelector:@selector(moreLoadTableViewDidStartMoreLoad)]) {
        [[self moreDelegate] moreLoadTableViewDidStartMoreLoad];
    }
    
    NSInteger section = indexPath.section;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    NSInteger rowMaxCount = [[_rowMaxCounts valueForKey:key] integerValue];
    
    if (rowMaxCount > rowTotalCount + _showRowCount) {
        [_rowTotalCounts setValue:[NSNumber numberWithInteger:rowTotalCount + _showRowCount] forKey:key];
    }
    else {
        [_rowTotalCounts setValue:[NSNumber numberWithInteger:rowMaxCount] forKey:key];
    }
    
    for (id cell in self.visibleCells) {
        [self _updateCell:cell cellForRowAtIndexPath:[self indexPathForCell:cell]];
    }

    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sectionMaxCount > _sectionTotalCount) {
        return _sectionTotalCount + 1; // More Section
    }
    return _sectionTotalCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return .0f; // More Section
    }
    if (_useHeader) {
        if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:heightForHeaderInSection:)]) {
            return [[self moreDataSource] moreLoadTableView:self heightForHeaderInSection:section];
        }
        return kDefaultHeightHeader;
    }
    return .0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return .0f; // More Section
    }
    if (_useFooter) {
        if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:heightForFooterInSection:)]) {
            return [[self moreDataSource] moreLoadTableView:self heightForFooterInSection:section];
        }
        return kDefaultHeightFooter;
    }
    return .0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return nil; // More Section
    }
    
    if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:titleForHeaderInSection:)]) {
        return [[self moreDataSource] moreLoadTableView:self titleForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return nil; // More Section
    }
    
    if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:viewForHeaderInSection:)]) {
        return [[self moreDataSource] moreLoadTableView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return nil; // More Section
    }
    
    if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:titleForFooterInSection:)]) {
        return [[self moreDataSource] moreLoadTableView:self titleForFooterInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return nil; // More Section
    }
    
    if ([[self moreDataSource] respondsToSelector:@selector(moreLoadTableView:viewForFooterInSection:)]) {
        return [[self moreDataSource] moreLoadTableView:self viewForFooterInSection:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _sectionTotalCount) {
        return 1; // More Section
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    NSInteger rowMaxCount = [[_rowMaxCounts valueForKey:key] integerValue];
    
    if (rowTotalCount >= _showRowCount) {
        if (rowTotalCount >= rowMaxCount) {
            return rowTotalCount;
        }
        return rowTotalCount + 1; // More Row
    }
    return rowTotalCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == _sectionTotalCount) {
        return _heightForMoreSection > .0f ? _heightForMoreSection : kDefaultHeightForMoreSection; // More Section
    }
    
    NSInteger row = indexPath.row;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    
    if (row == rowTotalCount) {
        return _heightForMoreRow > .0f ? _heightForMoreRow : kDefaultHeightForMoreRow; // More Row
    }
    return _heightForRow > .0f ? _heightForRow : kDefaultHeightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSInteger secrion = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)secrion];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    
    if (secrion == _sectionTotalCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Cell"]; // More Section
        }
    }
    else if (row == rowTotalCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Cell"]; // More Row
        }
    }
    else {
        cell = [[self moreDataSource] initializeTableViewCellForRowAtIndexPath:indexPath];
    }
    
    [self _updateCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == _sectionTotalCount) {
        // ************************************************
        // More Section
        // ************************************************
        
        [self _moreLoadTableViewSidSelectMoreSectionCell];
        return;
    }
    
    NSInteger row = indexPath.row;
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    NSInteger rowTotalCount = [[_rowTotalCounts valueForKey:key] integerValue];
    
    if (row == rowTotalCount) {
        // ************************************************
        // More Row
        // ************************************************
        
        [self _moreLoadTableViewSidSelectMoreRowCellAtIndexPath:indexPath];
        return;
    }

    if ([[self moreDelegate] respondsToSelector:@selector(moreLoadTableView:didSelectRowAtIndexPath:)]) {
        [[self moreDelegate] moreLoadTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
