//
//  ActivityDetailViewController.h
//  Infinitee2.0
//
//  Created by guanning on 2017/3/15.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Theme;

@interface ActivityDetailViewController : UICollectionViewController <UINavigationControllerDelegate>
- (instancetype)initWithTheme:(Theme *)theme;
- (instancetype)initWithTheme:(Theme *)theme startPushBlock:(void(^)(void))startPushBlock startPopBlock:(void(^)(BOOL isInteractivePop, CGFloat diffY))startPopBlock;
@property (nonatomic, strong) Theme *theme;


@property (nonatomic, assign) BOOL isFromRecomActivity;
- (CGRect)activityDetailHeaderFrame:(BOOL)isOnWindow;
- (void)fromRecomActivityBeginAnimateWithIsPush:(BOOL)isPush;
- (void)fromRecomActivityEndAnimateWithIsPush:(BOOL)isPush isComplete:(BOOL)isComplete;
@end
