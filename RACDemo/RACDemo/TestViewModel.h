//
//  TestViewModel.h
//  RACDemo
//
//  Created by Young on 2018/3/3.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>


@interface TestViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

//command处理实际事务  比如：网络请求
@property (nonatomic,strong) RACCommand *command;
//数据源变化的信号
@property(nonatomic,strong) RACCommand *dataCommand;

- (UITableView *)setupTableView;
// 模拟数据源变化
- (void)dataArrayChange;

@end
