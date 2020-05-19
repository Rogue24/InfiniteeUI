//
//  UIImage+InfiniteeImage.m
//  Infinitee2.0
//
//  Created by guanning on 2017/1/25.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "UIImage+InfiniteeImage.h"

@implementation UIImage (InfiniteeImage)

+ (UIImage *)defaultIcon {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"default_Icon.png"];
    });
    return img;
}

+ (UIImage *)defaultWorksPicture {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"default_image.png"];
    });
    return img;
}

@end
