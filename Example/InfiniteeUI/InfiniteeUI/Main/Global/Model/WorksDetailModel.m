//
//  WorksDetailModel.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/15.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "WorksDetailModel.h"

@implementation WorksDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID": @"id"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

// MJExtension框架方法：定义自身某个【数组属性】的【元素类型】
+ (NSDictionary *)mj_objectClassInArray {
    
    /*
     @key：数组属性名
     @value：元素类型（若不想导入该类型的头文件可直接使用字符串标明）
     */
    
    return @{@"tags": [WorksTag class],
             @"relates": [WorksRelate class]};
    
}

@end
