//
//  LoginViewModel.h
//  RACDemo
//
//  Created by Young on 2018/3/3.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LoginViewModel : NSObject

// 账号
@property(nonatomic,strong) NSString *account;
// 密码
@property(nonatomic,strong) NSString *pwd;
// 处理登录按钮能否点击的信号
@property(nonatomic,strong) RACSignal *loginEnableSignal;
// 登录按钮命令
@property(nonatomic,strong) RACCommand *loginCommand;
// 登录成功的信号
@property(nonatomic,strong) RACCommand *loginSucessCommand;


@end
