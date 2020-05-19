//
//  UIViewController+Extension.m
//  Infinitee2.0
//
//  Created by 周健平 on 2019/10/23.
//  Copyright © 2019 Infinitee. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "NSObject+JPExtension.h"

@implementation UIViewController (Extension)

+ (void)load {
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self jp_swizzleClassMethodsWithOriginalSelector:@selector(presentViewController:animated:completion:) swizzledSelector:@selector(jp_presentViewController:animated:completion:)];
        });
    }
}

- (void)jp_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self jp_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
