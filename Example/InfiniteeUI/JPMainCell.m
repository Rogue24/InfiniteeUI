//
//  JPMainCell.m
//  JPImageresizerView_Example
//
//  Created by 周健平 on 2020/11/2.
//  Copyright © 2020 ZhouJianPing. All rights reserved.
//

#import "JPMainCell.h"
#import "JPBounceView.h"

@interface JPMainCell()
@property (nonatomic, weak) JPBounceView *bounceView;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) CALayer *shadowLayer;
@property (nonatomic, weak) UILabel *iconLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation JPMainCell

static NSString *cellID_;
static UIFont *iconFont_;
static UIFont *titleFont_;
static UIColor *textColor_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellID_ = @"JPMainCell";
        iconFont_ = [UIFont infiniteeFontWithSize:JPScaleValue(24)];
        titleFont_ = JPScaleBoldFont(11);
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
        bounceView.backgroundColor = InfiniteeBlack;
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
        bounceView.viewTouchUpInside = ^(JPBounceView *kBounceView) {
            @jp_strongify(self);
            if (!self) return;
            !self.didClickCell ? : self.didClickCell(self.cellModel);
        };
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [bounceView addSubview:imageView];
        self.imageView = imageView;
        
        CALayer *shadowLayer = [CALayer layer];
        shadowLayer.backgroundColor = JPRGBAColor(0, 0, 0, 0.1).CGColor;
        [bounceView.layer addSublayer:shadowLayer];
        self.shadowLayer = shadowLayer;
        
        UILabel *iconLabel = [[UILabel alloc] init];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.textColor = textColor_;
        iconLabel.font = iconFont_;
        iconLabel.layer.shadowColor = JPRGBAColor(0, 0, 0, 0.5).CGColor;
        iconLabel.layer.shadowOpacity = 1;
        iconLabel.layer.shadowRadius = 6;
        iconLabel.layer.shadowOffset = CGSizeMake(0, 5);
        [bounceView addSubview:iconLabel];
        self.iconLabel = iconLabel;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = textColor_;
        titleLabel.font = titleFont_;
        titleLabel.layer.shadowColor = JPRGBAColor(0, 0, 0, 0.5).CGColor;
        titleLabel.layer.shadowOpacity = 1;
        titleLabel.layer.shadowRadius = 6;
        titleLabel.layer.shadowOffset = CGSizeMake(0, 5);
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
    
    self.iconLabel.frame = CGRectMake(0, JPScaleValue(25), self.bounceView.bounds.size.width, iconFont_.lineHeight + 2);
    self.titleLabel.frame = CGRectMake(0, self.bounceView.bounds.size.height - titleFont_.lineHeight - JPScaleValue(25), self.bounceView.bounds.size.width, titleFont_.lineHeight);
}

- (void)setCellModel:(JPMainCellModel *)cellModel {
    _cellModel = cellModel;
    
    NSURL *randomURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://picsum.photos/400/200?random=%zd", JPRandomNumber(1, 500)]];
    [self.imageView jp_fakeSetPictureCacheMemoryOnlyWithURL:randomURL placeholderImage:nil];
    
    self.iconLabel.text = cellModel.icon;
    self.titleLabel.text = cellModel.title;
}

@end
