//
//  GoodsPrice.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/21.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "GoodsPrice.h"

@implementation GoodsPrice

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

@end
