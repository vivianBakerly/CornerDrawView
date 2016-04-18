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

/**
 *  tbd:取消时机
 *  两张图的绘制条件
 */

@interface FMRadiusImageView()
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *resultImg;

//borderWidth决定是否绘制，frame和borderColor, cornerRadius决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerBorderImage;
//frame, cornerRadius, borderWidth决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerUserImage;

@property(nonatomic, assign)BOOL needReDrawCornerUserImage;
@property(nonatomic, assign)BOOL needReDrawcornerBorderImage;

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
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.resultImg];
    
    self.needReDrawCornerUserImage = NO;
    self.needReDrawcornerBorderImage = NO;
}

#pragma mark override
- (void)setNeedsDisplay
{
    [self p_cancelAsyncDraw];
    [super setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self p_drawWithImage:self.image];
}

#pragma mark properties setting
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        _cornerRadius = cornerRadius;
        if(!self.usedSystemDefault){
            self.resultImg.layer.cornerRadius = 0;
            self.resultImg.layer.masksToBounds = NO;
        }else{
            self.resultImg.layer.cornerRadius = cornerRadius;
            self.resultImg.layer.masksToBounds = YES;
        }
        self.needReDrawCornerUserImage = YES;
        self.needReDrawcornerBorderImage = YES;
        [self setNeedsDisplay];
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(_borderWidth != borderWidth && borderWidth >= 0){
        _borderWidth = borderWidth;
        self.needReDrawCornerUserImage = YES;
        [self setNeedsDisplay];
    }
}

-(void)setBorderColor:(UIColor *)borderColor {
    if(borderColor != _borderColor){
        _borderColor = borderColor ? : [UIColor clearColor];
        //颜色改变且有宽度时才绘制
        if(_borderWidth > 0){
            self.needReDrawcornerBorderImage = YES;
            [self setNeedsDisplay];
        }
    }
 }

- (void)setIsCircle:(BOOL)isCircle {
    _isCircle = isCircle;
    if(isCircle){
        CGSize size = self.bounds.size;
        //取小的值, 避免裁剪过度
        self.cornerRadius = (size.width <= size.height) ? size.width : size.height;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if(!self.usedSystemDefault){
        self.needReDrawCornerUserImage = YES;
        [self setNeedsDisplay];
    }else{
        self.resultImg.image = image;
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
        CGRect drawFrame = self.resultImg.frame;
        //上层图片
        UIImage *final;
        UIImage *top = (self.needReDrawCornerUserImage) ?  [UIImage drawCornerRadiusWithBgImg:img withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : nil;
        UIImage *bg;
        if(self.borderWidth > 0 && self.needReDrawcornerBorderImage){
            //下层图片，用于边框
            bg = [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame];
            final = [UIImage mixTopImg:top withBgImg:bg inFrame:drawFrame WithBorderWidth:self.borderWidth];
        }else{
            final = top;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.resultImg.image = final;
            self.cornerUserImage = top;
            self.cornerBorderImage = bg;
            self.needReDrawcornerBorderImage = NO;
            self.needReDrawCornerUserImage = NO;
            NSLog(@"CornerRadius = %f, BorderWidth = %f", self.cornerRadius, self.borderWidth);
        });
    });
}

- (void)p_cancelAsyncDraw
{
    [self.sentinel increase];
}


@end
