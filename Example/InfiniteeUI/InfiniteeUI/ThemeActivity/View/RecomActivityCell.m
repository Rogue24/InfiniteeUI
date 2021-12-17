//
//  RecomActivityCell.m
//  Infinitee2.0
//
//  Created by guanning on 16/11/16.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "RecomActivityCell.h"

@interface RecomActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@end

@implementation RecomActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = JPSeparateLineThick + 0.01;
    self.layer.borderColor = InfiniteeGrayA(0.3).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setTheme:(Theme *)theme {
    _theme = theme;
    NSURL *pictureUrl = [NSURL URLWithString:[theme.picture jp_imageFormatURLWithSize:InfiniteeConst.themeCellSize]];
    [self.pictureView jp_fakeSetPictureWithURL:pictureUrl placeholderImage:nil];
}

- (UIImage *)themeImage {
    return self.pictureView.image;
}

@end
