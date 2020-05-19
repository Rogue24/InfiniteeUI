//
//  SunOrderCategoryModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/27.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunOrderCategoryModel : NSObject

@property (nonatomic, copy) NSString *iconColor;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;

// 自定义属性
@property (nonatomic, assign) BOOL isInfiniteeFont;
@end
