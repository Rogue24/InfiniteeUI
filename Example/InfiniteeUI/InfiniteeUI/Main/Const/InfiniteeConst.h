//
//  Infinitee.h
//  Infinitee2.0
//
//  Created by guanning on 16/11/17.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 枚举

typedef NS_ENUM(NSUInteger, UserMessageType) {
    DynamicMessageType,
    MyMessageType,
    SystemMessageType
};

typedef NS_ENUM(NSUInteger, UhpListUpdateAction) {
    UhpListNoAction     = 0,
    UhpListAllReload    = 1 << 0,
    UhpListReload       = 1 << 1,
    UhpListInsert       = 1 << 2,
    UhpListDelete       = 1 << 3,
    UhpListMove         = 1 << 4
};

typedef NS_ENUM(NSUInteger, JPUserCertifyType) {
    NotCertifyType,
    PersonalCertifyType,
    EnterpriseCertifyType,
};

typedef NS_ENUM(NSUInteger, DesignPictureType) {
    DPShapeType,
    DPMapType,
    DPHDMapType
};

typedef NS_ENUM(NSUInteger, OrderPayType) {
    AlipayType = 0,
    WechatPayType,
    UnionPayType,
    NotToPayType
};

typedef NS_ENUM(NSUInteger, OrderStateType) {
    NotStageType,
    FirstStageType = 1,
    SecondStageType,
    ThirdStageType,
    FourthStageType
};

typedef NS_ENUM(NSUInteger, WDOperationType) {
    WDJustDisplayType = 0,
    WDAddAcctountType,
    WDEdidAcctountType
};

#pragma mark - 常量

UIKIT_EXTERN NSString *const InfiniteeImagePath;

UIKIT_EXTERN NSString *const InfiniteeDownloadTitle;
UIKIT_EXTERN NSString *const InfiniteeShareAppName;
UIKIT_EXTERN NSString *const InfiniteeShareContent;

/** 保存的app版本 */
UIKIT_EXTERN NSString *const InfiniteeVersionKey;

/** 没有商品的提示 */
UIKIT_EXTERN NSString *const ShopCarNoGoodsText;

UIKIT_EXTERN CGFloat const iPhone4Width;
UIKIT_EXTERN CGFloat const iPhone4Height;

UIKIT_EXTERN CGFloat const iPhone5Width;
UIKIT_EXTERN CGFloat const iPhone5Height;

UIKIT_EXTERN CGFloat const iPhone6Width;
UIKIT_EXTERN CGFloat const iPhone6Height;

UIKIT_EXTERN CGFloat const iPhone6PlusWidth;
UIKIT_EXTERN CGFloat const iPhone6PlusHeight;

UIKIT_EXTERN CGFloat const RequestAgainDelay;

UIKIT_EXTERN NSString *const InfiniteeFontName;
UIKIT_EXTERN NSString *const ShapeFontName;
UIKIT_EXTERN NSString *const ProductFontName;
UIKIT_EXTERN NSString *const DesignSpaceIconFontName;

UIKIT_EXTERN NSString *const DesignPictureFileName;
UIKIT_EXTERN NSString *const DesignShapeTTFFileName;
UIKIT_EXTERN NSString *const DesignShapeTXTFileName;
UIKIT_EXTERN NSString *const DesignTextTTFFileName;

/** 首页 --- View之间的边距 */
UIKIT_EXTERN CGFloat const ViewMargin;

/** 首页 --- Cell之间的边距 */
UIKIT_EXTERN CGFloat const CellMargin;

/** 发现 --- 查看更多label的左右间距 */
UIKIT_EXTERN CGFloat const LookMoreMargin;

/** 发现&商店 --- 轮播视图基本高度 */
UIKIT_EXTERN CGFloat const RecCarouselViewHeight;

/** 发现 --- 定制选项视图基本高度 */
UIKIT_EXTERN CGFloat const CustomizedViewHeight;

/** 发现 --- 新手指南视图基本高度 */
UIKIT_EXTERN CGFloat const BeginGuideViewHeight;

/** 发现 --- 活动推荐视图基本高度 */
UIKIT_EXTERN CGFloat const RecomActivityViewHeight;



/** 普通Cell基本高度 */
UIKIT_EXTERN CGFloat const NormalCellHeight;



/** 活动Cell基本高度 */
UIKIT_EXTERN CGFloat const ActivityCellHeight;



/** 商店 --- 推荐商品行数 */
UIKIT_EXTERN NSInteger const GoodShopsRowCount;

/** 商店 --- 选择款式视图基本高度 */
UIKIT_EXTERN CGFloat const StyleViewHeight;

/** 商店 --- 选择款式视图展开高度 */
UIKIT_EXTERN CGFloat const StyleViewShowHeight;

/** 商店 --- 商品精选视图基本高度 */
UIKIT_EXTERN CGFloat const GoodShopsViewHeight;

/** 商店 --- 优秀用户视图基本高度 */
UIKIT_EXTERN CGFloat const ExcellentUserViewHeight;




/** 个人 --- 每个分类控制器的顶部间距 */
UIKIT_EXTERN CGFloat const UserInfoChildVCTopMargin;




/** 小菜单宽度 */
UIKIT_EXTERN CGFloat const SmallMenuViewWidth;
/** 小菜单的选项高度 */
UIKIT_EXTERN CGFloat const SmallMenuItemHeight;


/** 上传图片最大像素 */
UIKIT_EXTERN CGFloat const PictureMaxPixel;

#pragma mark - 通知

/** 点击广告通知 */
UIKIT_EXTERN NSString *const AdvertisementDidClick;

/** 发现页面 --- 跳转到晒单专区 */
UIKIT_EXTERN NSString *const DiscoverJumpToSunOrderArea;

/** 发现页面 --- 刷新请求发起通知 */
UIKIT_EXTERN NSString *const DiscoverRequestDataStart;
/** 发现页面 --- 刷新请求结束通知 */
UIKIT_EXTERN NSString *const DiscoverRequestDataDone;
/** 发现页面 --- 子视图刷新布局通知 */
UIKIT_EXTERN NSString *const DiscoverSubviewUpdateLayout;

/** 商店页面 --- 刷新请求发起通知 */
UIKIT_EXTERN NSString *const ShopRequestDataStart;
/** 商店页面 --- 刷新请求结束通知 */
UIKIT_EXTERN NSString *const ShopRequestDataDone;

/** 商店 --- 款式视图高度刷新通知 */
UIKIT_EXTERN NSString *const UpdateShopStyleViewHeight;

/** 登录通知 */
UIKIT_EXTERN NSString *const UserHasLogin;
/** 登出通知 */
UIKIT_EXTERN NSString *const UserHasLogout;

/** 作品的点赞通知 */
UIKIT_EXTERN NSString *const WorksZan;
/** 作品的收藏通知 */
UIKIT_EXTERN NSString *const WorksCollection;

/** 刷新购物车数据通知 */
UIKIT_EXTERN NSString *const UpdateShopCarData;
/** 购物车数据刷新成功通知 */
UIKIT_EXTERN NSString *const ShopCartGoodsHasUpdateSuccess;

/** 关注\取关好友通知 */
UIKIT_EXTERN NSString *const AddOrDelAttentionFriend;

/** 刷新最新评论通知 */
UIKIT_EXTERN NSString *const UpdateNewestComment;

/** 退出补全个人资料页面通知 */
UIKIT_EXTERN NSString *const DismissUserInfoCompleteVC;

/** 登录页面登录成功退出通知 */
UIKIT_EXTERN NSString *const LoginSuccessBackToUserMainView;

/** 登录弹窗登录成功通知 */
UIKIT_EXTERN NSString *const PopViewLoginOrRegisteSuccess;

/** 保存&编辑页面 --- 发布作品成功通知 */
UIKIT_EXTERN NSString *const PublishWorksSuccess;

/** 保存&编辑页面 --- 编辑作品成功通知 */
UIKIT_EXTERN NSString *const UpdateWorksInfo;

/** 保存&编辑页面 --- 保存（发布）新作品成功 */
UIKIT_EXTERN NSString *const HasNewGoodsStyle;

/** 保存&编辑页面 --- 删除作品成功通知 */
UIKIT_EXTERN NSString *const DeleteWorksSuccess;

/** 个人主页 --- 需要刷新个人资料通知 */
UIKIT_EXTERN NSString *const UpdateUserAccount;

/** 个人主页 --- 刷新个人头像或背景通知 */
UIKIT_EXTERN NSString *const UploadIconOrBgPicSuccess;

/** 我的订单 --- 订单状态发生改变的通知 */
UIKIT_EXTERN NSString *const UserOrderDidChange;

/** 我的订单 --- 晒单请求完成的通知 */
UIKIT_EXTERN NSString *const SunOrderUploadDone;

/** 晒单 --- 开始后台晒单的本地通知 */
UIKIT_EXTERN NSString *const SunOrderLocalNotification;

/** 是否有未读消息 */
UIKIT_EXTERN NSString *const HasNoReadMessageNotification;

UIKIT_EXTERN NSString *const DidSelectedToPictureListKey;
UIKIT_EXTERN NSString *const DidSelectedToPhotoListKey;
UIKIT_EXTERN NSString *const DidSelectedAddShapeKey;
UIKIT_EXTERN NSString *const DidSelectedAddMapKey;
UIKIT_EXTERN NSString *const DidSelectedAddHDMapKey;

#pragma mark - 沙盒数据Key

UIKIT_EXTERN NSString *const NeverPopCustomerIntroduce;
UIKIT_EXTERN NSString *const NeverPopSaleIntroduce;
UIKIT_EXTERN NSString *const CommonTags;
UIKIT_EXTERN NSString *const RegisteSuccessUserIDs;

#pragma mark - JSPathchAppKey

UIKIT_EXTERN NSString *const JSPathchAppKey;

#pragma mark - 网页链接

/** APP介绍 */
UIKIT_EXTERN NSString *const AppIntroduceURLStr;
/** 新手教程 */
UIKIT_EXTERN NSString *const BeginGuideURLStr;
/** 联系我们 */
UIKIT_EXTERN NSString *const ContactUsURLStr;
/** 服务协议 */
UIKIT_EXTERN NSString *const ServiceAgreementURLStr;
/** 账号认证 */
UIKIT_EXTERN NSString *const AccountAuthenticationURLStr;
/** 作品编辑\保存 --- 个人定制说明 */
UIKIT_EXTERN NSString *const CustomerExplainURLStr;
/** 作品编辑\保存 --- 售卖作品说明 */
UIKIT_EXTERN NSString *const SellExplainURLStr;
/** 作品编辑\保存 --- 商品说明 */
UIKIT_EXTERN NSString *const GoodsExplainURLStr;
/** 作品编辑\保存 --- 溢价说明 */
UIKIT_EXTERN NSString *const PremiumExplainURLStr;
/** 我的收益 --- 收益说明 */
UIKIT_EXTERN NSString *const IncomeExplainURLStr;
/** 退换货政策 */
UIKIT_EXTERN NSString *const ReturnPolicyURLStr;
/** 产品分类总详情 */
UIKIT_EXTERN NSString *const ProductClassificationDetailURLStr;

#pragma mark - 运行时变量

@interface InfiniteeConst : NSObject

+ (CGSize)themeCellSize;

+ (CGFloat)fontSize10MaxWidth;
+ (CGFloat)fontSize8MaxWidth;
+ (CGFloat)fontSize7MaxWidth;

@end
