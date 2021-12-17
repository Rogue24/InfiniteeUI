//
//  SmallMenuModel.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmallMenuModel : NSObject
@property (nonatomic, copy) NSString *titleIcon;
@property (nonatomic, copy) NSString *title;

+ (NSArray *)worksModels;
+ (NSArray *)goodsModels;
+ (NSArray *)styleModels;
+ (NSArray *)shoppingCartModels;
+ (NSArray *)ActivityDetailModels;
+ (NSArray *)orderListModels;
+ (NSArray *)shopStyleModels;

@end
