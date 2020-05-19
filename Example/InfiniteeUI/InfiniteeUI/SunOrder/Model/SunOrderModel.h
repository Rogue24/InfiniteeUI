//
//  SunOrderModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/22.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunOrderModel : NSObject
@property (nonatomic, copy) NSString *proCusId;
@property (nonatomic, copy) NSString *proColor;
@property (nonatomic, copy) NSString *proShape;
@property (nonatomic, copy) NSString *proId;
@property (nonatomic, copy) NSString *proCusIcon;
@property (nonatomic, copy) NSString *proCusType;
@property (nonatomic, copy) NSString *proCusName;
@property (nonatomic, copy) NSString *proStyle;
@property (nonatomic, copy) NSString *proName;
@property (nonatomic, copy) NSString *proPicture;
@property (nonatomic, copy) NSString *proSize;
@property (nonatomic, assign) BOOL proIsRelease; // 是否公开商品图片

@property (nonatomic, copy) NSString *showTypeName;
@property (nonatomic, copy) NSString *cusName;
@property (nonatomic, copy) NSString *cusIcon;
@property (nonatomic, copy) NSString *modelCreateDate;  // 官方晒单日期
@property (nonatomic, assign) NSInteger orderBuyType; // 0自用 1礼物
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *orderCreateDate; // 商品购买日期
@property (nonatomic, copy) NSString *cusId;
@property (nonatomic, copy) NSString *createDate;   // 用户晒单日期
@property (nonatomic, assign) NSInteger showType; // 共6个，最后两个4和5不用显示右上角图标，边框颜色也一样 64 109 227
@property (nonatomic, copy) NSString *content;

// 商品晒单图片字符串，需要“,”分隔
//@property (nonatomic, copy) NSString *pictures;
// 商品晒单图片字符串，需要“,”分隔
//@property (nonatomic, copy) NSString *modelPic;

// 作品相关id
@property (nonatomic, copy) NSString *proRelateIds;

// 商品晒单图片
@property (nonatomic, copy) NSArray *picturesArray;
// 官方晒单图片
@property (nonatomic, copy) NSArray *modelPicArray;
@end
