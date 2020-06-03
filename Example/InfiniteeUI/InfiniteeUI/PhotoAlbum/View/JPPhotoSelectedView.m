//
//  JPPhotoSelectedView.m
//  Infinitee2.0
//
//  Created by 周健平 on 2018/8/12.
//  Copyright © 2018 Infinitee. All rights reserved.
//

#import "JPPhotoSelectedView.h"
#import "JPScreenBorderButton.h"

@interface JPPhotoSelectedView ()
@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, weak) JPScreenBorderButton *confirmBtn;
@end

@implementation JPPhotoSelectedView

+ (JPPhotoSelectedView *)photoSelectedViewWithConfirmBlock:(void (^)(void))confirmBlock cancelBlock:(void (^)(void))cancelBlock {
    JPPhotoSelectedView *psView = [[self alloc] initWithFrame:CGRectMake(0, JPPortraitScreenHeight, JPPortraitScreenWidth, JPScaleValue(54) + JPDiffTabBarH)];
    psView.confirmBlock = confirmBlock;
    psView.cancelBlock = cancelBlock;
    return psView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor = InfiniteeBlueA(0.1).CGColor;
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 0, frame.size.width, JPSeparateLineThick + 0.01);
        line.backgroundColor = InfiniteeBlueA(0.3).CGColor;
        [self.layer addSublayer:line];
        
        CGFloat x = JP15Margin;
        CGFloat y = x;
        CGFloat w = (frame.size.width - 3 * x) * 0.5;
        CGFloat h = frame.size.height - JPDiffTabBarH - 2 * y;
        
        JPScreenBorderButton *cancelBtn = ({
            JPScreenBorderButton *btn = [JPScreenBorderButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = JPScaleFont(12);
            [btn setTitle:@"取消已选" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:InfiniteeGray];
            [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(x, y, w, h);
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;
            btn;
        });
        [self addSubview:cancelBtn];
        
        x = CGRectGetMaxX(cancelBtn.frame) + x;
        JPScreenBorderButton *confirmBtn = ({
            JPScreenBorderButton *btn = [JPScreenBorderButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = JPScaleFont(12);
            [btn setTitle:@"已选照片" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateHighlighted];
            [btn setBackgroundColor:InfiniteeBlue];
            [btn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(x, y, w, h);
            btn.layer.cornerRadius = 2;
            btn.layer.masksToBounds = YES;
            btn;
        });
        [self addSubview:confirmBtn];
        self.confirmBtn = confirmBtn;
    }
    return self;
}

- (void)cancelAction {
    self.isShowed = NO;
    !self.cancelBlock ? : self.cancelBlock();
}

- (void)confirmAction {
    self.isShowed = NO;
    !self.confirmBlock ? : self.confirmBlock();
}

- (void)setCount:(NSInteger)count {
    _count = count;
    [UIView performWithoutAnimation:^{
        [self.confirmBtn setTitle:(count > 0 ? [NSString stringWithFormat:@"已选照片×%zd", count] : @"已选照片") forState:UIControlStateNormal];
    }];
    self.isShowed = count > 0;
}

- (void)setIsShowed:(BOOL)isShowed {
    if (_isShowed == isShowed) {
        return;
    }
    _isShowed = isShowed;
    [UIView animateWithDuration:0.18 animations:^{
        self.jp_y = JPPortraitScreenHeight + (isShowed ? -self.jp_height : 0);
    }];
}

@end
