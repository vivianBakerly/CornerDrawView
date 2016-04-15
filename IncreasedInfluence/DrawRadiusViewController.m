//
//  DrawRadiusViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "DrawRadiusViewController.h"
#import "FMRadiusImageView.h"
#import "FMRadiusLabel.h"
@interface DrawRadiusViewController ()
@property(nonatomic, strong)FMRadiusImageView *radiusImg;
@property(nonatomic, strong)FMRadiusLabel *radiusLabel;
@property(nonatomic, assign)BOOL hasCornerRadius;
@end

@implementation DrawRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_settingNavRightBtn];
    self.hasCornerRadius = NO;
    
    CGFloat deviation = 100;;
    FMRadiusImageView *rImg = [[FMRadiusImageView alloc] initWithFrame:CGRectMake(deviation, deviation, 50, 50)];
//    radiusImg.isCircle = YES;
    rImg.borderColor = [UIColor yellowColor];
    rImg.borderWidth = 2.0f;
    rImg.image = [UIImage imageNamed:@"Avatar_2"];
    self.radiusImg = rImg;
    [self.view addSubview:self.radiusImg];
    
    
    
    FMRadiusLabel *radiusLabel = [[FMRadiusLabel alloc] initWithFrame:CGRectMake(deviation * 2, deviation * 2, 100, 50)];
    radiusLabel.cornerRadius = 10;
    radiusLabel.borderWidth = 2;
    radiusLabel.borderColor = [UIColor yellowColor];
    radiusLabel.textColor = [UIColor purpleColor];
    radiusLabel.labelType = FMLabelType_Hollow;
    radiusLabel.text = @"ISABELLA";
    [self.view addSubview:radiusLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_settingNavRightBtn
{
    UISwitch *setting = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [setting addTarget:self action:@selector(p_addCornerRadius) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:setting];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)p_addCornerRadius
{
    _hasCornerRadius = !_hasCornerRadius;
    self.radiusImg.cornerRadius = (_hasCornerRadius) ? 20 : 0;
}
@end
