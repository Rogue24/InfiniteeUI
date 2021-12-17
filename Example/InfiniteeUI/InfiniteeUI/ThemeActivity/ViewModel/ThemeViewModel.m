//
//  ThemeViewModel.m
//  Infinitee2.0
//
//  Created by guanning on 2017/3/16.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "ThemeViewModel.h"

@implementation ThemeViewModel

- (NSMutableArray *)productions {
    if (!_productions) {
        _productions = [NSMutableArray array];
    }
    return _productions;
}

- (instancetype)initWithTheme:(Theme *)theme {
    if (self = [super init]) {
        self.theme = theme;
    }
    return self;
}

@end
