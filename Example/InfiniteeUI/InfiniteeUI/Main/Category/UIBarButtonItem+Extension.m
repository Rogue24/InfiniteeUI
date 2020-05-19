//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

//创建导航栏上面的Item样式：设置一个按钮放入Item的CustomView中
/* 
 * 各个参数：
 *  target：负责按钮响应事件的对象
 *  action：响应方法
 *  imageName：图片名称
 *  内容间距
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andImageName:(NSString *)imageName {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //自定义按钮样式
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    button.jp_size = button.currentImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andIcon:(NSString *)icon isLeft:(BOOL)isLeft {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.tintColor = [UIColor clearColor];
    
    button.contentHorizontalAlignment = isLeft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if ([icon isEqualToString:@""]) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:icon];
        [attributedText addAttribute:NSBaselineOffsetAttributeName
                               value:@(0.5)
                               range:NSMakeRange(0, attributedText.length)];
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont infiniteeFontWithSize:18]
                               range:NSMakeRange(0, attributedText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:InfiniteeBlack
                               range:NSMakeRange(0, attributedText.length)];
        [button setAttributedTitle:attributedText forState:UIControlStateNormal];
    } else {
        if ([icon isEqualToString:@""]) {
            button.titleLabel.font = [UIFont infiniteeFontWithSize:24];
        } else if ([icon isEqualToString:@""]) {
            button.titleLabel.font = [UIFont infiniteeFontWithSize:20];
        } else {
            button.titleLabel.font = [UIFont infiniteeFontWithSize:14];
        }
        
        [button setTitle:icon forState:UIControlStateNormal];
        [button setTitleColor:InfiniteeBlack forState:UIControlStateNormal];
        [button setTitleColor:InfiniteeBlackA(0.5) forState:UIControlStateDisabled];
    }
    
//    if (IOS11_OR_LATER) {
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button
//                                                                  attribute:NSLayoutAttributeWidth
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1.0
//                                                                   constant:44]];
//        [button addConstraint:[NSLayoutConstraint constraintWithItem:button
//                                                                  attribute:NSLayoutAttributeHeight
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:nil
//                                                                  attribute:NSLayoutAttributeNotAnAttribute
//                                                                 multiplier:1.0
//                                                                   constant:44]];
//    } else {
        button.jp_size = CGSizeMake(JPNavBarH, JPNavBarH);
//    }
    
//    button.backgroundColor = [UIColor yellowColor];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andIcon:(NSString *)icon normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor width:(CGFloat)width isLeft:(BOOL)isLeft {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tintColor = [UIColor clearColor];
    
    button.contentHorizontalAlignment = isLeft ? UIControlContentHorizontalAlignmentLeft : UIControlContentHorizontalAlignmentRight;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if ([icon isEqualToString:@""]) {
        NSMutableAttributedString * (^createAttStr)(NSString *str) = ^(NSString *str) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str];
            [attributedText addAttribute:NSBaselineOffsetAttributeName
                                   value:@(0.5)
                                   range:NSMakeRange(0, attributedText.length)];
            [attributedText addAttribute:NSFontAttributeName
                                   value:[UIFont infiniteeFontWithSize:18]
                                   range:NSMakeRange(0, attributedText.length)];
            return attributedText;
        };
        
        NSMutableAttributedString *attributedText = createAttStr(icon);
        [attributedText addAttribute:NSForegroundColorAttributeName
                               value:normalColor
                               range:NSMakeRange(0, attributedText.length)];
        [button setAttributedTitle:attributedText forState:UIControlStateNormal];
        
        NSMutableAttributedString *attributedHText = createAttStr(icon);
        [attributedHText addAttribute:NSForegroundColorAttributeName
                               value:highlightedColor
                               range:NSMakeRange(0, attributedHText.length)];
        [button setAttributedTitle:attributedHText forState:UIControlStateHighlighted];
        
        NSMutableAttributedString *attributedDText = createAttStr(icon);
        [attributedDText addAttribute:NSForegroundColorAttributeName
                                value:InfiniteeGray
                                range:NSMakeRange(0, attributedDText.length)];
        [button setAttributedTitle:attributedDText forState:UIControlStateDisabled];
    } else {
        if ([icon isEqualToString:@""]) {
            button.titleLabel.font = [UIFont infiniteeFontWithSize:24];
        } else {
            button.titleLabel.font = [UIFont infiniteeFontWithSize:14];
        }
        
        [button setTitle:icon forState:UIControlStateNormal];
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [button setTitleColor:InfiniteeGray forState:UIControlStateDisabled];
    }
    button.jp_size = CGSizeMake(width, JPNavBarH);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
