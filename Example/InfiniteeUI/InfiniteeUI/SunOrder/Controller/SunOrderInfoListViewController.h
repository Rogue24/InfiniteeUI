//
//  SunOrderInfoListViewController.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/7.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSunOrderDataTool.h"

@interface SunOrderInfoListViewController : UIViewController
- (instancetype)initWithSocVM:(SunOrderCategoryViewModel *)socVM bottomSoViewH:(CGFloat)bottomSoViewH beginDraggingBlock:(void (^)(BOOL isDragUp))beginDraggingBlock viewSize:(CGSize)viewSize;
@property (nonatomic, strong) JPSunOrderDataTool *dataTool;
@property (nonatomic, strong) SunOrderCategoryViewModel *socVM;
@property (nonatomic, weak) NSURLSessionTask *currTask;

@property (nonatomic, assign) BOOL isImageText;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, copy) void (^beginDraggingBlock)(BOOL isDragUp);
@property (nonatomic, copy) void (^switchListTypeFinishBlock)(void);

- (void)cancelAllRequestHandle;
@end
