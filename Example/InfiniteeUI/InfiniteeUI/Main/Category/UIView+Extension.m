//
//  UIView+Extension.m
//  Infinitee2.0
//
//  Created by 周健平 on 2019/9/7.
//  Copyright © 2019 Infinitee. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)jp_drawBorderLayerWithBounds:(CGRect)bounds borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    
    self.layer.borderWidth = 0;
    
    CAShapeLayer *borderLayer;
    
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer.name isEqualToString:@"JPDrawBorderLayer"]) {
            borderLayer = (CAShapeLayer *)sublayer;
            break;
        }
    }
    
    if (!borderLayer) {
        borderLayer = [CAShapeLayer layer];
        borderLayer.name = @"JPDrawBorderLayer";
        borderLayer.fillColor = [UIColor clearColor].CGColor;
    }
    
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius].CGPath;
    [self.layer addSublayer:borderLayer];
}

@end
