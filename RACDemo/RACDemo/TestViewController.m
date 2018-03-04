//
//  TestViewController.m
//  RACDemo
//
//  Created by Young on 2018/2/24.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "TestViewController.h"
#import "TestViewModel.h"

@interface TestViewController ()

@property (nonatomic, strong) TestViewModel *testVM;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.testVM = [[TestViewModel alloc] init];
    self.tableView = [self.testVM setupTableView];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    //将命令执行后的数据交给controller
    [self.testVM.command.executionSignals.switchToLatest subscribeNext:^(NSArray *array) {
        @strongify(self);
        NSLog(@"shuju:%@",[array description]);
        [self.tableView reloadData];
        
    }];
    //执行command
    [self.testVM.command execute:nil];
    
    // 监听数据源的变化
    [self.testVM.dataCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *array) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    // 模拟数据源变化
    [self performSelector:@selector(dataArrayChange) withObject:nil afterDelay:2];
}

// 模拟数据变化
- (void)dataArrayChange {
    NSLog(@"fdsfas");
    [self.testVM dataArrayChange];
}

@end
