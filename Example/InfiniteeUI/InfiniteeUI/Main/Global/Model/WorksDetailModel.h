//
//  WorksDetailModel.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/15.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorksTag.h"
#import "WorksRelate.h"

@interface WorksDetailModel : NSObject

@property (nonatomic, copy) NSString *verifiedOfficialType;
@property (nonatomic, copy) NSString *cusNickname;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, copy) NSString *isAward;
@property (nonatomic, assign) BOOL isRelease;
@property (nonatomic, assign) BOOL isPraise;
@property (nonatomic, copy) NSString *verifiedSinaType;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *cusIcon;
@property (nonatomic, copy) NSString *cusFansCount;
@property (nonatomic, copy) NSString *isRecommended;
@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSArray *relates;
@property (nonatomic, copy) NSArray *tags;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *shape;
@property (nonatomic, assign) BOOL isAllowBuy;
@property (nonatomic, copy) NSString *cusId;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, copy) NSString *cusWorkCount;
@property (nonatomic, copy) NSString *categoryId;

/** 商品详情链接 */
@property (nonatomic, copy) NSString *prdurl;
@end
