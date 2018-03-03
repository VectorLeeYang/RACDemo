//
//  RACView.h
//  RACDemo
//
//  Created by Young on 2018/2/6.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@interface RACView : UIView
// 信号
@property (nonatomic, strong) RACSubject *subject;

@end
