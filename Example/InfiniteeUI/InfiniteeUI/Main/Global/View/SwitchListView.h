//
//  SwitchListView.h
//  Infinitee2.0
//
//  Created by guanning on 16/11/23.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchListView : UIView
+ (instancetype)switchListViewWithLeftClick:(void (^)(void))leftClick rightClick:(void (^)(void))rightClick;

@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) void (^leftClick)(void);
@property (nonatomic, copy) void (^rightClick)(void);

- (void)leftAction;
- (void)rightAction;
- (BOOL)isLeft;
@end
