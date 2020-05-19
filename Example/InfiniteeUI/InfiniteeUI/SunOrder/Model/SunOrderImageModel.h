//
//  SunOrderImageModel.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/12.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunOrderImageModel : NSObject
@property (nonatomic, copy) NSString *baseURLStr;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) BOOL isAnimating;
// 是否来自产品分类的晒单 
@property (nonatomic, assign) BOOL isFromCategory;
@property (nonatomic, assign) BOOL isUserList;
// tableViewCell的下标
@property (nonatomic, assign) NSInteger tableIndex;
// tableViewCell的listView的下标
@property (nonatomic, assign) NSInteger picListIndex;
// 所有图片（collectionViewCell）的下标
@property (nonatomic, assign) NSInteger allPicIndex;
@end
