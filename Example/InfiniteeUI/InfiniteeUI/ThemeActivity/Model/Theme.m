//
//  Theme.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/18.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

- (void)setRule:(NSString *)rule {
    _rule = [rule copy];
    
    CGSize maxSize = CGSizeMake(JPPortraitScreenWidth - 4 * ViewMargin, MAXFLOAT);
    self.ruleSize = [rule boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
}

@end
