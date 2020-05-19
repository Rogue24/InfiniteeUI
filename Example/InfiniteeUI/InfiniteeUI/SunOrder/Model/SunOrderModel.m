//
//  SunOrderModel.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/22.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderModel.h"

@implementation SunOrderModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

@end
