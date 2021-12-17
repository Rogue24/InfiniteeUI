//
//  SmallMenuModel.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "SmallMenuModel.h"

@implementation SmallMenuModel

+ (NSArray *)worksModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";
    
    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"分享作品";
    
    SmallMenuModel *model3 = [[SmallMenuModel alloc] init];
    model3.titleIcon = @"";
    model3.title = @"联系客服";
    
    SmallMenuModel *model4 = [[SmallMenuModel alloc] init];
    model4.titleIcon = @"";
    model4.title = @"举报作品";
    
    return @[model1, model2, model3, model4];
}

+ (NSArray *)goodsModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";
    
    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"分享商品";
    
    SmallMenuModel *model3 = [[SmallMenuModel alloc] init];
    model3.titleIcon = @"";
    model3.title = @"联系客服";
    
    SmallMenuModel *model4 = [[SmallMenuModel alloc] init];
    model4.titleIcon = @"";
    model4.title = @"举报作品";
    
    return @[model1, model2, model3, model4];
}

+ (NSArray *)styleModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";
    
    SmallMenuModel *model3 = [[SmallMenuModel alloc] init];
    model3.titleIcon = @"";
    model3.title = @"联系客服";
    
    SmallMenuModel *model4 = [[SmallMenuModel alloc] init];
    model4.titleIcon = @"";
    model4.title = @"产品介绍";
    
    return @[model1, model3, model4];
}

+ (NSArray *)shoppingCartModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"管理购物车";
    
    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"联系客服";
    
    return @[model1, model2];
}

+ (NSArray *)ActivityDetailModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";
    
    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"分享主题";
    
    SmallMenuModel *model3 = [[SmallMenuModel alloc] init];
    model3.titleIcon = @"";
    model3.title = @"联系客服";
    
    return @[model1, model2, model3];
}

+ (NSArray *)orderListModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";

    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"联系客服";
    
    return @[model1, model2];
}

+ (NSArray *)shopStyleModels {
    SmallMenuModel *model1 = [[SmallMenuModel alloc] init];
    model1.titleIcon = @"";
    model1.title = @"购物车";
    
    SmallMenuModel *model2 = [[SmallMenuModel alloc] init];
    model2.titleIcon = @"";
    model2.title = @"分享产品";
    
    SmallMenuModel *model3 = [[SmallMenuModel alloc] init];
    model3.titleIcon = @"";
    model3.title = @"联系客服";
    
    SmallMenuModel *model4 = [[SmallMenuModel alloc] init];
    model4.titleIcon = @"";
    model4.title = @"产品介绍";
    
    return @[model1, model2, model3, model4];
}

@end
