//
//  SunOrderTransition.h
//  Infinitee2.0
//
//  Created by guanning on 2017/9/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SunOrderAreaViewController;

@interface SunOrderTransition : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionPresentWithFromCells:(NSArray<UITableViewCell *> *)fromCells;
+ (instancetype)transitionDismiss;
@end
