//
//  ActivityIntroductionView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/3/15.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "ActivityIntroductionView.h"
#import "JPLabel.h"

@interface ActivityIntroductionView ()
@property (nonatomic, weak) JPLabel *titleLabel;
@property (nonatomic, weak) UILabel *ruleLabel;
@end

@implementation ActivityIntroductionView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        JPLabel *titleLabel = [[JPLabel alloc] init];
        titleLabel.jp_font([UIFont systemFontOfSize:12]).jp_textColor(InfiniteeBlackA(0.5)).jp_text(@"主题介绍");
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel *ruleLabel = [[UILabel alloc] init];
        ruleLabel.numberOfLines = 0;
        ruleLabel.font = [UIFont systemFontOfSize:14];
        ruleLabel.textColor = InfiniteeBlack;
        [self addSubview:ruleLabel];
        self.ruleLabel = ruleLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.jp_x = ViewMargin;
    self.titleLabel.jp_y = 15;
    self.ruleLabel.jp_x = ViewMargin;
    self.ruleLabel.jp_y = self.titleLabel.jp_maxY + ViewMargin;
}

+ (ActivityIntroductionView *)activityIntroductionViewWithRule:(NSString *)rule ruleSize:(CGSize)ruleSize {
    
    ActivityIntroductionView *aiView = [[self alloc] init];
    
//    CGSize maxSize = CGSizeMake(JPPortraitScreenWidth - 4 * ViewMargin, MAXFLOAT);
//    CGSize ruleSize = [rule boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:aiView.ruleLabel.font} context:nil].size;
    
    aiView.ruleLabel.text = rule;
    aiView.ruleLabel.jp_size = ruleSize;
    
    aiView.jp_width = JPPortraitScreenWidth - 2 * ViewMargin;
    aiView.jp_height = 15 + aiView.titleLabel.jp_height + ViewMargin + ruleSize.height + ViewMargin;
    
    aiView.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
    aiView.layer.borderWidth = JPSeparateLineThick + 0.01;
    
    return aiView;
}

@end
