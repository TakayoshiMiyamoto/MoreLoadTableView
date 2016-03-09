//
//  MoreLoadTableView.h
//  https://github.com/TakayoshiMiyamoto/MoreLoadTableView.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreLoadTableViewDataSource, MoreLoadTableViewDelegate;

@interface MoreLoadTableView : UITableView

@property (nonatomic, weak) id<MoreLoadTableViewDataSource> moreDataSource;
@property (nonatomic, weak) id<MoreLoadTableViewDelegate> moreDelegate;

@property (nonatomic, assign) NSInteger showSectionCount;
@property (nonatomic, assign) NSInteger showRowCount;

// Text
@property (nonatomic, copy) NSString *sectionMoreText;
@property (nonatomic, copy) NSString *rowMoreText;

// Color
@property (nonatomic, strong) UIColor *sectionMoreTextColor;
@property (nonatomic, strong) UIColor *sectionMoreBackgroundColor;
@property (nonatomic, strong) UIColor *rowMoreTextColor;
@property (nonatomic, strong) UIColor *rowMoreBackgroundColor;

// Font
@property (nonatomic, strong) UIFont *sectionMoreFont;
@property (nonatomic, strong) UIFont *rowMoreFont;

@property (nonatomic, assign) CGFloat heightForRow;
@property (nonatomic, assign) CGFloat heightForMoreSection;
@property (nonatomic, assign) CGFloat heightForMoreRow;

- (void)refresh;

@end

@protocol MoreLoadTableViewDataSource <NSObject>

@required

- (NSInteger)numberOfSectionsInMoreLoadTableView:(MoreLoadTableView *)tableView;
- (NSInteger)moreLoadTableView:(MoreLoadTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)initializeTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)moreLoadTableViewCell:(UITableViewCell * __autoreleasing *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)moreLoadTableView:(MoreLoadTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)moreLoadTableView:(MoreLoadTableView *)tableView heightForFooterInSection:(NSInteger)section;
- (NSString *)moreLoadTableView:(MoreLoadTableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (UIView *)moreLoadTableView:(MoreLoadTableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (NSString *)moreLoadTableView:(MoreLoadTableView *)tableView titleForFooterInSection:(NSInteger)section;
- (UIView *)moreLoadTableView:(MoreLoadTableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

@protocol MoreLoadTableViewDelegate <NSObject>

@optional

- (void)moreLoadTableViewDidStartMoreLoad;
- (void)moreLoadTableViewDidFinishMoreLoad;
- (void)moreLoadTableView:(MoreLoadTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
