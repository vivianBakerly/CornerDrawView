//
//  DrawRadiusViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "DrawRadiusViewController.h"
#import "FMRadiusImageView.h"
@interface DrawRadiusViewController ()

@end

@implementation DrawRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat deviation = 100;;
    FMRadiusImageView *radiusImg = [[FMRadiusImageView alloc] initWithFrame:CGRectMake(deviation, deviation, 50, 50)];
    radiusImg.cornerRadius = 10;
//    radiusImg.isCircle = YES;
    radiusImg.borderColor = [UIColor yellowColor];
    radiusImg.borderWidth = 2.0f;
    radiusImg.image = [UIImage imageNamed:@"Avatar_2"];
    [self.view addSubview:radiusImg];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
