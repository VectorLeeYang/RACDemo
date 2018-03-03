//
//  LoginViewModel.m
//  RACDemo
//
//  Created by Young on 2018/3/3.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(instancetype)init{
    if (self = [super init]) {
        //初始化
        [self setupSignal];
    }
    return self;
}

-(void)setupSignal {
    //处理登录点击的信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString * account,NSString * pwd){
        return @(account.length && pwd.length);
    }];
    
    //处理登录的命令
    //创建命令
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //处理事件密码加密
        NSLog(@"拿到%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //1、发送请求&&获取登录结果!!
            // TODO
            //2、发送登录结果
            [subscriber sendNext:@"发送登录请求返回的结果"];
            //3、数据发送完毕，订阅者关闭会通知命令_loginCommand做加载动画消失操作
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    //获取命令中信号源
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        //拿到登录返回的结果做处理
        //1、登录成功，跳转下个界面
        //2、登录失败，则提示
        NSLog(@"aa:%@",x);
        [_loginSucessCommand execute:@"登录成功"];
    }];
    
    //监听命令执行过程!!
    //skip跳过第一次未执行命令时调用block
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        if ([x boolValue]) {
            //正在执行
            NSLog(@"登录动画加载!!");
        }else{
            NSLog(@"取消加载动画!!");
        }
        
    }];
}

@end
