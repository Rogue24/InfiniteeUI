//
//  JPThemeListTransition.h
//  Infinitee2.0
//
//  Created by guanning on 2017/6/5.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPThemeListTransition : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)themeListTransition;
+ (instancetype)themeDetailWithIsPush:(BOOL)isPush duration:(NSTimeInterval)duration startBlock:(void(^)(void))startBlock finishBlock:(void(^)(BOOL isComplete))finishBlock;
@end
