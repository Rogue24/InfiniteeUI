//
//  CustomNavBgView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/5/25.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "CustomNavBgView.h"

@implementation CustomNavBgView

+ (CustomNavBgView *)customNavBgView {
    CGFloat height = JPNavTopMargin;
    CustomNavBgView *customView = [[self alloc] initWithFrame:CGRectMake(0, 0, JPPortraitScreenWidth, height)];
    customView.backgroundColor = InfiniteeWhite;
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, height - JPSeparateLineThick, JPPortraitScreenWidth, JPSeparateLineThick);
    lineLayer.backgroundColor = InfiniteeBlueA(0.5).CGColor;
    [customView.layer addSublayer:lineLayer];
    return customView;
}

+ (CustomNavBgView *)customShadowNavBgView {
    
    CGFloat height = JPNavTopMargin;
    CustomNavBgView *customView = [[self alloc] initWithFrame:CGRectMake(0, 0, JPPortraitScreenWidth, height)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-50, 0, customView.jp_width + 100, customView.jp_height)].CGPath;
    customView.layer.shadowOpacity = 1;
    customView.layer.shadowColor = InfiniteeBlueA(0.1).CGColor;
    customView.layer.shadowOffset = CGSizeMake(0, 3);
    customView.layer.shadowRadius = 10;
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, height - JPSeparateLineThick, JPPortraitScreenWidth, JPSeparateLineThick);
    lineLayer.backgroundColor = InfiniteeBlueA(0.2).CGColor;
    [customView.layer addSublayer:lineLayer];
    
    return customView;
}

@end
