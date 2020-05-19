//
//  InfiniteeTextLayoutParameter.h
//  Infinitee2.0
//
//  Created by guanning on 2017/8/7.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfiniteeTextLayoutParameter : NSObject
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) NSInteger row;
@end
