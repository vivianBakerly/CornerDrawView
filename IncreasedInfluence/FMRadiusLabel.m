//
//  FMRadiusLabelView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "YYSentinel.h"
#import "FMRadiusLabel.h"
#import "UIImage+DrawRadius.h"

@interface FMRadiusLabel()
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *bgImgView;
@property(nonatomic, strong)UILabel *textLabel;
@end

@implementation FMRadiusLabel

@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;
@synthesize usedSystemDefault = _usedSystemDefault;

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderColor:(UIColor *)borderColor andWithBorderWidth:(CGFloat)borderWidth {
    self = [super initWithFrame:frame];
    if(self){
        [self initSettings];
        self.borderWidth = borderWidth;
        self.borderColor = borderColor;
        self.cornerRadius = cornerRadius;
    }
    return self;
}

- (void)initSettings {
    self.sentinel = [YYSentinel new];
    self.usedSystemDefault = NO;
    self.borderColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.bgImgView];
}

#pragma mark properties setting
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = (cornerRadius >= 0) ? cornerRadius : 0;
    if(!self.usedSystemDefault){
        self.bgImgView.layer.cornerRadius = 0;
        self.bgImgView.layer.masksToBounds = NO;
    }else{
        self.bgImgView.layer.cornerRadius = cornerRadius;
        self.bgImgView.layer.masksToBounds = YES;
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = (borderWidth >= 0) ? borderWidth : 0;
}

-(void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor ? : [UIColor clearColor];
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor ? : [UIColor blackColor];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    _labelBackGroundColor = backgroundColor ? : [UIColor blackColor];
}

-(void)setText:(NSString *)text {
    _text = text;
    if(!_usedSystemDefault){
        self.bgImgView.backgroundColor = [UIColor clearColor];
        self.bgImgView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bgImgView.layer.borderWidth = 0;
        self.bgImgView.layer.borderWidth = self.borderWidth;
        switch (self.labelType) {
            case FMLabelType_Solid:
            {
                [self p_drawWithImage:nil];
            }
                break;
            case FMLabelType_Hollow:
            {
                [self p_drawWithImage: [UIImage drawsolidRecInFrame:self.bgImgView.frame andfillWithColor:self.labelBackGroundColor]];
            }
                break;
            default:
                break;
        }
    }else{
        switch (self.labelType) {
            case FMLabelType_Solid:
            {
                self.bgImgView.backgroundColor = self.borderColor;
                
            }
                break;
            case FMLabelType_Hollow:
            {
                self.bgImgView.backgroundColor = [UIColor blackColor];
            }
                break;
            default:
                break;
        }
        self.bgImgView.layer.borderColor = self.borderColor.CGColor;
        self.bgImgView.layer.borderWidth = self.borderWidth;
    }
}

#pragma mark draw
-(void)p_drawWithImage:(UIImage *)img {
    [self.sentinel increase];
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value);
    };
    
    dispatch_async(YYAsyncLayerGetDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        CGRect drawFrame = self.bgImgView.frame;
        //上层图片
        UIImage *topImg = [UIImage drawCornerRadiusWithBgImg:img withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame];
        UIImage *final;
        if(self.borderWidth > 0){
            //下层图片，用于边框
            UIImage *bg = [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame];
            final = [UIImage mixTopImg:topImg withBgImg:bg inFrame:drawFrame WithBorderWidth:self.borderWidth];
        }else{
            final = topImg;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.bgImgView.image = final;
            [self p_drawText];
        });
    });
}


-(void)p_drawText {
    [self.textLabel removeFromSuperview];
    if(self.text.length > 0){
        UILabel *label = [[UILabel alloc] initWithFrame:self.bgImgView.bounds];
        label.font = [UIFont systemFontOfSize:14];
        label.text = self.text;
        label.textColor = self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
        self.textLabel = label;
        [self addSubview:self.textLabel];
    }else{
        self.textLabel.text = @"";
    }
}

@end
