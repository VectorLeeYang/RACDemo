//
//  ViewController.m
//  RACDemo
//
//  Created by Young on 2018/1/13.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACKVOWrapper.h>
#import "RACView.h"
#import "TestViewController.h"
#import "LoginViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) RACView *racView;
// 账号输入框
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property(nonatomic,strong) LoginViewModel * loginVM;


@end

@implementation ViewController

- (LoginViewModel *)loginVM {
    //有效避免出错!!
    if (!_loginVM) {
        _loginVM = [[LoginViewModel alloc]init];
        
    }
    return _loginVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.给模型的账号&&密码绑定信号!!
    RAC(self.loginVM,account) = _accountTF.rac_textSignal;
    RAC(self.loginVM,pwd) = _pwdTF.rac_textSignal;
    //2.设置按钮
    RAC(_loginBtn,enabled) = self.loginVM.loginEnableSignal;
    //3.监听登录按钮的点击
    [[_loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //处理登录事件
        [self.loginVM.loginCommand execute:@"账号密码"];
    }];
    //4.登录成功后执行界面跳转
    self.loginVM.loginSucessCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"成功：%@",input);
        TestViewController *ts = [[TestViewController alloc] init];
        [self.navigationController pushViewController:ts animated:YES];
        return [RACSignal empty];
    }];
}

// rac的一些常用命令
- (void)racSudty {
    self.racView = [[RACView alloc] init];
    self.racView.frame = CGRectMake(100, 200, 200, 200);
    [self.view addSubview:self.racView];
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    // 订阅信号
    // 创建订阅者，将Block保存到订阅者对象中，将订阅者保存到数组中
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"ddsd:%@",x);
    }];
    // 发送信号
    [subject sendNext:@"123"];
    
    // 模拟ravView中有个button，点击button后执行的回调，拿到“button”
    // 相对于自定义block回调，少了block的声明和创建
    // 相对于delegate，少了代理方法和代理的声明和创建
    [self.racView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"sub:%@",x);
    }];
    
    RACSignal *singnal = [self.racView rac_signalForSelector:@selector(buttonClick:)];
    [singnal subscribeNext:^(id  _Nullable x) {
        RACTuple *btn = (RACTuple *)x;
        NSLog(@"singnal:%zd",btn.first);
    }];
    // KVO
    [self.racView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
    }];
    
    RACSignal *singnalKVO = [self.racView rac_valuesForKeyPath:@"frame" observer:self];
    [singnalKVO subscribeNext:^(id  _Nullable x) {
        
    }];
    // Timer
    [[RACSignal interval:1 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    }];
}


@end
