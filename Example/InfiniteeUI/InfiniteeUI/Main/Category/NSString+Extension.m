//
//  NSString+Extension.m
//  Infinitee2.0-Design
//
//  Created by Jill on 16/9/27.
//  Copyright © 2016年 陈珏洁. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSDate+JPExtension.h"
#import <sys/utsname.h>
#import "RegexKitLite.h" // 使用第三方库找出特殊文字

@implementation NSString (Extension)

#define JPImagePath @"http://image.infinitee.cn/"

+ (NSString *)deviceString {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"]) return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"]) return @"Simulator";
    
//    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
    
}

+ (NSString *)bundleSeedID {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           kSecClassGenericPassword, kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:kSecAttrAccessGroup];
    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
    CFRelease(result);
    return bundleSeedID;
#pragma clang diagnostic pop
}

+ (NSString *)jp_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SS"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

static NSDateFormatter *dateFormatter;
+ (NSString *)jp_stringCurrentTime {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm:ss:SS"];
    }
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

- (NSString *)jp_withoutSquareImageFormatURLWithSize:(CGSize)size {
    if ([self hasPrefix:@"http"]) {
        return self;
    }
    NSString *url = [JPImagePath stringByAppendingString:self];
    CGFloat scale = [UIScreen mainScreen].scale;
    if (size.width > 0 || size.height > 0) {
        NSInteger width = (NSInteger)size.width * scale;
        NSInteger height = (NSInteger)size.height * scale;
        return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,w_%zd,h_%zd", url, width, height];
    } else {
        return url;
    }
}

- (NSString *)jp_imageFormatURLWithSize:(CGSize)size {
    if ([self hasPrefix:@"http"]) {
        return self;
    }
    
    NSString *imageURLStr = self;
    if ([self containsString:@"production/picture/"] &&
        ![self containsString:@"original"] &&
        ![self containsString:@"basic"]) {
        NSArray *subStrArr = [self componentsSeparatedByString:@"."];
        NSInteger count = subStrArr.count;
        if (count > 1) {
            NSMutableString *imageURLMStr = [NSMutableString string];
            for (NSInteger i = 0; i < count; i++) {
                NSString *subStr = subStrArr[i];
                if (i == count - 2) {
                    [imageURLMStr appendString:[NSString stringWithFormat:@"%@.square.", subStr]];
                } else if (i == count - 1) {
                    [imageURLMStr appendString:subStr];
                } else {
                    [imageURLMStr appendString:[NSString stringWithFormat:@"%@.", subStr]];
                }
            }
            imageURLStr = [imageURLMStr copy];
        }
    }
    
    NSString *url = [JPImagePath stringByAppendingString:imageURLStr];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    if (size.width > 0 || size.height > 0) {
        NSInteger width = (NSInteger)size.width * scale;
        NSInteger height = (NSInteger)size.height * scale;
        return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,w_%zd,h_%zd", url, width, height];
    } else {
        return url;
    }
}

- (NSString *)jp_deltaFromCreateDate {
    
    /**
     * 服务器返回格式：2016-12-19 11:36:57
     */
    
    static NSDateFormatter *publicFormatter_;
    if (!publicFormatter_) {
        publicFormatter_ = [[NSDateFormatter alloc] init];
        publicFormatter_.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formatter = publicFormatter_;
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    // 获取帖子的发布时间NSDate类（String转Date类型）
    NSDate *createDate = [formatter dateFromString:self];
    NSDate *nowDate = [NSDate date];
    
    //日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:nowDate];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:createDate];
    
    // 获取差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //NSDateComponents：能获取时间所有元素（年、月、日、时、分、秒....）的类
    NSDateComponents *components = [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    
    // 判断是否为今年
    if (nowYear == selfYear) {
        if ([calendar isDateInToday:createDate]) {
            // 今天
            if (components.hour >= 1) {
                //今天之内，大于1小时
                return [NSString stringWithFormat:@"%zd小时前", components.hour];
            }else if (components.minute >= 1) {
                //大于1分钟且1小时之内（components.hour==0 && components.minute>=1）
                return [NSString stringWithFormat:@"%zd分钟前", components.minute];
            }else{
                //1分钟之内（components.hour==0 && components.minute==0）
                return @"刚刚";
            }
        } else if ([calendar isDateInYesterday:createDate]) {
            // 昨天
            return @"昨天";
        } else {
            // 比昨天更早之前，今年之内
            if (components.month == 0) {
                return [NSString stringWithFormat:@"%zd天前", components.day];
            } else {
                return [NSString stringWithFormat:@"%zd个月前", components.month];
            }
        }
        
    } else if ((nowYear - selfYear) == 1) {
        if (self.length > 10) {
            NSString *dateStr = [self substringWithRange:NSMakeRange(5, 5)];
            return [NSString stringWithFormat:@"去年%@", dateStr];
        } else {
            return @"去年";
        }
    } else if ((nowYear - selfYear) == 2)  {
        if (self.length > 10) {
            NSString *dateStr = [self substringWithRange:NSMakeRange(5, 5)];
            return [NSString stringWithFormat:@"前年%@", dateStr];
        } else {
            return @"前年";
        }
    } else {
        // 按yyyy-MM-dd HH:mm:ss格式显示
        return self;
    }
}

- (UIColor *)worksBgColor {
//    if (JPPublicDataTool.productionColors.count) {
//        for (NSDictionary *colorDic in JPPublicDataTool.productionColors) {
//            if ([colorDic[@"id"] isEqualToString:self]) {
//                return [UIColor jp_colorWithHexString:colorDic[@"code"]];
//            }
//        }
//    }
    return InfiniteePicBgColor;
}


// 粉丝或作品数
- (NSString *)fansOrWorksCountText {
    NSString *countText = self;
    NSInteger count = self.integerValue / 1000;
    if (count > 0) countText = [NSString stringWithFormat:@"%zdK", count];
    return countText;
}

#pragma mark - 文字内容格式判断

/** 判断是否全是空格 */
- (BOOL)jp_isEmpty {
    if (!self) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

/** 判断是否手机号码 */
- (BOOL)jp_isPhoneNumber {

    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

/** 判断是否身份证号码 */
- (BOOL)jp_isCardID {
    NSString* number = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [numberPre evaluateWithObject:self];
}

/** 判断是否邮箱 */
- (BOOL)jp_isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPred evaluateWithObject:self];
}

/** 判断是否纯数字 */
- (BOOL)jp_isNumber {
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/** 判断密码格式（下划线、字母、数字组成） */
- (BOOL)jp_isPassword {
    NSString *regex = @"[A-Za-z0-9_]{6,40}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/** 判断昵称格式（汉字、数字、字母、下划线组成） */
- (BOOL)jp_isNickname {
    NSString *regex = @"[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/** 判断是否含有emoji表情 */
- (BOOL)jp_isHasEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
        const unichar hs = [substring characterAtIndex:0];
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            if (substring.length > 1) {
                
                const unichar ls = [substring characterAtIndex:1];
                
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    
                    returnValue = YES;
                    
                }
                
            }
            
        } else if (substring.length > 1) {
            
            const unichar ls = [substring characterAtIndex:1];
            
            if (ls == 0x20e3) {
                
                returnValue = YES;
                
            }
            
        } else {
            
            if (0x2100 <= hs && hs <= 0x27ff) {
                
                returnValue = YES;
                
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                
                returnValue = YES;
                
            } else if (0x2934 <= hs && hs <= 0x2935) {
                
                returnValue = YES;
                
            } else if (0x3297 <= hs && hs <= 0x3299) {
                
                returnValue = YES;
                
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                
                returnValue = YES;
                
            }
            
        }
        
    }];
    
    return returnValue;
}


- (BOOL)jp_isBankCard {
    
    if(self.length == 0) {
        return NO;
    }
    
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly = [digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        } else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}


/** 移除评论中不能识别的字符 */
- (NSString *)removeCannotIdentifiedCharacters {
    
    NSMutableString *trimmedString = [NSMutableString string];
    
    // 使用RegexKitLite遍历字符串捕捉所有不符合规则的非特殊字符串（获取所有普通字符串）
    [self enumerateStringsSeparatedByRegex:@"‍" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        [trimmedString appendString:*capturedStrings];
    }];
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"‍"];
//    NSString *trimmedString = [self stringByTrimmingCharactersInSet:set];
    
    return trimmedString;
}

/** 判断是否含有表情 */
- (BOOL)jp_isHasExpression {
    for (NSInteger i = 0; i < self.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (cString == nil) return  YES;
    }
    return NO;
}

- (void)hexString2RGB:(unsigned int *)r g:(unsigned int *)g b:(unsigned int *)b {
    //删除字符串中的空格
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        *r = 0;
        *g = 0;
        *b = 0;
        return;
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        *r = 0;
        *g = 0;
        *b = 0;
        return;
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    [[NSScanner scannerWithString:rString] scanHexInt:r];
    [[NSScanner scannerWithString:gString] scanHexInt:g];
    [[NSScanner scannerWithString:bString] scanHexInt:b];
}

@end


