//
//  SunOrderAreaViewController.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JPBeginGuideTransition.h"

@class SunOrderCategoryViewModel;
@class SunOrderListViewController;

#define SunOrderListBaseY (JPNavTopMargin + 46 + 10)

@interface SunOrderAreaViewController : UIViewController //<JPBeginGuideInteractiveTransitionDelegate>

- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource;
- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource isFromBeginGuide:(BOOL)isFromBeginGuide;
- (void)showOrHideListView:(BOOL)isShow;
- (void)showOrHideListCouponView:(BOOL)isShow;
- (void)willDismissHandle;
- (void)dismissHandle;

//@property (nonatomic, strong) JPInteractiveTransition *interactiveTransition;
@property (nonatomic, copy) NSArray<SunOrderCategoryViewModel *> *dataSource;
@property (nonatomic, readonly) SunOrderListViewController *currSolVC;
@property (nonatomic, assign) BOOL isAnimated;

@end
