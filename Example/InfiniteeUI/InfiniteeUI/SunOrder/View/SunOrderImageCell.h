//
//  SunOrderImageCell.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPImageView.h"
@class SunOrderImageModel;

@interface SunOrderImageCell : UICollectionViewCell
@property (nonatomic, weak) JPImageView *imageView;
@property (nonatomic, strong) SunOrderImageModel *imageModel;
+ (CGFloat)itemWH;
- (void)animateDone;
@end
