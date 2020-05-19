//
//  JPSunOrderDataTool.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/21.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SunOrderCategoryViewModel.h"

typedef void(^SoCategorySuccessBlock)(NSArray<SunOrderCategoryViewModel *> *socVMs);
typedef void(^SoDataSuccessBlock)(NSInteger page, NSInteger totalResult, NSString *lastTime, NSArray<SunOrderDetailViewModel *> *sodVMs, NSArray<SunOrderImageModel *> *soIMs);

@interface JPSunOrderDataTool : NSObject

/** 请求所有晒单产品类型数据 */
- (NSURLSessionDataTask *)requestSunOrderCategoryDataWithSuccessBlock:(SoCategorySuccessBlock)successBlock failureBlock:(void(^)(void))failureBlock;

/** 请求对应商品的晒单数据 */
- (NSURLSessionDataTask *)requestSunOrderDataWithProID:(NSString *)proID
                                page:(NSInteger)page
                          imageIndex:(NSInteger)imageIndex
                            lastTime:(NSString *)lastTime
                        successBlock:(SoDataSuccessBlock)successBlock
                        failureBlock:(void(^)(void))failureBlock;

/** 请求对应商品对应的产品分类的晒单数据 */
- (NSURLSessionDataTask *)requestSunOrderDataWithCategoryID:(NSString *)categoryID
                                     page:(NSInteger)page
                               imageIndex:(NSInteger)imageIndex
                                 lastTime:(NSString *)lastTime
                             successBlock:(SoDataSuccessBlock)successBlock
                             failureBlock:(void(^)(void))failureBlock;

- (NSURLSessionDataTask *)requestSunOrderDataIsByCategory:(BOOL)isByCategory
                                       ID:(NSString *)ID
                                     page:(NSInteger)page
                               imageIndex:(NSInteger)imageIndex
                                 lastTime:(NSString *)lastTime
                             successBlock:(SoDataSuccessBlock)successBlock
                             failureBlock:(void(^)(void))failureBlock;

- (SunOrderCategoryViewModel *)analysisSunOrderCategoryModel:(SunOrderCategoryModel *)socModel cellX:(CGFloat)cellX iconFont:(UIFont *)iconFont nameFont:(UIFont *)nameFont;
- (SunOrderDetailViewModel *)analysisSunOrderModel:(SunOrderModel *)soModel index:(NSInteger)index isFromCategory:(BOOL)isFromCategory;
@end
