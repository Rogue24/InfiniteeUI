//
//  SunOrderCategoryModel.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/27.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderCategoryModel.h"

@implementation SunOrderCategoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

@end
