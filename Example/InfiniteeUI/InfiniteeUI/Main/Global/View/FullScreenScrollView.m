//
//  FullScreenScrollView.m
//  Infinitee2.0
//
//  Created by guanning on 2017/1/3.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "FullScreenScrollView.h"

@interface FullScreenScrollView ()

@end

@implementation FullScreenScrollView

#pragma mark - 最终方案：让左边边缘区域无法响应，让事件传递到父控制器（缺陷：左边宽20的区域无法滚动）

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isNotFull) {
        return [super hitTest:point withEvent:event];
    }
    CGRect frame = CGRectMake(0, 0, 20, self.frame.size.height);
    if (!CGRectContainsPoint(frame, point)) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}


// 参考：http://www.jianshu.com/p/c01d006f9821

#pragma mark - 方法一：【不自定义返回按钮】时有效

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    
//    if ([self panBack:gestureRecognizer]) {
//        return YES;
//    }
//    return NO;
//    
//}
//
//- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
//    
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint point = [pan translationInView:self];
//        UIGestureRecognizerState state = gestureRecognizer.state;
//        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
//            CGPoint location = [gestureRecognizer locationInView:self];
//            if (point.x > 0 && location.x < 20 && self.contentOffset.x <= 0) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//}

#pragma mark - 方法二：不灵敏

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    // 首先判断otherGestureRecognizer是不是系统pop手势
//    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
//        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.contentOffset.x == 0) {
//            return YES;
//        }
//    }
//
//    return NO;
//}

@end
