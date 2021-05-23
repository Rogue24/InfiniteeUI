//
//  JPTextView.m
//  健平不得姐
//
//  Created by ios app on 16/6/3.
//  Copyright © 2016年 cb2015. All rights reserved.
//

#import "JPTextView.h"

CGFloat const JPCursorMargin = 5.0;

@interface JPTextView () <UITextViewDelegate>
@property(nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation JPTextView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.alwaysBounceVertical = YES;
    self.delegate = self;
    self.placeholderColor = [UIColor lightGrayColor];
}

#pragma mark - override method

// iPhone5 不知道为何切换类型相同的类（例如textfield之间切换）不能触发键盘通知方法，设置个block来主动触发
- (BOOL)becomeFirstResponder {
    BOOL currResponder = self.isFirstResponder;
    if (!currResponder) {
        !self.firstResponderHandle ? : self.firstResponderHandle(self, YES);
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    BOOL currResponder = self.isFirstResponder;
    if (currResponder) {
        !self.firstResponderHandle ? : self.firstResponderHandle(self, NO);
    }
    return [super resignFirstResponder];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_placeholderLabel) return;
    CGFloat x = self.textContainerInset.left + JPCursorMargin;
    CGFloat y = self.textContainerInset.top;
    CGFloat w = self.bounds.size.width - 2 * x;
    CGFloat h = 999;
    self.placeholderLabel.frame = (CGRect){CGPointMake(x, y), [self.placeholderLabel sizeThatFits:CGSizeMake(w, h)]};
}

#pragma mark - setter

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (!_placeholderLabel) return;
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    _placeholderLabel.hidden = self.hasText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    _placeholderLabel.hidden = self.hasText;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    _placeholderLabel.textColor = placeholderColor;
}

#pragma mark - getter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = self.font;
        placeholderLabel.textColor = self.placeholderColor ? self.placeholderColor : UIColor.lightTextColor;
        placeholderLabel.hidden = self.hasText;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

#pragma mark - public method

- (void)setAndCheckText:(NSString *)text {
    NSInteger textLength = text.length;
    if (self.isNotCountInLineBreak) {
        textLength = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length;
    }
    if (self.maxLimitNums > 0) {
        if (textLength > self.maxLimitNums) {
            // 截取到最大位置的字符(由于超出截部分在should时被处理了在这里提高效率不再判断)
            if (self.isNotCountInLineBreak) {
                __block NSInteger idx = 0;
                __block NSString *trimString = @"";
                [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                    if (idx >= self.maxLimitNums) {
                        *stop = YES; // 取出所需要就break，提高效率
                        return;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    if (![substring isEqualToString:@"\n"]) {
                        idx++;
                    }
                }];
                text = trimString;
            } else {
                text = [text substringToIndex:self.maxLimitNums];
            }
            !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
            !self.currentLimitNums ? : self.currentLimitNums(self.maxLimitNums, self.maxLimitNums);
        } else {
            !self.currentLimitNums ? : self.currentLimitNums(textLength, self.maxLimitNums);
        }
    } else {
        !self.currentLimitNums ? : self.currentLimitNums(textLength, 0);
    }
    
    // 通过代码设置Text不会触发textViewDidChange，交互时才会触发（例如粘贴）
    [self setText:text];
    !self.textDidChange ? : self.textDidChange(self, NO);
}

#pragma mark - private method

- (BOOL)returnKeyDidClickWithNewlineRang:(NSRange)newlineRange {
    if (!self.returnKeyDidClick) return YES;
    NSString *content = [self.text stringByReplacingCharactersInRange:newlineRange withString:@""];
    return self.returnKeyDidClick(self, content);
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidBeginEditing:(JPTextView *)textView {
    !self.textDidBeginEditing ? : self.textDidBeginEditing(textView);
}

- (void)textViewDidEndEditing:(JPTextView *)textView {
    !self.textDidEndEditing ? : self.textDidEndEditing(textView);
}

// 有联想字选择时触发（每次输入还未确定的内容不是所有内容）
// return NO 不会继续执行textViewDidChange
- (BOOL)textView:(JPTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // 监听键盘点击右下角按钮是不是换行符
    if ([text isEqualToString:@"\n"]) {
        // 如果返回NO，即不继续，就return
        if (![self returnKeyDidClickWithNewlineRang:range]) {
            return NO;
        }
    }
    
    if (self.maxLimitNums <= 0) return YES;
    
    UITextRange *selectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        // 起始位置有没有超过限制字数
        NSInteger maxLimitNums = self.maxLimitNums;
        if (self.isNotCountInLineBreak) {
            maxLimitNums += [textView.text componentsSeparatedByString:@"\n"].count - 1;
        }
        if (offsetRange.location < maxLimitNums) {
            return YES;
        } else {
            !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
            !self.currentLimitNums ? : self.currentLimitNums(self.maxLimitNums, self.maxLimitNums);
            !self.textDidChange ? : self.textDidChange(self, NO);
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.isNotCountInLineBreak) {
        comcatstr = [comcatstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    // 当前字数与限制字数的差值
    NSInteger caninputlen = self.maxLimitNums - comcatstr.length;
    
    if (caninputlen >= 0) {
        return YES;
    } else {
        // 当联想的字数加上当前字数超过限制时，进行处理
        NSInteger len;
        if (self.isNotCountInLineBreak) {
            len = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length;
        } else {
            len = text.length;
        }
        len += caninputlen;
        // 防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0, MAX(len, 0)};
        if (rg.length > 0) {
            NSString *s = @"";
            // 判断是否只普通的字符或asc码(对于中文和表情返回NO)
            if (!self.isNotCountInLineBreak && [text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                s = [text substringWithRange:rg]; // 因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx = 0;
                __block NSString *trimString = @""; // 截取出的字串
                // 使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                    if (idx >= rg.length) {
                        *stop = YES; // 取出所需要就break，提高效率
                        return;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    if (!self.isNotCountInLineBreak || ![substring isEqualToString:@"\n"]) {
                        idx++;
                    }
                }];
                s = trimString;
            }
            // rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
        !self.currentLimitNums ? : self.currentLimitNums(self.maxLimitNums, self.maxLimitNums);
        !self.textDidChange ? : self.textDidChange(self, NO);
        return NO;
    }
}

- (void)textViewDidChange:(JPTextView *)textView {
    _placeholderLabel.hidden = self.hasText;
    
    UITextRange *selectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        !self.textDidChange ? : self.textDidChange(self, YES);
        return;
    }
    
    NSString *text = textView.text;
    NSInteger textLength = text.length;
    if (self.isNotCountInLineBreak) {
        textLength = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length;
    }
    
    if (self.maxLimitNums <= 0) {
        !self.currentLimitNums ? : self.currentLimitNums(textLength, 0);
        !self.textDidChange ? : self.textDidChange(self, NO);
        return;
    }
    
    if (textLength > self.maxLimitNums) {
        // 截取到最大位置的字符(由于超出截部分在should时被处理了在这里提高效率不再判断)
        if (self.isNotCountInLineBreak) {
            __block NSInteger idx = 0;
            __block NSString *trimString = @"";
            [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                if (idx >= self.maxLimitNums) {
                    *stop = YES; // 取出所需要就break，提高效率
                    return;
                }
                trimString = [trimString stringByAppendingString:substring];
                if (![substring isEqualToString:@"\n"]) {
                    idx++;
                }
            }];
            text = trimString;
        } else {
            text = [text substringToIndex:self.maxLimitNums];
        }
        [textView setText:text];
        !self.reachMaxLimitNums ? : self.reachMaxLimitNums(self.maxLimitNums);
        !self.currentLimitNums ? : self.currentLimitNums(self.maxLimitNums, self.maxLimitNums);
    } else {
        !self.currentLimitNums ? : self.currentLimitNums(textLength, self.maxLimitNums);
    }
    
    !self.textDidChange ? : self.textDidChange(self, NO);
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.textKeepTheTop) [scrollView setContentOffset:CGPointZero];
}

@end
