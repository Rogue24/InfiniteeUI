//
//  UserWorksEditTitleView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/3/1.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "RequestStateTitleView.h"

@interface RequestStateTitleView ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIActivityIndicatorView *jvhua;
@end

@implementation RequestStateTitleView

+ (instancetype)requestStateTitleViewWithTitle:(NSString *)title state:(TitleViewState)state {
    RequestStateTitleView *rstView = [[self alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [rstView setTitle:title withState:NormalState];
    return rstView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = InfiniteeBlack;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIActivityIndicatorView *jvhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        jvhua.hidesWhenStopped = YES;
        [self addSubview:jvhua];
        [jvhua stopAnimating];
        jvhua.layer.opacity = 0;
        self.jvhua = jvhua;
        
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setTitle:(NSString *)title withState:(TitleViewState)state {
    self.title = title;
    self.state = state;
}

- (void)setState:(TitleViewState)state {
    if (_state == state) return;
    _state = state;
    
    if (state == NormalState) {
        [self.jvhua stopAnimating];
    } else if (!self.jvhua.isAnimating) {
        [self.jvhua startAnimating];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.jvhua.layer.opacity = state == NormalState ? 0 : 1;
    }];
}

- (void)setTitle:(NSString *)title {
    if ([title isEqualToString:self.titleLabel.text]) return;
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.jp_centerX = self.jp_width * 0.5;
    self.titleLabel.jp_centerY = self.jp_height * 0.5;
    
    self.jvhua.jp_x = self.titleLabel.jp_x - self.jvhua.jp_width - 10;
    self.jvhua.jp_centerY = self.titleLabel.jp_centerY;
}

- (NSString *)title {
    return [self.titleLabel.text copy];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(150, 44);
}

@end
