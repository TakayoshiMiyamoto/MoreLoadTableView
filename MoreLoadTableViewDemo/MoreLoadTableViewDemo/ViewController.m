//
//  ViewController.m
//  https://github.com/TakayoshiMiyamoto/MoreLoadTableView.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import "ViewController.h"

#import "MoreLoadTableView.h"

@interface ViewController ()<MoreLoadTableViewDataSource, MoreLoadTableViewDelegate>

@property (weak, nonatomic) IBOutlet MoreLoadTableView *tableView;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self _initializeTableView];
}

- (void)_initializeTableView {
    self.tableView.moreDataSource = self;
    self.tableView.moreDelegate = self;
    self.tableView.showSectionCount = 1;
    self.tableView.showRowCount = 7;
}

#pragma mark - MoreLoadTableViewDataSource

- (NSInteger)numberOfSectionsInMoreLoadTableView:(MoreLoadTableView *)tableView {
    return 4;
}

- (NSInteger)moreLoadTableView:(MoreLoadTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else if (section == 1) {
        return 3;
    }
    else if (section == 2) {
        return 10;
    }
    else if (section == 3) {
        return 23;
    }
    return 0;
}

- (UITableViewCell *)initializeTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)moreLoadTableViewCell:(UITableViewCell *__autoreleasing *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    (*cell).textLabel.text = [NSString stringWithFormat:@"%ld : %ld", (long)indexPath.section, (long)indexPath.row];
}

#pragma mark - MoreLoadTableViewDelegate

- (void)moreLoadTableView:(MoreLoadTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld : %ld", (long)indexPath.section, (long)indexPath.row);
}

- (void)moreLoadTableViewDidStartMoreLoad {
    NSLog(@"%s", __FUNCTION__);
}

- (void)moreLoadTableViewDidFinishMoreLoad {
    NSLog(@"%s", __FUNCTION__);
}

@end
