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
@property(nonatomic, strong) UIButton *confirmBtn;
@property(nonatomic, assign) BOOL turnOn;


@property(nonatomic, assign)CGFloat radiusDraft;
@property(nonatomic, assign)CGFloat widthDraft;

@end
@implementation FMSketchpadViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initNormalViews];
    [self initRadiusViews];
    [self initColorSwitcher];
    [self initConfirmBtn];
    [self addGesture];
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
    self.radiusTextView.delegate = self;
    self.radiusTextView.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSketchpadGap, self.radiusTextView.frame.origin.y + textViewHeight + 20, textViewWidth * 2, textViewHeight)];
    borderLabel.text = @"Enter borderWidth: ";
    borderLabel.textColor = [UIColor grayColor];
    [self.view addSubview:borderLabel];
    
    self.borderWidthTextView = [[UITextView alloc] initWithFrame:CGRectMake(startX, self.radiusTextView.frame.origin.y + textViewHeight + 20, textViewWidth, textViewHeight)];
    self.borderWidthTextView.backgroundColor = [UIColor grayColor];
    self.borderWidthTextView.delegate = self;
    self.borderWidthTextView.keyboardType = UIKeyboardTypeDecimalPad;
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

- (void)initColorSwitcher
{
    CGFloat middle = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat switchWidth = 51;
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(middle - switchWidth / 2, self.borderWidthTextView.frame.origin.y + self.borderWidthTextView.frame.size.height + 30, switchWidth, switchWidth / 2)];
    [switcher addTarget:self action:@selector(switchMode) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switcher];
    
    CGFloat labelWidth = 50;
    UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(switcher.frame.origin.x - 10 - labelWidth, switcher.frame.origin.y, labelWidth, switcher.frame.size.height)];
    left.text = @"RED";
    left.textColor = [UIColor redColor];
    [self.view addSubview:left];
    
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(switcher.frame.origin.x + switchWidth + 10, switcher.frame.origin.y, labelWidth, switcher.frame.size.height)];
    right.text = @"YELLOW";
    right.textColor = [UIColor yellowColor];
    [self.view addSubview:right];
}

- (void)initConfirmBtn
{
    CGFloat middle = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat btnWidth = 250;
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(middle - btnWidth / 2, self.borderWidthTextView.frame.origin.y + self.borderWidthTextView.frame.size.height + 30 + 33 + 20, btnWidth, 50)];
    self.confirmBtn.backgroundColor = [UIColor yellowColor];
    self.confirmBtn.layer.cornerRadius = 10;
    [self.confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(pressConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
}

#pragma mark Actions
- (void)pressConfirm
{
    self.radiusImageView.cornerRadius = self.radiusDraft;
    self.radiusImageView.borderWidth = self.widthDraft;
    self.radiusImageView.borderColor = (self.turnOn) ? [UIColor redColor] : [UIColor yellowColor];
}
- (void)switchMode
{
    _turnOn = !_turnOn;
}

#pragma textView methods
-(void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponders)];
    [self.view addGestureRecognizer:tap];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == self.radiusTextView){
        self.radiusDraft = [textView.text floatValue];
    }else if(textView == self.borderWidthTextView){
        self.widthDraft = [textView.text floatValue];
    }
}
//点击View任意空白处，关闭键盘
- (void)resignResponders {
    
    [self.radiusTextView resignFirstResponder];
    [self.borderWidthTextView resignFirstResponder];
}

@end
