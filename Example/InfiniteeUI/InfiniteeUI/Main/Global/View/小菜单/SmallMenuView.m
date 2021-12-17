//
//  SmallMenuView.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "SmallMenuView.h"
#import "SmallMenuItem.h"

@interface SmallMenuView () <UIGestureRecognizerDelegate>
@property (nonatomic, copy) void (^itemClick)(NSInteger selectIndex);
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, assign) BOOL animationDone;
@end

@implementation SmallMenuView

static UIWindow *window_;

+ (void)smallMenuViewOnView:(UIView *)view customWidth:(CGFloat)width menuModels:(NSArray *)models itemClick:(void (^)(NSInteger selectIndex))itemClick {
    SmallMenuView *menu = [[SmallMenuView alloc] init];
    menu.frame = view.bounds;
    menu.itemClick = [itemClick copy];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menu action:@selector(dismiss)];
    tap.delegate = menu;
    [menu addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = InfiniteeBlue;
    contentView.layer.anchorPoint = CGPointMake(1.0, 0);
    contentView.layer.cornerRadius = 2;
    contentView.layer.masksToBounds = YES;
    contentView.frame = CGRectMake(view.jp_width - width - 10, JPStatusBarH + ViewMargin, width, SmallMenuItemHeight * models.count + 10);
    
    for (NSInteger i = 0; i < models.count; i++) {
        SmallMenuModel *model = models[i];
        
        SmallMenuItem *item = [SmallMenuItem smallMenuItemWithModel:model index:i target:menu action:@selector(itemClick:)];
        item.jp_width = width;
        item.jp_height = SmallMenuItemHeight;
        item.jp_x = 0;
        item.jp_y = 5 + i * item.jp_height;
        [contentView addSubview:item];
    }
    
    [menu addSubview:contentView];
    menu.contentView = contentView;
    
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [UIColor clearColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.rootViewController = [UIViewController new];
    window_.hidden = NO;
    [window_ addSubview:menu];
    [window_ makeKeyWindow];
    
    [menu show];
}

+ (void)smallMenuViewOnView:(UIView *)view menuModels:(NSArray *)models itemClick:(void (^)(NSInteger selectIndex))itemClick {
    
    SmallMenuView *menu = [[SmallMenuView alloc] init];
    menu.frame = view.bounds;
    menu.itemClick = [itemClick copy];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:menu action:@selector(dismiss)];
    tap.delegate = menu;
    [menu addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = InfiniteeBlue;
    contentView.layer.anchorPoint = CGPointMake(1.0, 0);
    contentView.layer.cornerRadius = 2;
    contentView.layer.masksToBounds = YES;
    contentView.frame = CGRectMake(view.jp_width - SmallMenuViewWidth - 10, JPStatusBarH + ViewMargin, SmallMenuViewWidth, SmallMenuItemHeight * models.count + 10);
    
    for (NSInteger i = 0; i < models.count; i++) {
        SmallMenuModel *model = models[i];
        
        SmallMenuItem *item = [SmallMenuItem smallMenuItemWithModel:model index:i target:menu action:@selector(itemClick:)];
        item.jp_width = SmallMenuViewWidth;
        item.jp_height = SmallMenuItemHeight;
        item.jp_x = 0;
        item.jp_y = 5 + i * item.jp_height;
        [contentView addSubview:item];
    }
    
    [menu addSubview:contentView];
    menu.contentView = contentView;
    
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [UIColor clearColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.rootViewController = [UIViewController new];
    window_.hidden = NO;
    [window_ addSubview:menu];
    [window_ makeKeyWindow];
    
    [menu show];
}

- (void)dealloc {
    JPLog(@"菜单已死");
}

- (void)itemClick:(UIButton *)btn {
    [self dismissWithClickHandle:^{
        !self.itemClick ? : self.itemClick(btn.tag);
    }];
}

- (void)show {
    self.contentView.layer.transform = CATransform3DScale(self.contentView.layer.transform, 0.4, 0.4, 1);
    self.contentView.layer.opacity = 0;
    
    POPBasicAnimation *opacAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacAnim.duration = 0.2;
    opacAnim.toValue = @1;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.duration = 0.2;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.animationDone = YES;
    };
    
    [self.contentView.layer pop_addAnimation:anim forKey:nil];
    [self.contentView.layer pop_addAnimation:opacAnim forKey:nil];
}

- (void)dismiss {
    [self dismissWithClickHandle:nil];
}

- (void)dismissWithClickHandle:(void(^)(void))clickHandle {
    POPBasicAnimation *opacAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacAnim.duration = 0.2;
    opacAnim.toValue = @0;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.duration = 0.2;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0.4, 0.4)];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        self.animationDone = YES;
        !clickHandle ? : clickHandle();
        [self removeFromSuperview];
        window_.hidden = YES;
        window_ = nil;
    };
    
    [self.contentView.layer pop_addAnimation:anim forKey:nil];
    [self.contentView.layer pop_addAnimation:opacAnim forKey:nil];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.animationDone == NO) {
        return NO;
    }
    if (touch.view != self){
        return NO;
    }
    return YES;
}

@end
