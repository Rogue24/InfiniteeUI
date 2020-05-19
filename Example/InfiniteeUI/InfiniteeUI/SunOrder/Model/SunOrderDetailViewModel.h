//
//  SunOrderDetailViewModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText.h>
#import "SunOrderModel.h"
#import "SunOrderImageModel.h"

@interface SunOrderDetailViewModel : NSObject

@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, assign) CGPoint cellPosition;

/** 原始模型 */
@property (nonatomic, strong) SunOrderModel *soModel;

/** 是否来自产品分类的晒单 */
@property (nonatomic, assign) BOOL isFromCategory;

/** cell高度 包括底部10间距 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 用户图片列表高度 包括顶部和底部5间距 */
@property (nonatomic, assign) CGFloat userImageListHeight;
/** 官方图片列表高度 包括顶部和底部5间距 */
@property (nonatomic, assign) CGFloat governImageListHeight;
/** 用户图片列表Y值 */
@property (nonatomic, assign) CGFloat userImageListY;
/** 官方图片列表Y值 */
@property (nonatomic, assign) CGFloat governImageListY;

/** 晒单内容文本高度 */
@property (nonatomic, assign) CGFloat describeH;

/** 类型颜色 */
@property (nonatomic, strong) UIColor *typeColor;
/** cell边框颜色 是类型颜色50%透明度 */
@property (nonatomic, strong) UIColor *boardColor;

/** 商品图URL */
@property (nonatomic, strong) NSURL *goodsPictureURL;
/** 用户头像URL */
@property (nonatomic, strong) NSURL *userIconURL;

/** 类型 */
@property (nonatomic, strong) YYTextLayout *typeLayout;
/** 商品名称 */
@property (nonatomic, strong) YYTextLayout *goodsNameLayout;
/** 款式和尺码 */
@property (nonatomic, strong) YYTextLayout *styleAndSizeLayout;
/** 晒单说明文本 */
@property (nonatomic, strong) YYTextLayout *buyGoodsDateLayout;
/** 商品设计者名称 */
@property (nonatomic, strong) YYTextLayout *userNameLayout;
/** 商品设计者职称 */
@property (nonatomic, strong) YYTextLayout *identityLayout;
/** 用户晒单日期 */
@property (nonatomic, strong) YYTextLayout *userSoDateLayout;
/** 官方晒单日期 */
@property (nonatomic, strong) YYTextLayout *governSoDateLayout;
/** 晒单内容文本 */
@property (nonatomic, strong) YYTextLayout *describeLayout;

/** 用户晒单图片模型 */
@property (nonatomic, copy) NSArray<SunOrderImageModel *> *userImageModels;
/** 官方晒单图片模型 */
@property (nonatomic, copy) NSArray<SunOrderImageModel *> *governImageModels;

/** cell是否已经用动画展示出来过 */
@property (nonatomic, assign) BOOL isShowed;

@end
