//
//  SunOrderImageTextCell.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderImageTextCell.h"
#import "InfiniteeTextLayoutParameter.h"

#define kFont14Size (14 * JPScale)
#define kFont10Size (10 * JPScale)

#pragma mark - 主体

@interface SunOrderImageTextCell ()
@property (nonatomic, weak) CAShapeLayer *bgLayer;
@property (nonatomic, weak) SunOrderInfoView *infoView;
@property (nonatomic, weak) SunOrderAssistInfoView *userAssistInfoView;
@property (nonatomic, weak) YYLabel *describeLabel;
@property (nonatomic, weak) SunOrderAssistInfoView *governAssistInfoView;
@end

@implementation SunOrderImageTextCell

static InfiniteeTextLayoutParameter *typeTLParameter_;
static InfiniteeTextLayoutParameter *goodsNameTLParameter_;
static InfiniteeTextLayoutParameter *syleAndSizeTLParameter_;
static InfiniteeTextLayoutParameter *buyGoodsDateTLParameter_;
static InfiniteeTextLayoutParameter *userNameTLParameter_;
static InfiniteeTextLayoutParameter *identityTLParameter_;
static InfiniteeTextLayoutParameter *assistInfoTLParameter_;
static InfiniteeTextLayoutParameter *describeTLParameter_;

+ (InfiniteeTextLayoutParameter *)typeTLParameter {
    if (!typeTLParameter_) {
        typeTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = [UIColor whiteColor];
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return typeTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)goodsNameTLParameter {
    if (!goodsNameTLParameter_) {
        goodsNameTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont14Size];
            tLParameter.textColor = InfiniteeBlack;
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return goodsNameTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)syleAndSizeTLParameter {
    if (!syleAndSizeTLParameter_) {
        syleAndSizeTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = JPRGBColor(155, 155, 155);
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return syleAndSizeTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)buyGoodsDateTLParameter {
    if (!buyGoodsDateTLParameter_) {
        buyGoodsDateTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = JPRGBColor(227, 140, 125);
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return buyGoodsDateTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)userNameTLParameter {
    if (!userNameTLParameter_) {
        userNameTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = JPRGBColor(155, 155, 155);
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return userNameTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)identityTLParameter {
    if (!identityTLParameter_) {
        identityTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = JPRGBColor(155, 155, 155);
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return identityTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)assistInfoTLParameter {
    if (!assistInfoTLParameter_) {
        assistInfoTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont10Size];
            tLParameter.textColor = InfiniteeGray;
            tLParameter.maxWidth = JPPortraitScreenWidth;
            tLParameter.row = 1;
            tLParameter;
        });
    }
    return assistInfoTLParameter_;
}

+ (InfiniteeTextLayoutParameter *)describeTLParameter {
    if (!describeTLParameter_) {
        describeTLParameter_ = ({
            InfiniteeTextLayoutParameter *tLParameter = [InfiniteeTextLayoutParameter new];
            tLParameter.font = [UIFont systemFontOfSize:kFont14Size];
            tLParameter.textColor = JPRGBColor(155, 155, 155);
            tLParameter.lineSpacing = 3;
            tLParameter.maxWidth = JPPortraitScreenWidth - 4 * ViewMargin;
            tLParameter;
        });
    }
    return describeTLParameter_;
}

+ (CGFloat)minCellHeight {
    CGFloat infoViewH = [SunOrderInfoView viewHeight];
    CGFloat assistViewH = [SunOrderAssistInfoView viewHeight];
    CGFloat minCellHeight = infoViewH + assistViewH + 0 + 0 + 5 + assistViewH + 0 + 5 + 10;
    return minCellHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.jp_x = ViewMargin;
        bgView.jp_y = 0.5;
        bgView.jp_width = JPPortraitScreenWidth - 2 * ViewMargin;
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        
        SunOrderInfoView *infoView = [SunOrderInfoView sunOrderInfoView];
        [bgView addSubview:infoView];
        self.infoView = infoView;
        
        SunOrderAssistInfoView *userAssistInfoView = [SunOrderAssistInfoView sunOrderAssistInfoViewWithIsUser:YES];
        userAssistInfoView.jp_y = infoView.jp_height;
        [bgView addSubview:userAssistInfoView];
        self.userAssistInfoView = userAssistInfoView;
        
        // 设置ignoreCommonProperties属性之后，文本显示的属性诸如text, font, textColor, attributedText等将不可用，要使用textLayout来设置
        
        YYLabel *describeLabel = [YYLabel new];
//        describeLabel.backgroundColor = [UIColor yellowColor];
        describeLabel.userInteractionEnabled = NO;
        describeLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        describeLabel.numberOfLines = 0;
        describeLabel.jp_x = ViewMargin;
        describeLabel.jp_y = userAssistInfoView.jp_maxY;
        describeLabel.jp_width = JPPortraitScreenWidth - 40;
        describeLabel.displaysAsynchronously = YES;
        describeLabel.ignoreCommonProperties = YES;
        describeLabel.fadeOnAsynchronouslyDisplay = NO;
        describeLabel.fadeOnHighlight = NO;
        [bgView addSubview:describeLabel];
        self.describeLabel = describeLabel;
        
        SunOrderImageListView *userListView = [SunOrderImageListView sunOrderImageListViewWithListCount:5];
        [bgView addSubview:userListView];
        self.userListView = userListView;
        
        SunOrderAssistInfoView *governAssistInfoView = [SunOrderAssistInfoView sunOrderAssistInfoViewWithIsUser:NO];
        [bgView addSubview:governAssistInfoView];
        self.governAssistInfoView = governAssistInfoView;
        
        SunOrderImageListView *governListView = [SunOrderImageListView sunOrderImageListViewWithListCount:10];
        [bgView addSubview:governListView];
        self.governListView = governListView;
        
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        bgLayer.lineWidth = JPSeparateLineThick;
        bgLayer.strokeColor = JPRGBAColor(227, 140, 125, 0.5).CGColor;
        bgLayer.fillColor = [UIColor clearColor].CGColor;
        [bgView.layer addSublayer:bgLayer];
        self.bgLayer = bgLayer;
    }
    return self;
}

- (void)dealloc {
    
}

- (void)setDetailVM:(SunOrderDetailViewModel *)detailVM {
    _detailVM = detailVM;
    
    self.describeLabel.jp_height = detailVM.describeH;
    self.describeLabel.textLayout = detailVM.describeLayout;
    
    [self.infoView updateLayoutWihtDetailVM:detailVM];
    [self.userAssistInfoView updateRightPartyLayout:detailVM.userSoDateLayout];
    [self.governAssistInfoView updateRightPartyLayout:detailVM.governSoDateLayout];
    
    if (!detailVM) {
        self.userInteractionEnabled = NO;
        self.bgLayer.strokeColor = InfiniteeBlueA(0.5).CGColor;
        self.userListView.jp_height = 0;
        self.governListView.jp_height = 0;
        self.userListView.jp_y = self.describeLabel.jp_maxY;
        self.governAssistInfoView.jp_y = self.userListView.jp_maxY + 5;
        self.governListView.jp_y = self.governAssistInfoView.jp_maxY;
        self.bgView.jp_height = self.governListView.jp_maxY + 5;
        self.bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds cornerRadius:2].CGPath;
        return;
    }
    
    self.userInteractionEnabled = YES;
    
    self.bgLayer.strokeColor = detailVM.boardColor.CGColor;
    self.bgView.jp_height = detailVM.cellHeight - ViewMargin - 0.5;
    self.bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds cornerRadius:2].CGPath;
    
    self.userListView.jp_height = detailVM.userImageListHeight;
    self.governListView.jp_height = detailVM.governImageListHeight;
    
    self.userListView.jp_y = self.describeLabel.jp_maxY;
    self.governAssistInfoView.jp_y = self.userListView.jp_maxY + 5;
    self.governListView.jp_y = self.governAssistInfoView.jp_maxY;
    
    self.userListView.imageModels = detailVM.userImageModels;
    self.governListView.imageModels = detailVM.governImageModels;
}

- (void)animateDone {
    NSInteger uCount = self.detailVM.userImageModels.count;
    NSInteger gCount = self.detailVM.governImageModels.count;
    
    for (NSInteger i = 0; i < uCount; i++) {
        UIView *imageView = self.userListView.picViews[i];
        imageView.hidden = NO;
    }
    
    for (NSInteger i = 0; i < gCount; i++) {
        UIView *imageView = self.governListView.picViews[i];
        imageView.hidden = NO;
    }
}

- (void)pushGoodsDetailView {
    [self.infoView goodsPictureDidClick];
}

@end

#pragma mark - 顶部用户信息部分

@interface SunOrderInfoView ()
@property (nonatomic, weak) JPImageView *pictureView;
@property (nonatomic, weak) JPImageView *userIconView;
@property (nonatomic, weak) UIView *typeView;
@property (nonatomic, weak) YYLabel *typeLabel;
@property (nonatomic, weak) YYLabel *nameLabel;
@property (nonatomic, weak) YYLabel *styleLabel;
@property (nonatomic, weak) YYLabel *createDateLabel;
@property (nonatomic, weak) YYLabel *userNameLabel;
@property (nonatomic, weak) YYLabel *identityLabel;
@property (nonatomic, weak) CALayer *line;
@property (nonatomic, weak) UIView *followUserControl;
@property (nonatomic, weak) UIView *userControl;
@property (nonatomic, weak) SunOrderDetailViewModel *sodVM;
@end

@implementation SunOrderInfoView

+ (CGFloat)viewHeight {
    return self.goodsPictureWH +  2 * ViewMargin;
}

static CGFloat goodsPictureWH_ = 0;
+ (CGFloat)goodsPictureWH {
    if (goodsPictureWH_ == 0) {
        goodsPictureWH_ = 99 * JPScale;
    }
    return goodsPictureWH_;
}

static CGFloat userIconWH_ = 0;
+ (CGFloat)userIconWH {
    if (userIconWH_ == 0) {
        userIconWH_ = 31 * JPScale;
    }
    return userIconWH_;
}

+ (instancetype)sunOrderInfoView {
    SunOrderInfoView *soiView = [[self alloc] init];
    soiView.jp_width = JPPortraitScreenWidth - 2 * ViewMargin;
    soiView.jp_height = self.viewHeight;
    [soiView adjustSubviewsLayout];
    return soiView;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 2;
        
        JPImageView *pictureView = [[JPImageView alloc] init];
        pictureView.backgroundColor = InfiniteePicBgColor;
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        pictureView.image = [UIImage defaultWorksPicture];
        [self addSubview:pictureView];
        self.pictureView = pictureView;
        
        JPImageView *userIconView = [[JPImageView alloc] init];
        userIconView.contentMode = UIViewContentModeScaleAspectFill;
        userIconView.image = [UIImage defaultIcon];
        [self addSubview:userIconView];
        self.userIconView = userIconView;
        
        YYLabel *nameLabel = [YYLabel new];
        nameLabel.userInteractionEnabled = NO;
        nameLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        nameLabel.displaysAsynchronously = YES;
        nameLabel.ignoreCommonProperties = YES;
        nameLabel.fadeOnHighlight = NO;
        nameLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        YYLabel *styleLabel = [YYLabel new];
        styleLabel.userInteractionEnabled = NO;
        styleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        styleLabel.displaysAsynchronously = YES;
        styleLabel.ignoreCommonProperties = YES;
        styleLabel.fadeOnHighlight = NO;
        styleLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:styleLabel];
        self.styleLabel = styleLabel;
        
        YYLabel *createDateLabel = [YYLabel new];
        createDateLabel.userInteractionEnabled = NO;
        createDateLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        createDateLabel.displaysAsynchronously = YES;
        createDateLabel.ignoreCommonProperties = YES;
        createDateLabel.fadeOnHighlight = NO;
        createDateLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:createDateLabel];
        self.createDateLabel = createDateLabel;
        
        UIView *followUserControl = [UIView new];
        [followUserControl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOtherUserHomePage)]];
        [self addSubview:followUserControl];
        self.followUserControl = followUserControl;
        
        YYLabel *userNameLabel = [YYLabel new];
        userNameLabel.userInteractionEnabled = NO;
        userNameLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        userNameLabel.displaysAsynchronously = YES;
        userNameLabel.ignoreCommonProperties = YES;
        userNameLabel.fadeOnHighlight = NO;
        userNameLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:userNameLabel];
        self.userNameLabel = userNameLabel;
        
        YYLabel *identityLabel = [YYLabel new];
        identityLabel.userInteractionEnabled = NO;
        identityLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        identityLabel.displaysAsynchronously = YES;
        identityLabel.ignoreCommonProperties = YES;
        identityLabel.fadeOnHighlight = NO;
        identityLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:identityLabel];
        self.identityLabel = identityLabel;
        
        UIView *typeView = [[UIView alloc] init];
        typeView.backgroundColor = JPRGBColor(227, 140, 125);
        [self addSubview:typeView];
        self.typeView = typeView;
        
        YYLabel *typeLabel = [YYLabel new];
        typeLabel.userInteractionEnabled = NO;
        typeLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        typeLabel.displaysAsynchronously = YES;
        typeLabel.ignoreCommonProperties = YES;
        typeLabel.fadeOnHighlight = NO;
        typeLabel.fadeOnAsynchronouslyDisplay = NO;
        [typeView addSubview:typeLabel];
        self.typeLabel = typeLabel;
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = InfiniteeGrayA(0.3).CGColor;
        [self.layer addSublayer:line];
        self.line = line;
        
        [pictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsPictureDidClick)]];
        
        UIView *userControl = [UIView new];
        [userControl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoDidClick)]];
        [self addSubview:userControl];
        self.userControl = userControl;
    }
    return self;
}

- (void)adjustSubviewsLayout {
    CGFloat scale = JPScale;
    CGFloat font14Size = 14 * scale;
    CGFloat font10Size = 10 * scale;
    
    CGFloat sw = self.jp_width;
    CGFloat sh = self.jp_height;
    
    CGFloat h = sh - 2 * ViewMargin;
    CGFloat w = h;
    CGFloat x = ViewMargin;
    CGFloat y = ViewMargin;
    self.pictureView.frame = CGRectMake(x, y, w, h);
    self.pictureView.clipsToBounds = YES;
    self.pictureView.layer.cornerRadius = 2;
    self.pictureView.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
    self.pictureView.layer.borderWidth = JPSeparateLineThick;
    
    w = SunOrderInfoView.userIconWH;
    h = w;
    x = self.pictureView.jp_maxX + 15;
    y = sh - 15 - h;
    self.userIconView.frame = CGRectMake(x, y, w, h);
    self.userIconView.clipsToBounds = YES;
    self.userIconView.layer.cornerRadius = h * 0.5;
    self.userIconView.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
    self.userIconView.layer.borderWidth = JPSeparateLineThick;
    
    w = sw - self.pictureView.jp_maxX;
    h = JPSeparateLineThick;
    x = self.pictureView.jp_maxX;
    y = self.userIconView.jp_y - 5;
    self.line.frame = CGRectMake(x, y, w, h);
    
    w = 64 * scale;
    h = w;
    x = sw - w * 0.5;
    y = -h * 0.5;
    self.typeView.frame = CGRectMake(x, y, w, h);
    
    CGSize size = [JPSolveTool oneLineTextFrameWithText:@"贩售" font:[UIFont systemFontOfSize:font10Size]].size;
    x = (w - size.width) * 0.5;
    y = h - font10Size - 5;
    self.typeLabel.frame = CGRectMake(x, y, size.width, font10Size);
    self.typeView.transform = CGAffineTransformMakeRotation(M_PI_2 * 0.5);
    
    x = self.pictureView.jp_maxX + 15;
    y = 15;
    w = self.jp_width - x - ViewMargin;
    h = font14Size;
    self.nameLabel.frame = CGRectMake(x, y, w, h);
    
    h = font10Size;
    y = y + self.nameLabel.jp_height + 5;
    self.styleLabel.frame = CGRectMake(x, y, w, h);
    
    y = y + self.styleLabel.jp_height + 5;
    self.createDateLabel.frame = CGRectMake(x, y, w, h);
    
    x = self.userIconView.jp_maxX + 10;
    y = self.userIconView.jp_y + 3;
    w = self.jp_width - x - ViewMargin;
    self.userNameLabel.frame = CGRectMake(x, y, w, h);
    
    y = self.userIconView.jp_maxY - h - 3;
    self.identityLabel.frame = CGRectMake(x, y, w, h);
    
    x = self.userIconView.jp_x;
    y = self.userIconView.jp_y;
    w = self.userNameLabel.jp_width * 0.5;
    h = self.userIconView.jp_height;
    self.userControl.frame = CGRectMake(x, y, w, h);
}

- (void)updateLayoutWihtDetailVM:(SunOrderDetailViewModel *)detailVM {
    self.sodVM = detailVM;
    
    self.nameLabel.textLayout = detailVM.goodsNameLayout;
    self.styleLabel.textLayout = detailVM.styleAndSizeLayout;
    self.createDateLabel.textLayout = detailVM.buyGoodsDateLayout;
    self.userNameLabel.textLayout = detailVM.userNameLayout;
    self.identityLabel.textLayout = detailVM.identityLayout;
    
    self.followUserControl.frame = CGRectMake(self.createDateLabel.jp_x, self.createDateLabel.jp_y, detailVM.buyGoodsDateLayout.textBoundingSize.width, detailVM.buyGoodsDateLayout.textBoundingSize.height);
    
    if (!detailVM) {
        self.typeView.hidden = YES;
        self.pictureView.image = [UIImage defaultWorksPicture];
        self.userIconView.image = [UIImage defaultIcon];
        return;
    }
    
    if (detailVM.typeLayout) {
        self.typeView.hidden = NO;
        self.typeView.backgroundColor = detailVM.typeColor;
        self.typeLabel.textLayout = detailVM.typeLayout;
    } else {
        self.typeView.hidden = YES;
    }
    
    if (detailVM.soModel.proIsRelease) {
        [self.pictureView setImageWithURL:detailVM.goodsPictureURL placeholder:[UIImage defaultWorksPicture]];
    } else {
        self.pictureView.image = [UIImage imageNamed:@"invisible_item_img"];
    }
    
    [self.userIconView setImageWithURL:detailVM.userIconURL placeholder:[UIImage defaultIcon]];
}

- (void)goodsPictureDidClick {
    if (!self.sodVM) return;
    
    SunOrderModel *soModel = self.sodVM.soModel;
    if (!soModel.proIsRelease) {
        [JPProgressHUD showInfoWithStatus:@"抱歉，作者未公开此商品" userInteractionEnabled:YES];
        return;
    }
    
    [JPProgressHUD showSuccessWithStatus:@"商品详情页暂未添加，敬请期待" userInteractionEnabled:YES];
    
//    CreativeWorks *works = [[CreativeWorks alloc] init];
//    works.cusId = soModel.proCusId;
//    works.cusNickname = soModel.proCusName;
//    works.ID = soModel.proId;
//    works.name = soModel.proName;
//    works.picture = soModel.proPicture;
//    works.relateIds = soModel.proRelateIds;
//
//    CGRect frame = [self.pictureView convertRect:self.pictureView.bounds toView:self.window];
//
//    UIImage *placeholder = self.pictureView.image ? self.pictureView.image : [UIImage defaultWorksPicture];
//
//    // self -> bgView -> contentView -> cell -> UITableViewWrapperView -> tableView
//    UIView *superview = self.superview.superview.superview.superview;
//    if ([superview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
//        superview = superview.superview;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSOGoodsImageDidClickNotification object:superview userInfo:@{@"works": works, @"goodsPictureFrame": [NSValue valueWithCGRect:frame], @"placeholder": placeholder}];
}

- (void)userInfoDidClick {
    if (!self.sodVM) return;
    
    SunOrderModel *soModel = self.sodVM.soModel;
    if (!soModel.proCusId || soModel.proCusId.length == 0) {
        JPLog(@"用户id空了")
        return;
    }
    
    [JPProgressHUD showSuccessWithStatus:@"用户主页暂未添加，敬请期待" userInteractionEnabled:YES];
    
//    UserAccount *account = [[UserAccount alloc] init];
//    account.useId = soModel.proCusId;
//    account.icon = soModel.proCusIcon;
//    account.nickname = soModel.proCusName;
//
//    // self -> bgView -> contentView -> cell -> UITableViewWrapperView -> tableView
//    UIView *superview = self.superview.superview.superview.superview;
//    if ([superview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
//        superview = superview.superview;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSOUserInfoDidClickNotification object:superview userInfo:@{@"account": account}];
}

- (void)goOtherUserHomePage {
    if (!self.sodVM) return;
    
    SunOrderModel *soModel = self.sodVM.soModel;
    if (!soModel.cusId || soModel.cusId.length == 0) {
        JPLog(@"用户id空了")
        return;
    }
    
    [JPProgressHUD showSuccessWithStatus:@"用户主页暂未添加，敬请期待" userInteractionEnabled:YES];
    
//    UserAccount *account = [[UserAccount alloc] init];
//    account.useId = soModel.cusId;
//    account.icon = soModel.cusIcon;
//    account.nickname = soModel.cusName;
//    
//    // self -> bgView -> contentView -> cell -> UITableViewWrapperView -> tableView
//    UIView *superview = self.superview.superview.superview.superview;
//    if ([superview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
//        superview = superview.superview;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSOUserInfoDidClickNotification object:superview userInfo:@{@"account": account}];
}

@end

#pragma mark - 用户晒单、官方实拍标题视图

@interface SunOrderAssistInfoView ()
@property (nonatomic, weak) YYLabel *leftLabel;
@property (nonatomic, weak) YYLabel *rightLabel;
@end

@implementation SunOrderAssistInfoView

static CGFloat viewHeight_ = 0;
+ (CGFloat)viewHeight {
    if (viewHeight_ == 0) {
        viewHeight_ = kFont10Size + 10;
    }
    return viewHeight_;
}

+ (instancetype)sunOrderAssistInfoViewWithIsUser:(BOOL)isUser {
    SunOrderAssistInfoView *soaiView = [[self alloc] initWithFrame:CGRectMake(0, 0, JPPortraitScreenWidth - 2 * ViewMargin, self.viewHeight) isUser:isUser];
    return soaiView;
}

- (instancetype)initWithFrame:(CGRect)frame isUser:(BOOL)isUser {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat h = frame.size.height - 10;
        
        YYLabel *leftLabel = [YYLabel new];
        leftLabel.userInteractionEnabled = NO;
        leftLabel.font = [UIFont systemFontOfSize:kFont10Size];
        leftLabel.textColor = InfiniteeGray;
        leftLabel.text = isUser ? @"用户晒单" : @"官方实拍";
        leftLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        leftLabel.frame = CGRectMake(ViewMargin, 5, 200, h);
        leftLabel.displaysAsynchronously = YES;
        leftLabel.ignoreCommonProperties = YES;
        leftLabel.fadeOnHighlight = NO;
        leftLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:leftLabel];
        self.leftLabel = leftLabel;
        
        YYLabel *rightLabel = [YYLabel new];
        rightLabel.userInteractionEnabled = NO;
        rightLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        rightLabel.displaysAsynchronously = YES;
        rightLabel.ignoreCommonProperties = YES;
        rightLabel.fadeOnHighlight = NO;
        rightLabel.fadeOnAsynchronouslyDisplay = NO;
        [self addSubview:rightLabel];
        self.rightLabel = rightLabel;
    }
    return self;
}

- (void)updateRightPartyLayout:(YYTextLayout *)textLayout {
    CGFloat w = textLayout.textBoundingSize.width;
    CGFloat x = JPPortraitScreenWidth - 2 * ViewMargin - ViewMargin - w;
    self.rightLabel.frame = CGRectMake(x, self.leftLabel.jp_y, w, self.leftLabel.jp_height);
    self.rightLabel.textLayout = textLayout;
}

@end

#pragma mark - 用户晒单、官方实拍图片列表

@implementation SunOrderImageListView

static CGFloat itemWH_ = 0;
+ (CGFloat)itemWH {
    if (itemWH_ == 0) {
        itemWH_ = (JPPortraitScreenWidth - 4 * ViewMargin - 4 * CellMargin) / 5.0;
    }
    return itemWH_;
}

+ (CGFloat)minViewHeight {
    return self.itemWH + 10;
}

+ (instancetype)sunOrderImageListViewWithListCount:(NSInteger)listCount {
    CGRect frame = CGRectMake(0, 0, JPPortraitScreenWidth - 2 * ViewMargin, self.minViewHeight);
    SunOrderImageListView *soilView = [[self alloc] initWithFrame:frame listCount:listCount];
    return soilView;
}

- (instancetype)initWithFrame:(CGRect)frame listCount:(NSInteger)listCount {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat itemWH = SunOrderImageListView.itemWH;
        NSInteger col;
        NSInteger row;
        CGFloat x = 0;
        CGFloat y = 0;
        
        NSMutableArray *picViews = [NSMutableArray new];
        for (int i = 0; i < listCount; i++) {
            JPImageView *imageView = [JPImageView new];
            imageView.tag = i;
            imageView.hidden = YES;
            imageView.clipsToBounds = YES;
            imageView.layer.cornerRadius = 3;
            imageView.layer.borderWidth = JPSeparateLineThick;
            imageView.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
            imageView.backgroundColor = InfiniteePicBgColor;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            col = i % 5;
            row = i / 5;
            x = ViewMargin + col * itemWH + col * CellMargin;
            y = CellMargin + row * itemWH + row * CellMargin;
            imageView.frame = CGRectMake(x, y, itemWH, itemWH);
            
            [self addSubview:imageView];
            [picViews addObject:imageView];
            
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)]];
        }
        
        self.picViews = picViews;
    }
    return self;
}

- (void)setImageModels:(NSArray<SunOrderImageModel *> *)imageModels {
    _imageModels = [imageModels copy];
    NSInteger picsCount = self.picViews.count;
    for (int i = 0; i < picsCount; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [(JPImageView *)imageView jp_cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            if (i >= imageModels.count) {
                [(JPImageView *)imageView jp_cancelCurrentImageRequest];
                imageView.hidden = YES;
            } else {
                SunOrderImageModel *imageModel = imageModels[i];
                imageView.hidden = imageModel.isAnimating;
                [(JPImageView *)imageView setImageWithURL:imageModel.imageURL placeholder:[UIImage defaultWorksPicture]];
//                [(JPImageView *)imageView setImageWithURL:imageModel.imageURL placeholder:[UIImage defaultWorksPicture] completion:^(UIImage *image, NSError *error, NSURL *imageURL, JPWebImageFromType jp_fromType, JPWebImageStage jp_stage) {
//                    JPLog(@"回调到这个线程 --- %@", [NSThread currentThread]);
//                }];
            }
        }
    }
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tapGR {
    if (self.imageModels.count == 0) return;
    JPImageView *imageView = (JPImageView *)tapGR.view;
    SunOrderImageModel *imageModel = self.imageModels[imageView.tag];
    // self -> bgView -> contentView -> cell -> UITableViewWrapperView -> tableView
    UIView *superview = self.superview.superview.superview.superview;
    if ([superview isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) superview = superview.superview;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSOListImageDidClickNotification object:superview userInfo:@{@"imageModel": imageModel}];
}

@end

