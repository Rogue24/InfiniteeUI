//
//  JPLabel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/5/14.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPLabel : UILabel
@property (nonatomic, copy, readonly) JPLabel *(^jp_textColor)(UIColor *color);
@property (nonatomic, copy, readonly) JPLabel *(^jp_text)(NSString *text);
@property (nonatomic, copy, readonly) JPLabel *(^jp_font)(UIFont *font);
@end
