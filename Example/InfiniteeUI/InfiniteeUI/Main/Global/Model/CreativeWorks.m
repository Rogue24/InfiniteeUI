//
//  CreativeWorks.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/18.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "CreativeWorks.h"

@implementation CreativeWorks
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

- (void)setRelateIds:(NSString *)relateIds {
    _relateIds = [relateIds copy];
    
    if (relateIds.length) {
        NSArray *ids = [relateIds componentsSeparatedByString:@","];
        if (ids.count) {
            self.produceGoodsID = ids[0];
            
            if (ids.count > 1) {
                self.componentId = ids[1];
            }
        }
        
    }
}

- (void)setPicture:(NSString *)picture {
    _picture = [picture copy];
    _pictureURL = [InfiniteeImagePath stringByAppendingString:picture];
}

@end
