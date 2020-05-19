//
//  UINavigation+FixSpace.m
//  Infinitee2.0
//
//  Created by 周健平 on 2017/10/13.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "UINavigation+FixSpace.h"
#import "NSObject+JPExtension.h"

@implementation UINavigationBar (FixSpace)

- (void)jp_layoutSubviews {
    [self jp_layoutSubviews];
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
            subview.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 15);
            break;
        }
    }
}

@end

@implementation UINavigationItem (FixSpace)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self jp_swizzleInstanceMethodsWithOriginalSelector:@selector(setLeftBarButtonItems:) swizzledSelector:@selector(jp_setLeftBarButtonItems:)];
                [self jp_swizzleInstanceMethodsWithOriginalSelector:@selector(setRightBarButtonItems:) swizzledSelector:@selector(jp_setRightBarButtonItems:)];
            });
    }
}

- (void)jp_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    NSMutableArray *barButtonItems = [NSMutableArray array];
    for (UIBarButtonItem *item in leftBarButtonItems) {
        if (!item.customView) {
            UIBarButtonSystemItem systemItem = [[item valueForKey:@"systemItem"] integerValue];
            if (systemItem == UIBarButtonSystemItemFixedSpace) {
                continue;
            }
        }
        [barButtonItems addObject:item];
    }
    [self jp_setLeftBarButtonItems:barButtonItems];
}

- (void)jp_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    NSMutableArray *barButtonItems = [NSMutableArray array];
    for (UIBarButtonItem *item in rightBarButtonItems) {
        if (!item.customView) {
            UIBarButtonSystemItem systemItem = [[item valueForKey:@"systemItem"] integerValue];
            if (systemItem == UIBarButtonSystemItemFixedSpace) {
                continue;
            }
        }
        [barButtonItems addObject:item];
    }
    [self jp_setRightBarButtonItems:rightBarButtonItems];
}

@end
