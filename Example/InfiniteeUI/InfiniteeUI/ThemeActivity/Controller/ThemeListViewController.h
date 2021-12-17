//
//  ThemeListViewController.h
//  Infinitee2.0
//
//  Created by guanning on 2017/6/5.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

@interface ThemeListViewController : UICollectionViewController <UINavigationControllerDelegate>
+ (instancetype)themeListVCWithThemes:(NSArray<Theme *> *)themes;
@end
