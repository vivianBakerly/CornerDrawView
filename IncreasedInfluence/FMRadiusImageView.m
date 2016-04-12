//
//  FMRadiusImageView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "YYSentinel.h"
#import "FMRadiusImageView.h"

#import "UIImage+DrawRadius.h"

@interface FMRadiusImageView()
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *bgImgView;
@end
@implementation FMRadiusImageView

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
    self.isCircle = NO;
    self.borderColor = [UIColor clearColor];
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

- (void)setIsCircle:(BOOL)isCircle {
    _isCircle = isCircle;
    CGSize size = self.bounds.size;
    //取小的值, 避免裁剪过度
    self.cornerRadius = (size.width <= size.height) ? size.width : size.height;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if(!self.usedSystemDefault){
        [self p_drawWithImage:image];
    }else{
        self.bgImgView.image = image;
    }
}

#pragma draw
-(void)p_drawWithImage:(UIImage *)img {
    [self.sentinel increase];
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value) && (!self.image);
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
        });
    });
}

@end
