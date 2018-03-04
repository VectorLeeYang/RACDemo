//
//  TestViewModel.m
//  RACDemo
//
//  Created by Young on 2018/3/3.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "TestViewModel.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/A2DynamicDelegate.h>

@interface TestViewModel ()

@end

@implementation TestViewModel


- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = [NSMutableArray array];
        [self initViewModel];
    }
    return self;
}

- (void)initViewModel {
    @weakify(self);
    self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //1、模拟网络请求过程，并拿到数据放到dataArray中
            NSArray *res = @[@"大话西游",@"疯狂的赛车",@"疯狂的石头",@"逃学威龙",@"肖申克的救赎"];
            [self.dataArray addObjectsFromArray:res];
            [subscriber sendNext:self.dataArray];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    [[self.command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            //正在执行
            NSLog(@"加载动画!!");
        }else{
            NSLog(@"取消动画!!");
        }
    }];
    
    self.dataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return RACObserve(self, dataArray);
    }];
    
}


- (UITableView *)setupTableView {
    CGRect rect = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    A2DynamicDelegate *dataSouce = tableView.bk_dynamicDataSource;
    
    [dataSouce implementMethod:@selector(tableView:numberOfRowsInSection:) withBlock:^NSInteger(UITableView *tableView, NSInteger section) {
        return self.dataArray.count;
    }];
    
    [dataSouce implementMethod:@selector(tableView:cellForRowAtIndexPath:)
                     withBlock:^UITableViewCell*(UITableView *tableView,NSIndexPath *indexPath) {
                         static NSString *string = @"cellid";
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:string];
            cell.textLabel.text = self.dataArray[indexPath.row];
        }
        return cell;
    }];
    tableView.dataSource = (id)dataSouce;
    tableView.tableFooterView = [[UIView alloc] init];
    return tableView;
}

- (void)dataArrayChange {
    [self.dataArray addObject:@"战狼"];
    // 数据变化就执行数据变化的命令
    [self.dataCommand execute:nil];
}

@end
