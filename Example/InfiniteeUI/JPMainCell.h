//
//  JPMainCell.h
//  JPImageresizerView_Example
//
//  Created by 周健平 on 2020/11/2.
//  Copyright © 2020 ZhouJianPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPBounceView.h"


@interface JPMainCell : UICollectionViewCell
+ (NSString *)cellID;
+ (UIFont *)iconFont;
+ (UIFont *)titleFont;
+ (UIColor *)textColor;
@property (nonatomic, weak) JPBounceView *bounceView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) CALayer *shadowLayer;
@property (nonatomic, weak) UILabel *iconLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@end

