//
//  JPLabel.m
//  Infinitee2.0
//
//  Created by guanning on 2017/5/14.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPLabel.h"

@implementation JPLabel

- (JPLabel *(^)(UIColor *))jp_textColor {
    return ^(UIColor *color) {
        self.textColor = color;
        return self;
    };
}

- (JPLabel *(^)(NSString *))jp_text {
    return ^(NSString *text) {
        self.text = text;
        return self;
    };
}

- (JPLabel *(^)(UIFont *))jp_font {
    return ^(UIFont *font) {
        self.font = font;
        return self;
    };
}

@end
