//
//  UserWorksEditTitleView.h
//  Infinitee2.0
//
//  Created by guanning on 2017/3/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TitleViewState) {
    NormalState,
    RequestState
};

@interface RequestStateTitleView : UIView
+ (instancetype)requestStateTitleViewWithTitle:(NSString *)title state:(TitleViewState)state;
- (void)setTitle:(NSString *)title withState:(TitleViewState)state;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) TitleViewState state;
@end
