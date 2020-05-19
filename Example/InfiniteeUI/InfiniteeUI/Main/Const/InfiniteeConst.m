//
//  Infinitee.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/17.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#pragma mark - 常量

NSString *const InfiniteeDownloadTitle = @"下载APP";
NSString *const InfiniteeShareAppName = @"【一创定制】";
NSString *const InfiniteeShareContent = @"1件起订，素材丰富，48小时内发货，支持T恤卫衣、抱枕帆布袋等定制。微信客服：infini_01";

/** 保存的app版本 */
NSString *const InfiniteeVersionKey = @"InfiniteeVersionKey";

/** 没有商品的提示 */
NSString *const ShopCarNoGoodsText = @"😑购物车空空如也~";

CGFloat const iPhone4Width = 320.0;
CGFloat const iPhone4Height = 480.0;

CGFloat const iPhone5Width = 320.0;
CGFloat const iPhone5Height = 568.0;

CGFloat const iPhone6Width = 375.0;
CGFloat const iPhone6Height = 667.0;

CGFloat const iPhone6PlusWidth = 414.0;
CGFloat const iPhone6PlusHeight = 736.0;

CGFloat const RequestAgainDelay = 5.0;

NSString *const InfiniteeFontName = @"infinitee";
NSString *const ShapeFontName = @"shape";
NSString *const ProductFontName = @"infinitem";
NSString *const DesignSpaceIconFontName = @"icomoon";

NSString *const DesignPictureFileName = @"DesignPicture";
NSString *const DesignShapeTTFFileName = @"DesignShapeTTF";
NSString *const DesignShapeTXTFileName = @"DesignShapeTXT";
NSString *const DesignTextTTFFileName = @"DesignTextTTF";

/** 首页 --- View之间的边距 */
CGFloat const ViewMargin = 10.0;

/** 首页 --- Cell之间的边距 */
CGFloat const CellMargin = 5.0;

/** 发现 --- 查看更多label的左右间距 */
CGFloat const LookMoreMargin = 30.0;

/** 发现&商店 --- 轮播视图基本高度 */
CGFloat const RecCarouselViewHeight = 150.0;

/** 发现 --- 定制选项视图基本高度 */
CGFloat const CustomizedViewHeight = 76.0;

/** 发现 --- 新手指南视图基本高度 */
CGFloat const BeginGuideViewHeight = 247.0;

/** 发现 --- 活动推荐视图基本高度 */
CGFloat const RecomActivityViewHeight = 100.0;

/** 普通Cell基本高度 */
CGFloat const NormalCellHeight = 221.0;

/** 活动Cell基本高度 */
CGFloat const ActivityCellHeight = 74.0;

/** 商店 --- 推荐商品行数 */
NSInteger const GoodShopsRowCount = 3;

/** 商店 --- 选择款式视图基本高度 */
CGFloat const StyleViewHeight = 134.0;

/** 商店 --- 选择款式视图展开高度 */
CGFloat const StyleViewShowHeight = 225.0;

/** 商店 --- 商品精选视图基本高度 */
CGFloat const GoodShopsViewHeight = 699.0;

/** 商店 --- 优秀用户视图基本高度 */
CGFloat const ExcellentUserViewHeight = 206;

/** 个人 --- 每个分类控制器的顶部间距 */
CGFloat const UserInfoChildVCTopMargin = 35.0;


/** 小菜单宽度 */
CGFloat const SmallMenuViewWidth = 106.0;
/** 小菜单的选项高度 */
CGFloat const SmallMenuItemHeight = 36.0;

/** 上传图片最大像素 */
CGFloat const PictureMaxPixel = 1500.0;

#pragma mark - 通知

/** 点击广告通知 */
NSString *const AdvertisementDidClick = @"AdvertisementDidClick";

/** 发现页面 --- 跳转到晒单专区 */
NSString *const DiscoverJumpToSunOrderArea = @"DiscoverJumpToSunOrderArea";

/** 发现页面刷新请求发起通知 */
NSString *const DiscoverRequestDataStart = @"DiscoverRequestDataStart";
/** 发现页面刷新请求结束通知 */
NSString *const DiscoverRequestDataDone = @"DiscoverRequestDataDone";
/** 发现页面子视图刷新布局通知 */
NSString *const DiscoverSubviewUpdateLayout = @"DiscoverSubviewUpdateLayout";

/** 商店页面刷新请求发起通知 */
NSString *const ShopRequestDataStart = @"ShopRequestDataStart";
/** 商店页面刷新请求结束通知 */
NSString *const ShopRequestDataDone = @"ShopRequestDataDone";

/** 商店 --- 款式视图高度刷新通知 */
NSString *const UpdateShopStyleViewHeight = @"UpdateShopStyleViewHeight";

/** 登录通知 */
NSString *const UserHasLogin = @"UserHasLogin";
/** 登出通知 */
NSString *const UserHasLogout = @"UserHasLogout";

/** 作品的点赞通知 */
NSString *const WorksZan = @"WorksZan";
/** 作品的收藏通知 */
NSString *const WorksCollection = @"WorksCollection";

/** 刷新购物车数据通知 */
NSString *const UpdateShopCarData = @"UpdateShopCarData";
/** 购物车数据刷新成功通知 */
NSString *const ShopCartGoodsHasUpdateSuccess = @"ShopCartGoodsHasUpdateSuccess";

/** 关注\取关好友通知 */
NSString *const AddOrDelAttentionFriend = @"AddOrDelAttentionFriend";

/** 刷新最新评论通知 */
NSString *const UpdateNewestComment = @"UpdateNewestComment";

/** 退出补全个人资料页面通知 */
NSString *const DismissUserInfoCompleteVC = @"DismissUserInfoCompleteVC";

/** 登录页面登录成功退出通知 */
NSString *const LoginSuccessBackToUserMainView = @"LoginSuccessBackToUserMainView";

/** 登录弹窗登录成功通知 */
NSString *const PopViewLoginOrRegisteSuccess = @"PopViewLoginOrRegisteSuccess";

/** 保存&编辑页面 --- 发布作品成功通知 */
NSString *const PublishWorksSuccess = @"PublishWorksSuccess";

/** 保存&编辑页面 --- 编辑作品成功通知 */
NSString *const UpdateWorksInfo = @"UpdateWorksInfo";

/** 保存&编辑页面 --- 删除作品成功通知 */
NSString *const DeleteWorksSuccess = @"DeleteWorksSuccess";

/** 保存&编辑页面 --- 添加新款式成功通知 */
NSString *const HasNewGoodsStyle = @"HasNewGoodsStyle";

/** 需要刷新个人资料通知 */
NSString *const UpdateUserAccount = @"UpdateUserAccount";

/** 个人主页 --- 刷新个人头像或背景通知 */
NSString *const UploadIconOrBgPicSuccess = @"UploadIconOrBgPicSuccess";

/** 我的订单 --- 订单状态发生改变的通知 */
NSString *const UserOrderDidChange = @"UserOrderDidChange";

/** 我的订单 --- 晒单请求完成的通知 */
NSString *const SunOrderUploadDone = @"SunOrderUploadDone";

/** 晒单 --- 开始后台晒单的本地通知 */
NSString *const SunOrderLocalNotification = @"SunOrderLocalNotification";

/** 是否有未读消息 */
NSString *const HasNoReadMessageNotification = @"HasNoReadMessageNotification";

NSString *const DidSelectedToPictureListKey = @"DidSelectedToPictureListKey";
NSString *const DidSelectedToPhotoListKey = @"DidSelectedToPhotoListKey";
NSString *const DidSelectedAddShapeKey = @"DidSelectedAddShapeKey";
NSString *const DidSelectedAddMapKey = @"DidSelectedAddMapKey";
NSString *const DidSelectedAddHDMapKey = @"DidSelectedAddHDMapKey";

#pragma mark - 沙盒数据Key

NSString *const NeverPopCustomerIntroduce = @"NeverPopCustomerIntroduce";
NSString *const NeverPopSaleIntroduce = @"NeverPopSaleIntroduce";
NSString *const CommonTags = @"CommonTags";
NSString *const RegisteSuccessUserIDs = @"RegisteSuccessUserIDs";

#pragma mark - JSPathchAppKey

NSString *const JSPathchAppKey = @"bd99241431f65942";

#pragma mark - 网页链接

NSString *const AppIntroduceURLStr = @"http://www.infinitee.cn/help/about/about-infinitee.html";
NSString *const BeginGuideURLStr = @"http://www.infinitee.cn/help/guide/video-tutorial.html";
NSString *const ContactUsURLStr = @"http://www.infinitee.cn/help/contactUs.html";
NSString *const ServiceAgreementURLStr = @"http://www.infinitee.cn/help/userAgreement.html";
NSString *const AccountAuthenticationURLStr = @"http://www.infinitee.cn/help/ac/index.html";
NSString *const CustomerExplainURLStr = @"http://www.infinitee.cn/help/customization-faq.html";
NSString *const SellExplainURLStr = @"http://www.infinitee.cn/help/sales-faq.html";
NSString *const GoodsExplainURLStr = @"http://www.infinitee.cn/help/products/products.html";
NSString *const PremiumExplainURLStr = @"http://www.infinitee.cn/help/commision/commision.html";
NSString *const IncomeExplainURLStr = @"http://www.infinitee.cn/help/commission-faq.html";
NSString *const ReturnPolicyURLStr = @"http://www.infinitee.cn/help/about-exchanged.html";
NSString *const ProductClassificationDetailURLStr = @"http://www.infinitee.cn/help/products/products.html";
