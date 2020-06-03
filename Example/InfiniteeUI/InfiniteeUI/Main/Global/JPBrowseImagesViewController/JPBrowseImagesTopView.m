//
//  BrowseImagesTopView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/8/4.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPBrowseImagesTopView.h"

@interface JPBrowseImagesTopView ()
@property (nonatomic, weak) UIButton *dismissBtn;
@property (nonatomic, weak) UILabel *indexLabel;
@property (nonatomic, weak) UIButton *shareBtn;
@end

@implementation JPBrowseImagesTopView

+ (instancetype)browseImagesTopViewWithPictureTotal:(NSInteger)total
                                              index:(NSInteger)index
                                             target:(id)target
                                      dismissAction:(SEL)dismissAction
                                        otherAction:(SEL)otherAction {
    JPBrowseImagesTopView *topView = [[self alloc] initWithFrame:CGRectMake(0, 0, JPPortraitScreenWidth, JPNavTopMargin) total:total index:index target:target dismissAction:dismissAction otherAction:otherAction];
    return topView;
}

- (instancetype)initWithFrame:(CGRect)frame total:(NSInteger)total index:(NSInteger)index target:(id)target dismissAction:(SEL)dismissAction otherAction:(SEL)otherAction {
    if (self = [super initWithFrame:frame]) {
        _total = total;
        _index = index;
        
        UIButton *dismissBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = [UIFont infiniteeFontWithSize:14];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.frame = CGRectMake(15, JPStatusBarH, JPNavBarH, JPNavBarH);
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:target action:dismissAction forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:dismissBtn];
        self.dismissBtn = dismissBtn;
        
        UILabel *indexLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.font = [UIFont systemFontOfSize:14];
            aLabel.textColor = [UIColor whiteColor];
            aLabel.frame = CGRectMake((JPPortraitScreenWidth - 200) * 0.5, JPStatusBarH, 200, JPNavBarH);
            aLabel;
        });
        [self addSubview:indexLabel];
        self.indexLabel = indexLabel;
        
        UIButton *shareBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.titleLabel.font = [UIFont infiniteeFontWithSize:18];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            btn.frame = CGRectMake(JPPortraitScreenWidth - JPNavBarH - 15, JPStatusBarH, JPNavBarH, JPNavBarH);
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:target action:otherAction forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:shareBtn];
        self.shareBtn = shareBtn;
        
        [self updateIndex];
    }
    return self;
}

- (void)setTotal:(NSInteger)total {
    _total = total;
    [self updateIndex];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    [self updateIndex];
}

- (void)updateIndex {
    self.indexLabel.text = [NSString stringWithFormat:@"%zd / %zd", _index + 1, _total];
}

@end
