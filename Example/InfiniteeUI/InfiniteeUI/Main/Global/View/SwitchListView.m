//
//  SwitchListView.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/23.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "SwitchListView.h"

@interface SwitchListView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, assign) BOOL left;
@end

@implementation SwitchListView

+ (instancetype)switchListViewWithLeftClick:(void (^)(void))leftClick rightClick:(void (^)(void))rightClick {
    
    SwitchListView *switchListView = [self jp_viewLoadFromNib];
    // 不随父视图的改变而改变（xib文件有可能会拉伸）
    switchListView.autoresizingMask = UIViewAutoresizingNone;
    
    [switchListView.leftBtn addTarget:switchListView action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [switchListView.rightBtn addTarget:switchListView action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    switchListView.bgImageView.image = [UIImage imageNamed:@"nav_left.png"];
    switchListView.leftBtn.selected = YES;
    switchListView.rightBtn.selected = NO;
    
    switchListView.leftClick = leftClick;
    switchListView.rightClick = rightClick;
    switchListView.left = YES;
    
    return switchListView;
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = [leftTitle copy];
    [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
}

- (void)setRightTitle:(NSString *)rightTitle {
    _rightTitle = [rightTitle copy];
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
}

- (void)leftAction {
    self.bgImageView.image = [UIImage imageNamed:@"nav_left.png"];
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    self.left = YES;
    !self.leftClick ? : self.leftClick();
}

- (void)rightAction {
    self.bgImageView.image = [UIImage imageNamed:@"nav_right.png"];
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
    self.left = NO;
    !self.rightClick ? : self.rightClick();
}

- (BOOL)isLeft {
    return self.left;
}

@end
