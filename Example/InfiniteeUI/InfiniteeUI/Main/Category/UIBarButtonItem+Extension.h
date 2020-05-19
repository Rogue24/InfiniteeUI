//
//  UIBarButtonItem+Extension.h
//  Weibo
//
//  Created by apple on 15/7/5.
//  Copyright (c) 2015年 nihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andImageName:(NSString *)imageName;

+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andIcon:(NSString *)icon isLeft:(BOOL)isLeft;

+ (UIBarButtonItem *)itemWithTarget:(id)target andAction:(SEL)action andIcon:(NSString *)icon normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor width:(CGFloat)width isLeft:(BOOL)isLeft;

@end
