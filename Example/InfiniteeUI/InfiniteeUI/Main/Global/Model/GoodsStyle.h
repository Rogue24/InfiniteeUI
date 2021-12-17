//
//  GoodsStyle.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/21.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreativeWorks.h"

@interface GoodsStyle : NSObject
@property (nonatomic, copy) NSString *styleName;
@property (nonatomic, strong) NSMutableArray<CreativeWorks *> *goodsInfos;
@end
