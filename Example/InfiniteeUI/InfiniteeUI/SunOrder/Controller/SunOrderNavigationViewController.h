//
//  SunOrderNavigationViewController.h
//  Infinitee2.0
//
//  Created by guanning on 2017/9/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPNavigationController.h"
@class SunOrderCategoryViewModel;
@class SunOrderAreaViewController;

@interface SunOrderNavigationViewController : JPNavigationController
- (instancetype)initWithDataSource:(NSArray<SunOrderCategoryViewModel *> *)dataSource fromCells:(NSArray<UITableViewCell *> *)fromCells;
@property (nonatomic, weak) SunOrderAreaViewController *soaVC;
@end
