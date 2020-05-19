//
//  UIFont+InfiniteeFont.m
//  Infinitee2.0
//
//  Created by guanning on 2017/6/9.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "UIFont+InfiniteeFont.h"
#import "JPFileTool.h"
#import <CoreText/CoreText.h>

@implementation UIFont (InfiniteeFont)

+ (UIFont *)infiniteeFontWithSize:(CGFloat)size {
    return [self fontWithName:InfiniteeFontName size:size];
}

+ (UIFont *)productFontWithSize:(CGFloat)size {
    return [self fontWithName:ProductFontName size:size];
}

+ (UIFont *)shapeFontWithSize:(CGFloat)size {
    return [self fontWithName:ShapeFontName size:size];
}

+ (UIFont *)designSpaceIconFontWithSize:(CGFloat)size {
    return [self fontWithName:DesignSpaceIconFontName size:size];
}

+ (NSString *)customFontNameWithPath:(NSString*)path {
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path]);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    CGDataProviderRelease(fontDataProvider);
    CGFontRelease(fontRef);
    return fontName;
}

+ (UIFont *)customFontWithPath:(NSString*)path size:(CGFloat)size {
    return [self fontWithName:[self customFontNameWithPath:path] size:size];
}

@end
