//
//  JPMainCell.h
//  JPImageresizerView_Example
//
//  Created by 周健平 on 2020/11/2.
//  Copyright © 2020 ZhouJianPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPMainCellModel.h"

@interface JPMainCell : UICollectionViewCell
+ (NSString *)cellID;
+ (UIFont *)iconFont;
+ (UIFont *)titleFont;
+ (UIColor *)textColor;
@property (nonatomic, strong) JPMainCellModel *cellModel;
@property (nonatomic, copy) void (^didClickCell)(JPMainCellModel *cellModel);
@end

