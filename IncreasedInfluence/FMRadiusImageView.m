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
    if(cornerRadius != _cornerRadius){
        _cornerRadius = (cornerRadius >= 0) ? cornerRadius : 0;
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
    if(_borderWidth != borderWidth){
        _borderWidth = (borderWidth >= 0) ? borderWidth : 0;
        self.needReDrawCornerUserImage = YES;
        self.needReDrawcornerBorderImage = NO;
        [self setNeedsDisplay];
    }
}

-(void)setBorderColor:(UIColor *)borderColor {
    if(borderColor != _borderColor){
        _borderColor = borderColor ? : [UIColor clearColor];
        //当有宽度时才重新绘制
        if(_borderWidth > 0){
            self.needReDrawCornerUserImage = NO;
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
        [self p_drawWithImage:image];
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
        if(self.needReDrawCornerUserImage){
            self.cornerUserImage = [UIImage drawCornerRadiusWithBgImg:img withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame];
        }
        if(self.needReDrawcornerBorderImage){
            //下层图片，用于边框
            UIImage *bg = [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame];
            self.cornerBorderImage = bg;
            final = [UIImage mixTopImg:self.cornerUserImage withBgImg:bg inFrame:drawFrame WithBorderWidth:self.borderWidth];
        }else{
            final = self.cornerUserImage;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.resultImg.image = final;
        });
    });
}

- (void)p_cancelAsyncDraw
{
    [self.sentinel increase];
}

- (BOOL)needDrawCornerBorderImage
{
    return (self.borderWidth > 0);
}

- (BOOL)needReDrawCornerBorderImage
{
    return YES;
}
@end
