//
//  SmallMenuItem.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallMenuModel.h"

@interface SmallMenuItem : UIView
+ (instancetype)smallMenuItemWithModel:(SmallMenuModel *)model index:(NSInteger)index target:(id)target action:(SEL)action;
@property (nonatomic, strong) SmallMenuModel *model;
@end
