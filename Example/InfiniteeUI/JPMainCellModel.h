//
//  JPMainCellModel.h
//  InfiniteeUI_Example
//
//  Created by aa on 2021/12/17.
//  Copyright © 2021 zhoujianping24@hotmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JPMainCellModelType) {
    JPMainCellModelType_SunOrder,
    JPMainCellModelType_ThemeActivity,
    JPMainCellModelType_UserHomePage,
    JPMainCellModelType_ShopDetail,
    JPMainCellModelType_GoodsDetail,
    JPMainCellModelType_WorksDetail,
    JPMainCellModelType_PhotoAlbum
};

@interface JPMainCellModel : NSObject
+ (NSArray<JPMainCellModel *> *)cellModels;

- (instancetype)initWithType:(JPMainCellModelType)type;
@property (nonatomic, assign, readonly) JPMainCellModelType type;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *title;
@end


