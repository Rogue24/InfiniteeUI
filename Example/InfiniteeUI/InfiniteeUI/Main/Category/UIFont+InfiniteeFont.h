//
//  UIFont+InfiniteeFont.h
//  Infinitee2.0
//
//  Created by guanning on 2017/6/9.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (InfiniteeFont)
+ (UIFont *)infiniteeFontWithSize:(CGFloat)size;
+ (UIFont *)productFontWithSize:(CGFloat)size;
+ (UIFont *)shapeFontWithSize:(CGFloat)size;
+ (UIFont *)designSpaceIconFontWithSize:(CGFloat)size;

+ (NSString *)customFontNameWithPath:(NSString*)path;
+ (UIFont *)customFontWithPath:(NSString*)path size:(CGFloat)size;
@end
