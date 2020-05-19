//
//  SunOrderTitleCell.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderTitleCell.h"

@interface SunOrderTitleCell ()
//@property (nonatomic, weak) YYLabel *iconLabel;
//@property (nonatomic, weak) YYLabel *titleLabel;
@property (nonatomic, weak) UILabel *iconLabel;
@property (nonatomic, weak) UILabel *faceLabel;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation SunOrderTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat scale = JPScale;
        
//        YYLabel *iconLabel = [YYLabel new];
//        iconLabel.userInteractionEnabled = NO;
//        iconLabel.font = [UIFont infiniteeFontWithSize:13 * scale];
//        iconLabel.textAlignment = NSTextAlignmentCenter;
//        iconLabel.fadeOnHighlight = NO;
//        iconLabel.fadeOnAsynchronouslyDisplay = NO;
//        [self addSubview:iconLabel];
//        self.iconLabel = iconLabel;
//        
//        YYLabel *titleLabel = [YYLabel new];
//        titleLabel.userInteractionEnabled = NO;
//        titleLabel.font = [UIFont systemFontOfSize:12 * scale];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.fadeOnHighlight = NO;
//        titleLabel.fadeOnAsynchronouslyDisplay = NO;
//        [self addSubview:titleLabel];
//        self.titleLabel = titleLabel;
        
        UILabel *iconLabel = [UILabel new];
        iconLabel.font = [UIFont productFontWithSize:13 * scale];
        iconLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:iconLabel];
        self.iconLabel = iconLabel;
        
        UILabel *faceLabel = [UILabel new];
        faceLabel.font = [UIFont infiniteeFontWithSize:JPScaleValue(13)];
        faceLabel.text = @"";
        faceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:faceLabel];
        self.faceLabel = faceLabel;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:12 * scale];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
    }
    return self;
}

- (void)setSocVM:(SunOrderCategoryViewModel *)socVM {
    _socVM = socVM;
    
    SunOrderCategoryModel *socModel = socVM.socModel;
    
    if (socModel.isInfiniteeFont) {
        self.faceLabel.hidden = NO;
        self.iconLabel.hidden = YES;
    } else {
        self.iconLabel.text = socModel.icon;
        self.iconLabel.hidden = NO;
        self.faceLabel.hidden = YES;
    }
    
    self.titleLabel.text = socModel.name;
    
    self.iconLabel.frame = CGRectMake(ViewMargin, 0, socVM.styleIconW, self.jp_height);
    self.faceLabel.frame = self.iconLabel.frame;
    self.titleLabel.frame = CGRectMake(self.iconLabel.jp_maxX + (self.iconLabel.jp_width > 0 ? CellMargin : 0), 0, socVM.styleNameW, self.jp_height);
    
    [self setTitleColor:(socVM.isSelected ? SOTitleSelectedColor : SOTitleDeselectColor)];
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.faceLabel.textColor = titleColor;
    self.iconLabel.textColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

@end
