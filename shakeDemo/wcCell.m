//
//  wcCell.m
//  shakeDemo
//
//  Created by admin on 2017/1/16.
//  Copyright © 2017年 gzpingao.com. All rights reserved.
//

#import "wcCell.h"

@implementation wcCell
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(UIButton *)delectBtn{
    if (!_delectBtn) {
        _delectBtn = [UIButton buttonWithType:0];
        _delectBtn.frame = CGRectMake(10, 20, 20, 20);
        [_delectBtn setTitle:@"-" forState:0];
        _delectBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_delectBtn];
    }
    return _delectBtn;
}

@end
