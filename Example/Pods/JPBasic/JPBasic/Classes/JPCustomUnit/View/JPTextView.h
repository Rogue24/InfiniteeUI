//
//  JPTextView.h
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import <UIKit/UIKit.h>

// 光标初始x值 = 5.0
UIKIT_EXTERN CGFloat const JPCursorMargin;

@interface JPTextView : UITextView

/**
 * 占位文本
 */
@property(nonatomic, copy) NSString *placeholder;

/**
 * 占位文本颜色
 */
@property(nonatomic, strong) UIColor *placeholderColor;

/**
 * 文本是否保持置顶
 */
@property (nonatomic, assign) BOOL textKeepTheTop;

/**
 * 可编辑的最大字数（不会包括联想）
 */
@property (nonatomic, assign) NSUInteger maxLimitNums;

/**
 * 最大字数是否不算上换行符
 */
@property (nonatomic, assign) BOOL isNotCountInLineBreak;

/**
 * 已达最多字数的回调
 */
@property (nonatomic, copy) void (^reachMaxLimitNums)(NSInteger maxLimitNums);

/**
 * 当前字数的回调
 */
@property (nonatomic, copy) void (^currentLimitNums)(NSInteger currentNums, NSInteger maxLimitNums);

/**
 * 第一响应者身份变化的回调
 */
@property (nonatomic, copy) void (^firstResponderHandle)(JPTextView *textView, BOOL isFirstResponder);

/**
 * 开始编辑的回调
 */
@property (nonatomic, copy) void (^textDidBeginEditing)(JPTextView *textView);

/**
 * 正在编辑的回调（isLenovo：是否正在联想状态）
 */
@property (nonatomic, copy) void (^textDidChange)(JPTextView *textView, BOOL isLenovo);

/**
 * 结束编辑的回调
 */
@property (nonatomic, copy) void (^textDidEndEditing)(JPTextView *textView);

/**
 * 点击了键盘return键的回调（finalText：最终文本）
 */
@property (nonatomic, copy) BOOL (^returnKeyDidClick)(JPTextView *textView, NSString *finalText);

/**
 * 通过代码设置文本并检查是否超出最大字数，如果超过，会触发reachMaxLimitNums回调
 */
- (void)setAndCheckText:(NSString *)text;

@end
