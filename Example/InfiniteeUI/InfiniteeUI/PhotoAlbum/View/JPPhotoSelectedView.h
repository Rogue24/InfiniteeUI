//
//  JPPhotoSelectedView.h
//  Infinitee2.0
//
//  Created by 周健平 on 2018/8/12.
//  Copyright © 2018 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPPhotoSelectedView : UIView
+ (JPPhotoSelectedView *)photoSelectedViewWithConfirmBlock:(void(^)(void))confirmBlock cancelBlock:(void(^)(void))cancelBlock;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL isShowed;
@end
