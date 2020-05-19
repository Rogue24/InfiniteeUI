//
//  InfiniteeTextLayoutTool.m
//  Infinitee2.0
//
//  Created by guanning on 2017/8/3.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "InfiniteeTextLayoutTool.h"

@implementation InfiniteeTextLayoutTool

+ (YYTextLayout *)createTextLayoutWithText:(NSString *)text parameter:(InfiniteeTextLayoutParameter *)parameter {
    YYTextLayout *textLayout;
    [self getTextHeightAndCreateTextLayoutWithText:text parameter:parameter textLayout:&textLayout];
    return textLayout;
}

+ (CGFloat)getTextHeightAndCreateTextLayoutWithText:(NSString *)text parameter:(InfiniteeTextLayoutParameter *)parameter textLayout:(YYTextLayout **)textLayout {
    
    NSMutableAttributedString *aText = [[NSMutableAttributedString alloc] initWithString:text];
    aText.yy_font = parameter.font;
    aText.yy_color = parameter.textColor;
    aText.yy_lineSpacing = parameter.lineSpacing;
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(parameter.maxWidth, 9999)];
    container.maximumNumberOfRows = parameter.row;
    
    InfiniteeTextLinePositionModifier *modifier = [InfiniteeTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:parameter.font.pointSize];
    modifier.paddingTop = parameter.lineSpacing;
    modifier.paddingBottom = parameter.lineSpacing;
    
    container.linePositionModifier = modifier;
    
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:aText];
    
    CGFloat height = 0;
    if (layout) {
        height = [modifier heightForLineCount:layout.rowCount];
        *textLayout = layout;
    }
    
    return height;
}

@end

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation InfiniteeTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (@available(iOS 9.0, *)) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    InfiniteeTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end
