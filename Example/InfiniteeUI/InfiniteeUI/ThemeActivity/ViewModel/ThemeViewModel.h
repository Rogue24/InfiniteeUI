//
//  ThemeViewModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/3/16.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemeViewModel : NSObject
- (instancetype)initWithTheme:(Theme *)theme;
@property (nonatomic, strong) Theme *theme;
@property (nonatomic, strong) NSMutableArray *productions;
@property (nonatomic, assign) BOOL requestDone;
@property (nonatomic, assign) CGFloat offsetX;
@end
