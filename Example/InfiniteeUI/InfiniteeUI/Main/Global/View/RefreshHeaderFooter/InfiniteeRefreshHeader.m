//
//  InfiniteeRefreshHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "InfiniteeRefreshHeader.h"
#import "FBShimmeringView.h"

@interface InfiniteeRefreshHeader()
@property (nonatomic, weak) FBShimmeringView *shimmeringView;
@end

@implementation InfiniteeRefreshHeader
{
    CGFloat _changeOffsetY;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    
    if (!self.shimmeringView) {
        UILabel * instructionLabel = [[UILabel alloc]init];
        instructionLabel.font = [UIFont fontWithName:@"Porto 400" size:16];
        instructionLabel.textColor = InfiniteeBlue;
        instructionLabel.text = @"I N F I N I T E E";
        [instructionLabel sizeToFit];
        
#warning JPWarning: 这个@"Porto 400"字体底部会多出大概2.5的空白，所以就先这样处理
        UIView *bgView = [[UIView alloc] initWithFrame:instructionLabel.bounds];
        instructionLabel.jp_y = 2.5;
        [bgView addSubview:instructionLabel];
        
        FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] init];
        shimmeringView.shimmering = NO;
        shimmeringView.shimmeringBeginFadeDuration = 0.35f;
        shimmeringView.shimmeringEndFadeDuration = 0.35f;
        shimmeringView.shimmeringPauseDuration = 0.2f;
        shimmeringView.shimmeringAnimationOpacity = 1.f;
        shimmeringView.shimmeringOpacity = 0.3f;
        shimmeringView.userInteractionEnabled = NO;
        
        shimmeringView.bounds = instructionLabel.bounds;
        shimmeringView.contentView = bgView;
        
        [self addSubview:shimmeringView];
        self.shimmeringView = shimmeringView;
        
        CGFloat w = self.shimmeringView.frame.size.width;
        CGFloat h = self.shimmeringView.frame.size.height;
        self.shimmeringView.frame = CGRectMake((JPPortraitScreenWidth - w) * 0.5, (54 - h) * 0.5, w, h);
    }
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat w = self.shimmeringView.frame.size.width;
    CGFloat h = self.shimmeringView.frame.size.height;
    self.shimmeringView.frame = CGRectMake((self.mj_w - w) * 0.5, (self.mj_h - h) * 0.5, w, h);
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    _changeOffsetY = [change[NSKeyValueChangeNewKey] CGPointValue].y;
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
        {
            self.shimmeringView.shimmeringSpeed = 0;
            break;
        }
        case MJRefreshStatePulling:
        {
            self.shimmeringView.shimmeringSpeed = 100;
            if (!self.shimmeringView.shimmering) self.shimmeringView.shimmering = YES;
            break;
        }
        case MJRefreshStateRefreshing:
        {
            self.shimmeringView.shimmeringSpeed = 200;
            if (!self.shimmeringView.shimmering) self.shimmeringView.shimmering = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
#warning JPWarning: 完全不知为何会有 -0
    if (pullingPercent == -0) {
        if (_changeOffsetY < 0) {
            pullingPercent = 1;
        } else {
            pullingPercent = 0;
        }
    }
    [super setPullingPercent:pullingPercent];
    
    if (pullingPercent <= 0) {
        if (self.shimmeringView.shimmering) self.shimmeringView.shimmering = NO;
    } else {
        if (!self.shimmeringView.shimmering) self.shimmeringView.shimmering = YES;
    }
}

@end
