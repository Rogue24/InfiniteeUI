//
//  SmallMenuView.h
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallMenuModel.h"

@interface SmallMenuView : UIView
+ (void)smallMenuViewOnView:(UIView *)view menuModels:(NSArray *)models itemClick:(void (^)(NSInteger selectIndex))itemClick;
+ (void)smallMenuViewOnView:(UIView *)view customWidth:(CGFloat)width menuModels:(NSArray *)models itemClick:(void (^)(NSInteger selectIndex))itemClick;
@end
