//
//  JPSunOrderDataTool.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/21.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "JPSunOrderDataTool.h"
#import "SunOrderImageTextCell.h"
#import "SunOrderImageCell.h"
#import "InfiniteeTextLayoutTool.h"

@interface JPSunOrderDataTool ()
@property (nonatomic, weak) NSURLSessionDataTask *soCTask;
@property (nonatomic, weak) NSURLSessionDataTask *pSoTask;
@property (nonatomic, weak) NSURLSessionDataTask *cSoTask;
@end

@implementation JPSunOrderDataTool
{
    NSInteger _imageIndex;
}

- (NSURLSessionDataTask *)requestSunOrderCategoryDataWithSuccessBlock:(SoCategorySuccessBlock)successBlock failureBlock:(void (^)(void))failureBlock {
    if (!successBlock) return nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *filePath = JPMainBundleResourcePath(@"productionCategoryForComment", @"plist");
        NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSArray *socModels = [SunOrderCategoryModel mj_objectArrayWithKeyValuesArray:resultDic[@"categories"]];
        
        CGFloat x = CellMargin;
        UIFont *iconF = [UIFont productFontWithSize:13 * JPScale];
        UIFont *nameF = [UIFont systemFontOfSize:12 * JPScale];
        
        NSMutableArray *socVMs = [NSMutableArray array];
        for (SunOrderCategoryModel *socModel in socModels) {
            if (socModel.icon.length == 0) {
                socModel.icon = @"";
                socModel.isInfiniteeFont = YES;
            }
            SunOrderCategoryViewModel *socVM = [self analysisSunOrderCategoryModel:socModel cellX:x iconFont:iconF nameFont:nameF];
            [socVMs addObject:socVM];
            x += socVM.cellFrame.size.width;
        }
        [socVMs.firstObject setIsSelected:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(socVMs);
        });
    });
    
    return self.soCTask;
}

- (SunOrderCategoryViewModel *)analysisSunOrderCategoryModel:(SunOrderCategoryModel *)socModel cellX:(CGFloat)cellX iconFont:(UIFont *)iconFont nameFont:(UIFont *)nameFont {
    
    SunOrderCategoryViewModel *socVM = [[SunOrderCategoryViewModel alloc] init];
    socVM.socModel = socModel;
    
    socVM.iconR = 46.0;
    socVM.iconG = 53.0;
    socVM.iconB = 62.0;
    
    CGFloat iconW = 0;
    CGFloat nameW = 0;
    if (socModel.icon.length) iconW = [socModel.icon boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: iconFont} context:nil].size.width;
    if (socModel.name.length) nameW = [socModel.name boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: nameFont} context:nil].size.width;
    
    socVM.styleIconW = iconW;
    socVM.styleNameW = nameW;
    socVM.titleWidth = iconW > 0 ? (iconW + CellMargin + nameW) : nameW;
    socVM.cellFrame = CGRectMake(cellX, 0, socVM.titleWidth + 2 * ViewMargin, 46) ;
    
    return socVM;
}

- (NSURLSessionDataTask *)requestSunOrderDataWithProID:(NSString *)proID
                                page:(NSInteger)page
                          imageIndex:(NSInteger)imageIndex
                            lastTime:(NSString *)lastTime
                        successBlock:(SoDataSuccessBlock)successBlock
                        failureBlock:(void(^)(void))failureBlock {
    [self.pSoTask cancel];
    self.pSoTask = [self requestSunOrderDataIsByCategory:NO ID:proID page:page imageIndex:imageIndex lastTime:lastTime successBlock:successBlock failureBlock:failureBlock];
    return self.pSoTask;
}

- (NSURLSessionDataTask *)requestSunOrderDataWithCategoryID:(NSString *)categoryID
                                     page:(NSInteger)page
                               imageIndex:(NSInteger)imageIndex
                                 lastTime:(NSString *)lastTime
                             successBlock:(SoDataSuccessBlock)successBlock
                             failureBlock:(void(^)(void))failureBlock {
    [self.cSoTask cancel];
    self.cSoTask = [self requestSunOrderDataIsByCategory:YES ID:categoryID page:page imageIndex:imageIndex lastTime:lastTime successBlock:successBlock failureBlock:failureBlock];
    return self.cSoTask;
}

- (NSURLSessionDataTask *)requestSunOrderDataIsByCategory:(BOOL)isByCategory
             ID:(NSString *)ID
           page:(NSInteger)page
     imageIndex:(NSInteger)imageIndex
       lastTime:(NSString *)lastTime
   successBlock:(SoDataSuccessBlock)successBlock
   failureBlock:(void(^)(void))failureBlock {
    if (!successBlock) return nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        
        NSString *fileName = [NSString stringWithFormat:@"orderShareComment_%@", ID.length ? ID : @"main"];
        NSString *filePath = JPMainBundleResourcePath(fileName, @"plist");
        NSDictionary *resultDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSMutableArray *sodVMs = [NSMutableArray array];
        NSMutableArray *soIMs = [NSMutableArray array];

        if ([resultDic[@"comments"] count]) {
            NSArray *soModels = [SunOrderModel mj_objectArrayWithKeyValuesArray:resultDic[@"comments"]];
            NSInteger index = (page - 1) * 10;
            self->_imageIndex = imageIndex;
            for (SunOrderModel *soModel in soModels) {
                SunOrderDetailViewModel *sodVM = [self analysisSunOrderModel:soModel index:index isFromCategory:isByCategory];
                [sodVMs addObject:sodVM];
                [soIMs addObjectsFromArray:sodVM.userImageModels];
                [soIMs addObjectsFromArray:sodVM.governImageModels];
                index += 1;
            }

        }

        NSString *lastTime;
        NSInteger totalResult = 0;
        if (page == 1) {
            lastTime = resultDic[@"lastTime"];
//            totalResult = [resultDic[@"totalResult"] integerValue];
            totalResult = sodVMs.count * 2;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(page, totalResult, lastTime, sodVMs, soIMs);
        });
    });
    
    return nil;
}

- (SunOrderDetailViewModel *)analysisSunOrderModel:(SunOrderModel *)soModel index:(NSInteger)index isFromCategory:(BOOL)isFromCategory {
    
    SunOrderDetailViewModel *sodVM = [SunOrderDetailViewModel new];
    sodVM.soModel = soModel;
    sodVM.isFromCategory = isFromCategory;
    
    CGFloat goodsPictureWH = SunOrderInfoView.goodsPictureWH;
    CGFloat userIconWH = SunOrderInfoView.userIconWH;
    CGFloat infoViewH = SunOrderInfoView.viewHeight;
    CGFloat assistViewH = SunOrderAssistInfoView.viewHeight;
    CGFloat itemWH = SunOrderImageListView.itemWH;
    CGFloat pictureWH = SunOrderImageCell.itemWH;
    
    YYTextLayout *typeLayout;
    YYTextLayout *goodsNameLayout;
    YYTextLayout *styleAndSizeLayout;
    YYTextLayout *buyGoodsDateLayout;
    YYTextLayout *userNameLayout;
    YYTextLayout *identityLayout;
    YYTextLayout *userSoDateLayout;
    YYTextLayout *governSoDateLayout;
    YYTextLayout *describeLayout;
    
    InfiniteeTextLayoutParameter *goodsNameTLParameter = [SunOrderImageTextCell goodsNameTLParameter];
    InfiniteeTextLayoutParameter *syleAndSizeTLParameter = [SunOrderImageTextCell syleAndSizeTLParameter];
    InfiniteeTextLayoutParameter *buyGoodsDateTLParameter = [SunOrderImageTextCell buyGoodsDateTLParameter];
    InfiniteeTextLayoutParameter *userNameTLParameter = [SunOrderImageTextCell userNameTLParameter];
    InfiniteeTextLayoutParameter *identityTLParameter = [SunOrderImageTextCell identityTLParameter];
    InfiniteeTextLayoutParameter *assistInfoTLParameter = [SunOrderImageTextCell assistInfoTLParameter];
    InfiniteeTextLayoutParameter *describeTLParameter = [SunOrderImageTextCell describeTLParameter];
    
    sodVM.goodsPictureURL = [NSURL URLWithString:[soModel.proPicture jp_imageFormatURLWithSize:CGSizeMake(goodsPictureWH, goodsPictureWH)]];
    sodVM.userIconURL = [NSURL URLWithString:[soModel.proCusIcon jp_imageFormatURLWithSize:CGSizeMake(userIconWH, userIconWH)]];

    if (soModel.showType < 4 && soModel.orderBuyType == 1) {
        NSString *type = @"礼物";
        sodVM.typeColor = JPRGBColor(227, 140, 125);
        sodVM.boardColor = JPRGBAColor(227, 140, 125, 0.5);
        [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:type parameter:[SunOrderImageTextCell typeTLParameter] textLayout:&typeLayout];
    } else {
        sodVM.typeColor = nil;
        sodVM.boardColor = InfiniteeBlueA(0.5);
    }
    
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:soModel.proName parameter:goodsNameTLParameter textLayout:&goodsNameLayout];
    
    NSString *styleAndSize = [NSString stringWithFormat:@"款式：%@  尺码：%@", soModel.proShape, soModel.proSize];
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:styleAndSize parameter:syleAndSizeTLParameter textLayout:&styleAndSizeLayout];
    
    buyGoodsDateTLParameter.textColor = sodVM.typeColor ? sodVM.typeColor : JPRGBColor(64, 109, 227);
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:soModel.showTypeName parameter:buyGoodsDateTLParameter textLayout:&buyGoodsDateLayout];
    
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:soModel.proCusName parameter:userNameTLParameter textLayout:&userNameLayout];
    
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:soModel.proCusType parameter:identityTLParameter textLayout:&identityLayout];
    
    sodVM.describeH = soModel.content.length ? [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:soModel.content parameter:describeTLParameter textLayout:&describeLayout] : 0;
    
    NSString *userSoDateStr = soModel.createDate;
    CGFloat userImageListHeight = 0;
    if (soModel.picturesArray.count) {
        NSMutableArray *userImageModels = [NSMutableArray array];
        NSArray *userImageURLStrs = soModel.picturesArray;
        NSInteger count = userImageURLStrs.count;
        for (NSInteger i = 0; i < count; i++) {
            NSString *userImageURLStr = userImageURLStrs[i];
            NSString *urlStr = [userImageURLStr jp_imageFormatURLWithSize:CGSizeMake(pictureWH, pictureWH)];
            NSURL *url = [NSURL URLWithString:urlStr];
            SunOrderImageModel *imageModel = [SunOrderImageModel new];
            imageModel.isFromCategory = isFromCategory;
            imageModel.baseURLStr = userImageURLStr;
            imageModel.isUserList = YES;
            imageModel.tableIndex = index;
            imageModel.picListIndex = i;
            imageModel.imageURL = url;
            imageModel.allPicIndex = _imageIndex;
            [userImageModels addObject:imageModel];
            _imageIndex += 1;
        }
        sodVM.userImageModels = userImageModels;
        
        NSInteger row = count / 5;
        if (count % 5 > 0) row += 1;
        userImageListHeight = row * itemWH + (row - 1) * CellMargin + 10;
    } else {
        if (soModel.content.length == 0) userSoDateStr = @"暂无";
    }
    sodVM.userImageListHeight = userImageListHeight;
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:userSoDateStr parameter:assistInfoTLParameter textLayout:&userSoDateLayout];
    
//    NSString *governSoDateStr = soModel.modelCreateDate;
    NSString *governSoDateStr = @" "; // 官方晒单日期不显示
    CGFloat governImageListHeight = 0;
    if (soModel.modelPicArray.count) {
        NSMutableArray *governImageModels = [NSMutableArray array];
        NSArray *governImageURLStrs = soModel.modelPicArray;
        NSInteger count = governImageURLStrs.count;
        for (NSInteger i = 0; i < count; i++) {
            NSString *governImageURLStr = governImageURLStrs[i];
            NSString *urlStr = [governImageURLStr jp_imageFormatURLWithSize:CGSizeMake(pictureWH, pictureWH)];
            NSURL *url = [NSURL URLWithString:urlStr];
            SunOrderImageModel *imageModel = [SunOrderImageModel new];
            imageModel.isFromCategory = isFromCategory;
            imageModel.baseURLStr = governImageURLStr;
            imageModel.isUserList = NO;
            imageModel.tableIndex = index;
            imageModel.picListIndex = i;
            imageModel.imageURL = url;
            imageModel.allPicIndex = _imageIndex;
            [governImageModels addObject:imageModel];
            _imageIndex += 1;
        }
        sodVM.governImageModels = governImageModels;
        
        NSInteger row = count / 5;
        if (count % 5 > 0) row += 1;
        governImageListHeight = row * itemWH + (row - 1) * CellMargin + 10;
    } else {
        governSoDateStr = @"暂无";
    }
    sodVM.governImageListHeight = governImageListHeight;
    [InfiniteeTextLayoutTool getTextHeightAndCreateTextLayoutWithText:governSoDateStr parameter:assistInfoTLParameter textLayout:&governSoDateLayout];
    
    sodVM.typeLayout = typeLayout;
    sodVM.goodsNameLayout = goodsNameLayout;
    sodVM.styleAndSizeLayout = styleAndSizeLayout;
    sodVM.buyGoodsDateLayout = buyGoodsDateLayout;
    sodVM.userNameLayout = userNameLayout;
    sodVM.identityLayout = identityLayout;
    sodVM.userSoDateLayout = userSoDateLayout;
    sodVM.governSoDateLayout = governSoDateLayout;
    sodVM.describeLayout = describeLayout;
    
    sodVM.userImageListY = infoViewH + assistViewH + sodVM.describeH;
    sodVM.governImageListY = sodVM.userImageListY + sodVM.userImageListHeight + 5 + assistViewH;
    sodVM.cellHeight = sodVM.governImageListY + sodVM.governImageListHeight + 5 + 10;
    
    return sodVM;
}

@end

