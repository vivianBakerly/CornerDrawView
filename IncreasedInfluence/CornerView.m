//
//  CornerView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/3/21.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "CornerView.h"
#import "YYSentinel.h"
@interface CornerView()
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *bgImgView;
@property(nonatomic, strong)UILabel *textLabel;

//tbd
@property(nonatomic, assign) BOOL maskToBound;
@end
@implementation CornerView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.sentinel = [YYSentinel new];
        self.maskToBound = YES;
        self.usedSystemDefault = NO;
        self.bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.textLabel = [[UILabel alloc] initWithFrame:self.bgImgView.frame];
        [self addSubview:self.bgImgView];
        [self addSubview:self.textLabel];
    }
    return self;
}

#pragma mark set properties
-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if(!self.usedSystemDefault){
        self.bgImgView.layer.cornerRadius = 0;
        self.bgImgView.layer.masksToBounds = NO;
    }else{
        self.bgImgView.layer.cornerRadius = cornerRadius;
        self.bgImgView.layer.masksToBounds = YES;
    }
}

-(UIColor *)textColor
{
    return _textColor ? : [UIColor purpleColor];
}

-(UIColor *)borderColor
{
    return _borderColor ? : [UIColor yellowColor];
}

-(CGFloat)borderWidth
{
    return (_borderWidth >= 0) ? _borderWidth : 1;
}

-(UIColor *)labelBackGroundColor
{
    return _labelBackGroundColor ? : [UIColor blackColor];
}

-(void)setIsCircle:(BOOL)isCircle {
    _isCircle = isCircle;
    self.cornerRadius = self.bgImgView.frame.size.width / 2;
}

-(void)setText:(NSString *)text {
    _text = text;
    if(!_usedSystemDefault){
        self.bgImgView.backgroundColor = [UIColor clearColor];
        self.bgImgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bgImgView.layer.borderWidth = 0;
        self.bgImgView.layer.borderWidth = self.borderWidth;
        switch (self.labelType) {
            case IncLabelType_Solid:
            {
                [self p_drawWithImage:nil];
            }
                break;
            case IncLabelType_Hollow:
            {
                [self p_drawWithImage:[self p_solidWithColor:[UIColor blackColor]]];
            }
                break;
            default:
                break;
        }
    }else{
        switch (self.labelType) {
            case IncLabelType_Solid:
            {
                self.bgImgView.backgroundColor = self.borderColor;
                
            }
                break;
            case IncLabelType_Hollow:
            {
                self.bgImgView.backgroundColor = [UIColor blackColor];
            }
                break;
            default:
                break;
        }
        self.bgImgView.layer.borderColor = self.borderColor.CGColor;
        self.bgImgView.layer.borderWidth = self.borderWidth;
        [self p_drawText];
    }
}

-(void)setBackgroundImage:(UIImage *)bgImg {
    _backgroundImage = bgImg;
    if(!self.usedSystemDefault){
        [self p_drawWithImage:bgImg];
    }else{
        self.bgImgView.image = bgImg;
        [self p_drawText];
    }
}

#pragma -MARK 设置回主线程
//把画好圆角的图片设置为背景图
-(void)p_drawWithImage:(UIImage *)img {
    [self.sentinel increase];
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value) && (!self.backgroundImage);
    };
    
    dispatch_async(YYAsyncLayerGetDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        //上层图片
        UIImage *topImg = [self drawCornerRadius:img withBorderWidth:self.borderWidth];
        UIImage *bg = [self drawCornerRadius:[self p_solidWithColor:[UIColor yellowColor]] withBorderWidth:0];
        UIImage *final = [self p_mixTopImg:topImg withBgImg:bg];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.bgImgView.image = final;
            [self p_drawText];
        });
    });
}

#pragma -MARK draw
//把上下两层图片叠加
-(UIImage *)p_mixTopImg:(UIImage *)top withBgImg:(UIImage *)bg {
    UIGraphicsBeginImageContextWithOptions(self.bgImgView.frame.size, NO, [UIScreen mainScreen].scale);
    CGRect outerBounds = CGRectMake(0, 0, self.bgImgView.frame.size.width, self.bgImgView.frame.size.height);
    CGFloat width = self.borderWidth;
    CGRect innerBounds = CGRectMake(width, width, self.bgImgView.frame.size.width - 2 * width, self.bgImgView.frame.size.height - 2 * width);
    [bg drawInRect:outerBounds];
    [top drawInRect:innerBounds];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

-(void)p_drawText {
    if(self.text.length > 0){
        UILabel *label = [[UILabel alloc] initWithFrame:self.bgImgView.bounds];
        label.font = [UIFont systemFontOfSize:14];
        label.text = self.text;
        label.textColor = self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self.textLabel removeFromSuperview];
        self.textLabel = label;
        [self addSubview:self.textLabel];
    }else{
        self.textLabel.text = @"";
    }
}

//把一个图片按照cornerRadius和borderWidth画成带边框圆角图片
- (UIImage *)drawCornerRadius :(UIImage *)img withBorderWidth:(CGFloat)borderWidth{
    CGSize size = CGSizeMake(self.bgImgView.frame.size.width - 2 * borderWidth, self.bgImgView.frame.size.height - 2 * borderWidth);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect bounds = CGRectMake(0, 0, self.bgImgView.frame.size.width - 2 * borderWidth, self.bgImgView.frame.size.height - 2 * borderWidth);
    [[UIColor clearColor] set];
    UIRectFill(bounds);
    
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius] addClip];
    UIImage *cornerImg = img;
    [cornerImg drawInRect:bounds];
    UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImg;
}
//画实心方形图
-(UIImage *)p_solidWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.bgImgView.frame.size, NO, [UIScreen mainScreen].scale);
    [color set];
    CGRect bounds = CGRectMake(0, 0, self.bgImgView.frame.size.width, self.bgImgView.frame.size.height);
    UIRectFill(bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
