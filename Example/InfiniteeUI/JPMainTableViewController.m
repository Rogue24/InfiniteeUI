//
//  JPMainTableViewController.m
//  InfiniteeUI_Example
//
//  Created by 周健平 on 2020/5/19.
//  Copyright © 2020 zhoujianping24@hotmail.com. All rights reserved.
//

#import "JPMainTableViewController.h"
#import "UINavigationBar+JPExtension.h"
#import "CustomNavBgView.h"
#import "SunOrderAreaViewController.h"
#import "JPPhotoViewController.h"

@interface JPMainTableViewController ()
@property (nonatomic, strong) NSArray<NSString *> *subVcNames;
@end

@implementation JPMainTableViewController

#pragma mark - 常量

#pragma mark - setter

#pragma mark - getter

#pragma mark - 创建方法

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setupBase];
    [self __setupNavigationBar];
    [self __setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
#pragma clang diagnostic pop
}

#pragma mark - 初始布局

- (void)__setupBase {
    self.subVcNames = @[@" 晒单专区",
                        @" 个人主页",
                        @" 产品详情页",
                        @" 商品详情页",
                        @" 作品详情页",
                        @" 主题活动中心",
                        @" Infinitee相册"];
}

- (void)__setupNavigationBar {
    [self.navigationController.navigationBar jp_setupCustomNavigationBgView:[CustomNavBgView customNavBgView]];
    
    UIImage *image = [UIImage imageNamed:@"infiniteeUiLogo.png"];
    UIImageView *logoView = ({
        UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44 * (image.size.width / image.size.height), 44)];
        aImgView.image = image;
        aImgView.contentMode = UIViewContentModeScaleAspectFit;
        aImgView;
    });
    self.navigationItem.titleView = logoView;
}

- (void)__setupTableView {
    [self jp_contentInsetAdjustmentNever:self.tableView];
    self.tableView.backgroundColor = InfiniteeWhite;
    self.tableView.separatorColor = UIColor.whiteColor;
    self.tableView.contentInset = UIEdgeInsetsMake(JPNavTopMargin, 0, JPDiffTabBarH, 0);
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"JPCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subVcNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPCell" forIndexPath:indexPath];
    cell.backgroundColor = InfiniteeBlue;
    cell.textLabel.font = [UIFont infiniteeFontWithSize:15];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.textLabel.text = self.subVcNames[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            SunOrderAreaViewController *soaVC = [[SunOrderAreaViewController alloc] initWithDataSource:nil isFromBeginGuide:NO];
            [self.navigationController pushViewController:soaVC animated:YES];
            break;
        }
        case 6:
        {
            @jp_weakify(self);
            JPPhotoViewController *photoVC =[[JPPhotoViewController alloc] initWithTitle:@"选择照片" maxSelectedCount:5 confirmHandle:^(NSArray<JPPhotoViewModel *> *selectedPhotoVMs) {
                @jp_strongify(self);
                if (!self) return;
                
            }];
            [self.navigationController pushViewController:photoVC animated:YES];
        }
        default:
            [JPProgressHUD showSuccessWithStatus:@"敬请期待~" userInteractionEnabled:YES];
            break;
    }
}



@end
