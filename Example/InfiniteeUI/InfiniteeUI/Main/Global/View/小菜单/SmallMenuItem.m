//
//  SmallMenuItem.m
//  Infinitee2.0
//
//  Created by guanning on 2016/12/14.
//  Copyright © 2016年 Infinitee. All rights reserved.
//

#import "SmallMenuItem.h"

@interface SmallMenuItem ()
@property (weak, nonatomic) IBOutlet UILabel *itemIcon;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation SmallMenuItem

+ (instancetype)smallMenuItemWithModel:(SmallMenuModel *)model index:(NSInteger)index target:(id)target action:(SEL)action {
    SmallMenuItem *item = [self jp_viewLoadFromNib];
    item.autoresizingMask = UIViewAutoresizingNone;
    item.model = model;
    item.btn.tag = index;
    [item.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)setModel:(SmallMenuModel *)model {
    _model = model;
    
    self.itemIcon.text = model.titleIcon;
    self.itemTitle.text = model.title;
}

@end
