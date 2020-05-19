//
//  DesignPictureViewFooter.h
//  Infinitee2.0-Design
//
//  Created by Jill on 16/8/12.
//  Copyright © 2016年 陈珏洁. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface InfiniteeRefreshFooter : MJRefreshAutoGifFooter
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bottomInset:(CGFloat)bottomInset;
@property (nonatomic, assign) CGFloat bottomInset;
@end
