//
//  NoDataView.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/26.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()
@property (nonatomic, assign) BOOL isWholeCenter;
@property (nonatomic, weak) UILabel *iconLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation NoDataView

+ (NoDataView *)noDataViewWithTitle:(NSString *)title onView:(UIView *)superView center:(CGPoint)center {
    return [self noDataViewWithTitle:title onView:superView center:center isWholeCenter:NO];
}

+ (NoDataView *)noDataViewWithTitle:(NSString *)title onView:(UIView *)superView center:(CGPoint)center isWholeCenter:(BOOL)isWholeCenter {
    NoDataView *noDataView = [[self alloc] initWithTitle:title isWholeCenter:isWholeCenter];
    noDataView.userInteractionEnabled = NO;
    noDataView.layer.opacity = 0;
    
    [superView addSubview:noDataView];
    noDataView.center = center;
    
    return noDataView;
}

- (instancetype)initWithTitle:(NSString *)title isWholeCenter:(BOOL)isWholeCenter {
    if (self = [super init]) {
        self.isWholeCenter = isWholeCenter;
        
        NSInteger iconLabelWHInt = (NSInteger)JPPortraitScreenWidth * (100 / iPhone6Width);
        CGFloat iconLabelWH = (CGFloat)iconLabelWHInt;
        CGFloat iconFontSize = JPPortraitScreenWidth * (50 / iPhone6Width);
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.jp_size = CGSizeMake(iconLabelWH, iconLabelWH);
        iconLabel.textColor = [UIColor whiteColor];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.font = [UIFont infiniteeFontWithSize:iconFontSize];
        iconLabel.backgroundColor = InfiniteeGrayA(0.6);
        iconLabel.text = @"";
        iconLabel.layer.cornerRadius = iconLabelWH * 0.5;
        iconLabel.layer.masksToBounds = YES;
        [self addSubview:iconLabel];
        self.iconLabel = iconLabel;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = InfiniteeGray;
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [titleLabel sizeToFit];
        if (titleLabel.jp_width < iconLabel.jp_width) titleLabel.jp_width = iconLabel.jp_width;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        _title = title;
        
        CGFloat width = MAX(titleLabel.jp_width, iconLabel.jp_width);
        CGFloat height = isWholeCenter ? (iconLabel.jp_height + (titleLabel.jp_height ? (15 + titleLabel.jp_height) : 0)) : iconLabel.jp_height;
        
        iconLabel.jp_centerX = width * 0.5;
        iconLabel.jp_y = 0;
        
        titleLabel.jp_centerX = iconLabel.jp_centerX;
        titleLabel.jp_y = iconLabelWH + 15;
        
        self.jp_size = CGSizeMake(width, height);
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isWholeCenter) {
        return [super pointInside:point withEvent:event];
    }
    if (CGRectContainsPoint(CGRectMake(0, 0, self.jp_width, self.titleLabel.jp_maxY), point)) {
        return YES;
    } else {
        return NO;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupSubviewsLayout];
}

- (void)setupSubviewsLayout {
    CGAffineTransform transform = self.transform;
    CGPoint center = self.center;
    self.transform = CGAffineTransformIdentity;
    
    CGFloat width = self.iconLabel.jp_width;;
    CGFloat height = self.iconLabel.jp_height;
    
    if (self.titleLabel.jp_width < self.iconLabel.jp_width) {
        self.titleLabel.jp_width = self.iconLabel.jp_width;
    } else {
        width = MAX(self.titleLabel.jp_width, self.iconLabel.jp_width);
    }
    
    if (self.isWholeCenter && self.titleLabel.jp_height) {
        height += (15 + self.titleLabel.jp_height);
    }
    
    self.iconLabel.jp_centerX = width * 0.5;
    self.titleLabel.jp_centerX = self.iconLabel.jp_centerX;
    self.jp_size = CGSizeMake(width, height);
    
    self.center = center;
    self.transform = transform;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self setupSubviewsLayout];
}

- (void)show {
    if (self.layer.opacity < 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.layer.opacity = 1;
        }];
    }
}

- (void)hideWithCompletion:(void(^)(void))completion {
    if (self.layer.opacity == 0) {
        !completion ? : completion();
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.layer.opacity = 0;
        } completion:^(BOOL finished) {
            !completion ? : completion();
        }];
    }
}

@end
