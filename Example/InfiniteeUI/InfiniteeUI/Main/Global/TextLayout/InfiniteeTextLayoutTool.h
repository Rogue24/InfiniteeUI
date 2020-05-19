//
//  InfiniteeTextLayoutTool.h
//  Infinitee2.0
//
//  Created by guanning on 2017/8/3.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfiniteeTextLayoutParameter.h"
#import <YYText.h>
@class InfiniteeTextLinePositionModifier;

@interface InfiniteeTextLayoutTool : NSObject

+ (YYTextLayout *)createTextLayoutWithText:(NSString *)text parameter:(InfiniteeTextLayoutParameter *)parameter;

+ (CGFloat)getTextHeightAndCreateTextLayoutWithText:(NSString *)text parameter:(InfiniteeTextLayoutParameter *)parameter textLayout:(YYTextLayout **)textLayout;

@end

/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface InfiniteeTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end
