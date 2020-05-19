//
//  SunOrderCategoryViewModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SunOrderCategoryModel.h"
#import "SunOrderDetailViewModel.h"

@interface SunOrderCategoryViewModel : NSObject

@property (nonatomic, strong) SunOrderCategoryModel *socModel;

@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGRect cellFrame; // 高46

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) CGFloat offsetY;

@property (nonatomic, assign) BOOL isRequestSunOrderDataSuccess;
@property (nonatomic, copy) NSArray<SunOrderDetailViewModel *> *detailVMs;
@property (nonatomic, copy) NSArray<SunOrderImageModel *> *soImageModels;


@property (nonatomic, assign) CGFloat styleIconW;
@property (nonatomic, assign) CGFloat styleNameW;
@property (nonatomic, assign) NSInteger styleTag;

@property (nonatomic, assign) float iconR;
@property (nonatomic, assign) float iconG;
@property (nonatomic, assign) float iconB;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *lastTime;

@end
