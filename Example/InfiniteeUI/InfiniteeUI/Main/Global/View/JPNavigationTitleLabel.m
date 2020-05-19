//
//  JPNavigationTitleLabel.m
//  Infinitee2.0
//
//  Created by 周健平 on 2017/10/14.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPNavigationTitleLabel.h"

@implementation JPNavigationTitleLabel

+ (JPNavigationTitleLabel *)navigationTitleLabelWithTitle:(NSString *)title {
    JPNavigationTitleLabel *titleLabel = [[self alloc] init];
    titleLabel.textColor = InfiniteeBlack;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
