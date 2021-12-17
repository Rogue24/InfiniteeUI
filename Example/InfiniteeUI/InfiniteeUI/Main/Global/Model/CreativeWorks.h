//
//  CreativeWorks.h
//  Infinitee2.0
//
//  Created by guanning on 16/11/18.
//  Copyright © 2016年 Infinitee. All rights reserved.
//
// 作品模型

#import <Foundation/Foundation.h>
#import "GoodsPrice.h"
#import "WorksDetailModel.h"

@interface CreativeWorks : NSObject

#pragma mark - 原有属性

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *praiseCount;
@property (nonatomic, copy) NSString *shape;
@property (nonatomic, copy) NSString *isPraise;
@property (nonatomic, copy) NSString *cusId;
@property (nonatomic, copy) NSString *cusIcon;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *cusFansCount;
@property (nonatomic, copy) NSString *cusWorkCount;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *cusNickname;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *relateIds;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *categoryId; // 商品对应的产品分类id
@property (nonatomic, assign) BOOL isRelease; // 是否自己可见（1：所有人，0：自己）

#pragma mark - 新增属性

/** 从商品详情拿到的字段 */
@property (nonatomic, copy) NSString *prdurl;

/** 已生成的商品数 */
@property (nonatomic, assign) NSInteger proCount;

/** 收藏数 */
@property (nonatomic, copy) NSString *collectCount;

#pragma mark - 自定义属性

/** 商品对应的作品id */
@property (nonatomic, copy) NSString *componentId; // 有这个值就证明这是一个商品

/** 对应的商品类型id */
@property (nonatomic, copy) NSString *produceGoodsID;

@property (nonatomic, copy) NSArray<GoodsPrice *> *goodsPrices; // 商品尺码信息

#pragma mark - 详情模型

@property (nonatomic, strong) WorksDetailModel *detailModel;

#pragma mark - 是否被选中

@property (nonatomic, assign) BOOL isSelected;

#pragma mark - 图片URL

@property (nonatomic, copy, readonly) NSString *pictureURL;

@property (nonatomic, assign) BOOL isZaning;

@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, assign) BOOL isCollectioning;
@end
