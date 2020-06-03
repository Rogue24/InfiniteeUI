//
//  JPPhotoViewController.h
//  Infinitee2.0
//
//  Created by 周健平 on 2018/2/23.
//  Copyright © 2018年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPhotoViewModel.h"

@interface JPPhotoViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title maxSelectedCount:(NSInteger)maxCount confirmHandle:(void(^)(NSArray<JPPhotoViewModel *> *selectedPhotoVMs))confirmHandle;

+ (instancetype)replaceIconOrBackgroundPicWithIsReplaceIcon:(BOOL)isReplaceIcon title:(NSString *)title replaceHandle:(void(^)(BOOL isReplaceIcon, UIImage *replaceImage))replaceHandle;

+ (instancetype)selectedDesignPictureWithTitle:(NSString *)title procesDoneHandle:(void(^)(UIImage *procesImage))procesDoneHandle;

@end
