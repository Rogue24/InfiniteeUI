//
//  SunOrderImageCell.m
//  Infinitee2.0
//
//  Created by guanning on 2017/7/6.
//  Copyright © 2017年 Infinitee. All rights reserved.
//

#import "SunOrderImageCell.h"
#import <YYWebImage.h>
#import "SunOrderImageModel.h"

@implementation SunOrderImageCell

static CGFloat itemWH_ = 0;
+ (CGFloat)itemWH {
    if (itemWH_ == 0) {
        itemWH_ = (JPPortraitScreenWidth - 2 * ViewMargin - 2 * CellMargin) / 3.0;
    }
    return itemWH_;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGFloat cornerRadius = 3 * frame.size.width / ((JPPortraitScreenWidth - 4 * ViewMargin - 4 * CellMargin) / 5.0);
        
        JPImageView *imageView = [JPImageView new];
        imageView.layer.borderWidth = JPSeparateLineThick;
        imageView.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
        imageView.layer.cornerRadius = cornerRadius;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = InfiniteePicBgColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setImageModel:(SunOrderImageModel *)imageModel {
    _imageModel = imageModel;
    self.imageView.hidden = imageModel.isAnimating;
    [self.imageView setImageWithURL:imageModel.imageURL placeholder:[UIImage defaultWorksPicture]];
}

- (void)animateDone {
    self.imageView.hidden = NO;
}

@end
