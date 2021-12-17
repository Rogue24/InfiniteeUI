//
//  WorksRelate.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/20.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "WorksRelate.h"

@implementation WorksRelate

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

@end
