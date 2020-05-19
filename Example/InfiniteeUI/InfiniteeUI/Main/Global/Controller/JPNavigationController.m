//
//  JPNavigationController.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/15.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "JPNavigationController.h"

@interface JPNavigationController ()
@property (nonatomic, assign) BOOL isPushing;
@end

@implementation JPNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

/*
 * 重写这个push方法的目的：能够拦截所有push进来的控制器，进行修改
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //每次启动程序时，都会push根控制器，第一次进入这方法时还没push，count为0，不符合条件，跳过；然后第二次进入这方法时也还没push，但count则为1，符合判断条件，执行下面代码
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (animated) {
        if (self.isPushing) {
            return;
        }
        self.isPushing = YES;
        
        @jp_weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @jp_strongify(self);
            if (!self) return;
            self.isPushing = NO;
        });
    }
    
    //每push一个控制器，self.viewControllers的count就会加1（多一个元素），pop就会删除。
    [super pushViewController:viewController animated:animated];//不写这句，导航栏控制器里面的根控制器就不会push进来
}

@end
