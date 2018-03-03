//
//  RACView.m
//  RACDemo
//
//  Created by Young on 2018/2/6.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "RACView.h"

@implementation RACView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (RACSubject *)subject {
    if (!_subject) {
         _subject = [RACSubject subject];
    }
    return _subject;
}

- (void)buttonClick:(id)sender {
    [self.subject sendNext:@"button"];
}

@end
