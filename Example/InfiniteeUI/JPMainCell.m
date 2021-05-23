//
//  JPMainCell.m
//  JPImageresizerView_Example
//
//  Created by 周健平 on 2020/11/2.
//  Copyright © 2020 ZhouJianPing. All rights reserved.
//

#import "JPMainCell.h"

@implementation JPMainCell

static NSString *cellID_;
static UIFont *iconFont_;
static UIFont *titleFont_;
static UIColor *textColor_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellID_ = @"JPMainCell";
        iconFont_ = [UIFont infiniteeFontWithSize:JPScaleValue(25)];
        titleFont_ = JPScaleBoldFont(12);
        textColor_ = UIColor.whiteColor;
    });
}

+ (NSString *)cellID {
    return cellID_;
}

+ (UIFont *)iconFont {
    return iconFont_;
}

+ (UIFont *)titleFont {
    return titleFont_;
}

+ (UIColor *)textColor {
    return textColor_;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        
        JPBounceView *bounceView = [[JPBounceView alloc] init];
        bounceView.scale = 0.97;
        bounceView.recoverSpeed = 15;
        bounceView.recoverBounciness = 15;
        bounceView.scaleDuration = 0.35;
        bounceView.layer.cornerRadius = JP8Margin;
        bounceView.layer.masksToBounds = YES;
        [self.contentView addSubview:bounceView];
        self.bounceView = bounceView;
        
        @jp_weakify(self);
        bounceView.touchingDidChanged = ^(JPBounceView *kBounceView, BOOL isTouching) {
            @jp_strongify(self);
            if (!self) return;
            if (isTouching) {
                POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                anim.toValue = @(CGPointMake(1.03, 1.03));
                anim.duration = kBounceView.scaleDuration;
                [self.imageView.layer pop_addAnimation:anim forKey:kPOPLayerScaleXY];
            } else {
                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
                anim.toValue = @(CGPointMake(1.0, 1.0));
                anim.springSpeed = kBounceView.recoverSpeed;
                anim.springBounciness = kBounceView.recoverBounciness;
                [self.imageView.layer pop_addAnimation:anim forKey:kPOPLayerScaleXY];
            }
        };
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [bounceView addSubview:imageView];
        self.imageView = imageView;
        
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.backgroundColor = JPRGBAColor(0, 0, 0, 0.35).CGColor;
        [bounceView.layer addSublayer:shadowLayer];
        self.shadowLayer = shadowLayer;
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.font = iconFont_;
        iconLabel.textColor = textColor_;
        [bounceView addSubview:iconLabel];
        self.iconLabel = iconLabel;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = titleFont_;
        titleLabel.textColor = textColor_;
        [bounceView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.bounceView.bounds.size.width == self.bounds.size.width) return;
    
    self.bounceView.bounds = self.bounds;
    self.bounceView.frame = self.bounds;
    
    self.imageView.frame = self.bounceView.bounds;
    self.shadowLayer.frame = self.bounceView.bounds;
    
    self.iconLabel.frame = CGRectMake(0, JPScaleValue(20), self.bounceView.bounds.size.width, iconFont_.lineHeight + 2);
    self.titleLabel.frame = CGRectMake(0, self.bounceView.bounds.size.height - titleFont_.lineHeight - JPScaleValue(20), self.bounceView.bounds.size.width, titleFont_.lineHeight);
}

@end
