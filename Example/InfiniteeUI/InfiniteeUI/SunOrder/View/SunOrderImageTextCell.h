//
//  SunOrderImageTextCell.h
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPImageView.h"
#import "SunOrderDetailViewModel.h"
@class InfiniteeTextLayoutParameter;
@class SunOrderInfoView;
@class SunOrderAssistInfoView;
@class SunOrderImageListView;

#define kSOGoodsImageDidClickNotification @"SunOrderGoodsImageDidClick"
#define kSOUserInfoDidClickNotification @"SunOrderUserInfoDidClick"
#define kSOListImageDidClickNotification @"SunOrderListImageDidClick"

@interface SunOrderImageTextCell : UITableViewCell

+ (InfiniteeTextLayoutParameter *)typeTLParameter;
+ (InfiniteeTextLayoutParameter *)goodsNameTLParameter;
+ (InfiniteeTextLayoutParameter *)syleAndSizeTLParameter;
+ (InfiniteeTextLayoutParameter *)buyGoodsDateTLParameter;
+ (InfiniteeTextLayoutParameter *)userNameTLParameter;
+ (InfiniteeTextLayoutParameter *)identityTLParameter;
+ (InfiniteeTextLayoutParameter *)assistInfoTLParameter;
+ (InfiniteeTextLayoutParameter *)describeTLParameter;

+ (CGFloat)minCellHeight;
//- (void)insertAnimate;
- (void)animateDone;
- (void)pushGoodsDetailView;

@property (nonatomic, strong) SunOrderDetailViewModel *detailVM;

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) SunOrderImageListView *userListView;
@property (nonatomic, weak) SunOrderImageListView *governListView;

@end

@interface SunOrderInfoView : UIView
+ (CGFloat)viewHeight;
+ (CGFloat)goodsPictureWH;
+ (CGFloat)userIconWH;
+ (instancetype)sunOrderInfoView;
- (void)updateLayoutWihtDetailVM:(SunOrderDetailViewModel *)detailVM;
- (void)goodsPictureDidClick;
@end

@interface SunOrderAssistInfoView : UIView
+ (CGFloat)viewHeight;
+ (instancetype)sunOrderAssistInfoViewWithIsUser:(BOOL)isUser;
- (void)updateRightPartyLayout:(YYTextLayout *)textLayout;
@end

@interface SunOrderImageListView : UIView
+ (CGFloat)itemWH;
+ (CGFloat)minViewHeight;
+ (instancetype)sunOrderImageListViewWithListCount:(NSInteger)listCount;
@property (nonatomic, copy) NSArray<SunOrderImageModel *> *imageModels;
@property (nonatomic, copy) NSArray<JPImageView *> *picViews;
@end
