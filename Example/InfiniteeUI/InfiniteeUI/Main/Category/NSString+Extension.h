//
//  NSString+Extension.h
//  Infinitee2.0-Design
//
//  Created by Jill on 16/9/27.
//  Copyright © 2016年 陈珏洁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

+ (NSString *)bundleSeedID;

/** 格式化日期（年月日时分秒） */
+ (NSString *)jp_stringDate;

/** 格式化日期（时分秒） */
+ (NSString *)jp_stringCurrentTime;

/** 拼接服务器图片链接前缀 */
- (NSString *)jp_imageFormatURLWithSize:(CGSize)size;
/** 拼接服务器图片链接前缀（不带剪切） */
- (NSString *)jp_withoutSquareImageFormatURLWithSize:(CGSize)size;

/** 格式化至今的日期 */
- (NSString *)jp_deltaFromCreateDate;

// 获取相应颜色值
- (UIColor *)worksBgColor;

// 粉丝或作品数
- (NSString *)fansOrWorksCountText;

#pragma mark - 文字内容格式判断

/** 判断是否全是空格 */
- (BOOL)jp_isEmpty;

/** 判断是否手机号码 */
- (BOOL)jp_isPhoneNumber;

/** 判断是否身份证号码 */
- (BOOL)jp_isCardID;

/** 判断是否邮箱 */
- (BOOL)jp_isEmail;

/** 判断是否纯数字 */
- (BOOL)jp_isNumber;

/** 判断密码格式（下划线、字母、数字组成） */
- (BOOL)jp_isPassword;

/** 判断昵称格式（汉字、数字、字母、下划线组成） */
- (BOOL)jp_isNickname;

/** 判断是否含有emoji表情 */
- (BOOL)jp_isHasEmoji;

/** 判断是否银行卡 */
- (BOOL)jp_isBankCard;

/** 移除评论中不能识别的字符 */
- (NSString *)removeCannotIdentifiedCharacters;

/** 判断是否含有表情 */
- (BOOL)jp_isHasExpression;

- (void)hexString2RGB:(unsigned int *)r g:(unsigned int *)g b:(unsigned int *)b;
@end
