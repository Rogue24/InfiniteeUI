//
//  JPMainCellModel.m
//  InfiniteeUI_Example
//
//  Created by aa on 2021/12/17.
//  Copyright © 2021 zhoujianping24@hotmail.com. All rights reserved.
//

#import "JPMainCellModel.h"

@implementation JPMainCellModel

+ (NSArray<JPMainCellModel *> *)cellModels {
    return @[
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_SunOrder],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_ThemeActivity],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_UserHomePage],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_ShopDetail],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_GoodsDetail],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_WorksDetail],
        [[JPMainCellModel alloc] initWithType:JPMainCellModelType_PhotoAlbum],
    ];
}

- (instancetype)initWithType:(JPMainCellModelType)type {
    if (self = [super init]) {
        _type = type;
        
        switch (type) {
            case JPMainCellModelType_SunOrder:
                _icon = @"";
                _title = @"晒单专区";
                break;
                
            case JPMainCellModelType_ThemeActivity:
                _icon = @"";
                _title = @"主题活动中心";
                break;
                
            case JPMainCellModelType_UserHomePage:
                _icon = @"";
                _title = @"个人主页";
                break;
                
            case JPMainCellModelType_ShopDetail:
                _icon = @"";
                _title = @"产品详情页";
                break;
                
            case JPMainCellModelType_GoodsDetail:
                _icon = @"";
                _title = @"商品详情页";
                break;
                
            case JPMainCellModelType_WorksDetail:
                _icon = @"";
                _title = @"作品详情页";
                break;
                
            case JPMainCellModelType_PhotoAlbum:
                _icon = @"";
                _title = @"Infinitee相册";
                break;
        }
    }
    return self;
}

@end
