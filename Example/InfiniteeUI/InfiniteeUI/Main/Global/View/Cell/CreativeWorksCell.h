//
//  CreativeWorksCell.h
//  优化CreativeWorksCell
//
//  Created by guanning on 2017/2/20.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreativeWorks.h"

@interface CreativeWorksCell : UICollectionViewCell
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, assign) BOOL isShowBtn;
@property (nonatomic, assign) BOOL isShowLookSameBtn; // 为YES，显示看同款按钮，也证明这是个商品，不是个作品

@property (nonatomic, strong) CreativeWorks *works;
@property (nonatomic, strong, readonly) UIImage *image;
- (void)zanAnimation:(NSString *)isZan;
- (void)updateFanAndWorksCount;
- (void)pushWorksDetailView:(BOOL)isAnimated;
@end
