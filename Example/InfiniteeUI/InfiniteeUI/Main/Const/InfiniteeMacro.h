//
//  InfiniteeMacro.h
//  Infinitee2.0
//
//  Created by guanning on 2017/5/23.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#ifndef InfiniteeMacro_h
#define InfiniteeMacro_h

#define kAttentionUserText(userName) [NSString stringWithFormat:@"已关注 %@", userName]

/** 公用颜色 */
#define InfiniteeBlue (JPRGBColor(88, 144, 255))
#define InfiniteeBlueA(a) (JPRGBAColor(88, 144, 255, a))

#define InfiniteeWhite (JPRGBColor(250, 250, 250))
#define InfiniteeWhiteA(a) (JPRGBAColor(250, 250, 250, a))

#define InfiniteeGray (JPRGBColor(202, 202, 202))
#define InfiniteeGrayA(a) (JPRGBAColor(202, 202, 202, a))

#define InfiniteeBlack (JPRGBColor(46, 53, 62))
#define InfiniteeBlackA(a) (JPRGBAColor(46, 53, 62, a))

#define InfiniteeRed (JPRGBColor(231, 127, 127))
#define InfiniteeRedA(a) (JPRGBAColor(231, 127, 127, a))

#define InfiniteePicBgColor (JPRGBColor(245, 245, 245))

/** 常规cell尺寸 */
#define BaseCellW ((JPPortraitScreenWidth - 2 * ViewMargin - CellMargin) * 0.5)
#define BaseCellH ((JPPortraitScreenWidth - 2 * ViewMargin) * (NormalCellHeight / (iPhone6Width - 2 * ViewMargin)))
#define BaseCellSize CGSizeMake(BaseCellW, BaseCellH)

/** 标签字体 */
#define JPTagFont [UIFont systemFontOfSize:12]

/** 个人 --- 头部视图高度 */
#define UserHeadViewHeight (JPPortraitScreenWidth * 2.0 / 3.0)
/** 个人 --- 选项栏高度 */
#define UserOptionMenuHeight 50.0
//#define UserOptionMenuHeight 64.0
/** 个人 --- 头部视图滚动区间 */
#define UserHeadDragSpace (UserHeadViewHeight - UserOptionMenuHeight)
/** 个人 --- 子控制器视图高度 */
#define UserChildVCHeight (JPPortraitScreenHeight - 50 - 50)

/** 设计空间 --- 款式选择 --- 左边产品分类列表宽度 */
#define PCListViewWidth (JPPortraitScreenWidth * (67.0 / 375.0))
/** 设计空间 --- 款式选择 --- 右边商品cell宽度 */
#define ProductionListCellWidth ((JPPortraitScreenWidth - PCListViewWidth - 2 * ViewMargin - CellMargin) * 0.5)
/** 设计空间 --- 款式选择 --- 右边商品cell高度 */
#define ProductionListCellHeight (ProductionListCellWidth + 71)
/** 设计空间 --- 款式选择 --- 右边商品列表header高度 */
#define PCReusableViewHeight ([UIFont systemFontOfSize:14].lineHeight + 20 + 15)

/** 作品在商品图片上的比例 */
#define WorksOnGoodsXScale (406.0 / 1280.0)
#define WorksOnGoodsYScale (274.0 / 1280.0)
#define WorksOnGoodsWScale (469.0 / 1280.0)
#define WorksOnGoodsHScale (670.0 / 1280.0)

#endif /* InfiniteeMacro_h */
