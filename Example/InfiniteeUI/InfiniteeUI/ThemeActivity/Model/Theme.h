//
//  Theme.h
//  Infinitee2.0
//
//  Created by guanning on 16/11/18.
//  Copyright © 2016年 Infinitee. All rights reserved.
//
// 活动模型

#import <Foundation/Foundation.h>
//#import "CreativeWorks.h"

@interface Theme : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *productionCount;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *customerCount;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *smallPicture;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rule;

@property (nonatomic, assign) BOOL isShowed;

#pragma mark - 自定义属性
@property (nonatomic, assign) CGSize ruleSize;

@end
