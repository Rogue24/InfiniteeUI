//
//  DesignPictureViewFooter.m
//  Infinitee2.0-Design
//
//  Created by Jill on 16/8/12.
//  Copyright © 2016年 陈珏洁. All rights reserved.
//

#import "InfiniteeRefreshFooter.h"

static CGFloat const RefreshImageWidth = 40;
static CGFloat const RefreshImageHeight = 20;

@interface InfiniteeRefreshFooter ()
@property (nonatomic, strong) NSArray<UIImage *> *refreshingImages;
@end

@implementation InfiniteeRefreshFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action bottomInset:(CGFloat)bottomInset {
    InfiniteeRefreshFooter *footer = [self footerWithRefreshingTarget:target refreshingAction:action];
    footer.bottomInset = bottomInset;
    return footer;
}

static NSArray<UIImage *> *refreshingImages_;
- (NSArray<UIImage *> *)refreshingImages {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 上下拉刷新图片
        NSMutableArray *images = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 27; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh_%zd.png", i]];
            [images addObject:image];
        }
        refreshingImages_ = [images copy];
    });
    return refreshingImages_;
}

#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    
    self.stateLabel.textColor = InfiniteeGray;
    self.stateLabel.hidden = YES;
    self.stateLabel.layer.opacity = 0;
    
    NSArray *refreshingImages = self.refreshingImages;
    
    // 拖动时的状态
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    
    // 提示松开就可以进行刷新时的状态
    [self setImages:refreshingImages duration:0.8 forState:MJRefreshStatePulling];
    
    // 正在刷新时的状态
    [self setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    self.mj_w = [[UIScreen mainScreen] bounds].size.width;
    self.mj_h = 44;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    self.gifView.contentMode = UIViewContentModeScaleToFill;
    self.gifView.frame = CGRectMake((self.mj_w - RefreshImageWidth) * 0.5,
                                    (self.mj_h - RefreshImageHeight) * 0.5 + self.bottomInset,
                                    RefreshImageWidth,
                                    RefreshImageHeight);
    
    self.stateLabel.mj_y = (self.mj_h - self.stateLabel.mj_h) * 0.5 + self.bottomInset;
}

- (void)beginRefreshing {
    [super beginRefreshing];
    self.stateLabel.hidden = YES;
    self.stateLabel.layer.opacity = 0;
}

- (void)endRefreshing {
    [super endRefreshing];
    self.stateLabel.hidden = YES;
    self.stateLabel.layer.opacity = 0;
}

- (void)resetNoMoreData {
    [super resetNoMoreData];
    self.stateLabel.hidden = YES;
    self.stateLabel.layer.opacity = 0;
}

- (void)endRefreshingWithNoMoreData {
    [super endRefreshingWithNoMoreData];
    self.alpha = 1;
    self.stateLabel.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0.25 options:0 animations:^{
        self.stateLabel.layer.opacity = 1;
    } completion:nil];
}

@end
