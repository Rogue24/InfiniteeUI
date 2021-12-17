//
//  GoodsStyle.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/21.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "GoodsStyle.h"

@implementation GoodsStyle
- (NSMutableArray *)goodsInfos {
    if (!_goodsInfos) {
        _goodsInfos = [NSMutableArray array];
    }
    return _goodsInfos;
}
@end
