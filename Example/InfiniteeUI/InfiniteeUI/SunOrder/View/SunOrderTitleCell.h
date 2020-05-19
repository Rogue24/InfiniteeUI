//
//  SunOrderTitleCell.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SunOrderCategoryViewModel.h"

#define SOTitleSelectedColor (InfiniteeBlack)
#define SOTitleDeselectColor (JPRGBAColor(74, 74, 74, 0.5))

@interface SunOrderTitleCell : UICollectionViewCell

@property (nonatomic, strong) SunOrderCategoryViewModel *socVM;
- (void)setTitleColor:(UIColor *)titleColor;
@end
