//
//  FMSketchpadViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/15.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMSketchpadViewController.h"
#import "FMRadiusImageView.h"

static const CGFloat kSketchpadGap = 50;

@interface FMSketchpadViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UIView *sketchpadView;
@property(nonatomic, strong) UITextView *radiusTextView;
@property(nonatomic, strong) UITextView *borderWidthTextView;
@property(nonatomic, strong) FMRadiusImageView *radiusImageView;

@end
@implementation FMSketchpadViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initNormalViews];
    [self initRadiusViews];
}

#pragma mark init methods
- (void)initNormalViews
{
    CGFloat sketchPadWidth = [UIScreen mainScreen].bounds.size.width - 2 * kSketchpadGap;
    self.sketchpadView = [[UIView alloc] initWithFrame:CGRectMake(kSketchpadGap, kSketchpadGap + self.navigationController.navigationBar.frame.size.height, sketchPadWidth, sketchPadWidth)];
    self.sketchpadView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sketchpadView];
    
    CGFloat textViewHeight = 30;
    CGFloat textViewWidth = 100;
    CGFloat startX = self.sketchpadView.frame.origin.x + sketchPadWidth - textViewWidth;
    
    UILabel *radiuLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSketchpadGap, self.sketchpadView.frame.origin.y + sketchPadWidth + 20, textViewWidth * 2, textViewHeight)];
    radiuLabel.text = @"Enter cornerRadius :";
    radiuLabel.textColor = [UIColor grayColor];
    [self.view addSubview:radiuLabel];
    
    self.radiusTextView = [[UITextView alloc] initWithFrame:CGRectMake(startX, self.sketchpadView.frame.origin.y + sketchPadWidth + 20, textViewWidth, textViewHeight)];
    self.radiusTextView.backgroundColor = [UIColor grayColor];
    
    
    UILabel *borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSketchpadGap, self.radiusTextView.frame.origin.y + textViewHeight + 20, textViewWidth * 2, textViewHeight)];
    borderLabel.text = @"Enter borderWidth: ";
    borderLabel.textColor = [UIColor grayColor];
    [self.view addSubview:borderLabel];
    
    self.borderWidthTextView = [[UITextView alloc] initWithFrame:CGRectMake(startX, self.radiusTextView.frame.origin.y + textViewHeight + 20, textViewWidth, textViewHeight)];
    self.borderWidthTextView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.radiusTextView];
    [self.view addSubview:self.borderWidthTextView];
}

- (void)initRadiusViews
{
    self.radiusImageView = [[FMRadiusImageView alloc] initWithFrame:self.sketchpadView.frame];
    self.radiusImageView.cornerRadius = 0;
    self.radiusImageView.borderColor = [UIColor yellowColor];
    self.radiusImageView.borderWidth = 10.0f;
    self.radiusImageView.image =  [UIImage imageNamed:@"Avatar_2"];
    [self.view addSubview:self.radiusImageView];
}
@end
