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
@property(nonatomic, strong)UIImageView *resultImg;

//borderWidth决定是否绘制，frame和borderColor, cornerRadius决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerBorderImage;
//frame, cornerRadius, borderWidth决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerUserImage;
@property(nonatomic, strong)NSMutableDictionary *cachedVariables;

@end
@implementation FMRadiusImageView

@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

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
    self.cachedVariables = [NSMutableDictionary new];
    self.isCircle = NO;
    self.borderColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
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
    [self p_drawWithImage];
}

#pragma mark properties setting
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        _cornerRadius = cornerRadius;
            [self setNeedsDisplay];
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(_borderWidth != borderWidth && borderWidth >= 0){
        _borderWidth = borderWidth;
            [self setNeedsDisplay];
    }
}

-(void)setBorderColor:(UIColor *)borderColor {
    if(!borderColor && borderColor != _borderColor){
        _borderColor = borderColor;
        //颜色改变且有宽度时才绘制
        if(_borderWidth > 0){
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
    [self setNeedsDisplay];
}

#pragma draw
-(void)p_drawWithImage {
//    [self.sentinel increase];
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value) && (!self.image);
    };
    
    dispatch_async(YYAsyncLayerGetDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        BOOL needRedrawUserImage = [self needRedrawUserImage];
        BOOL needRedrawCornerImage = [self needRedrawCornerImage];
        
        if(needRedrawCornerImage || needRedrawUserImage){
            CGRect drawFrame = self.resultImg.frame;
            //上层图片
            UIImage *final;
            UIImage *top = (self.needRedrawUserImage) ?  [UIImage drawCornerRadiusWithBgImg:self.image withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.cornerUserImage;
            UIImage *bg;
            if(self.borderWidth > 0){
                //下层图片，用于边框
                bg = (self.needRedrawCornerImage) ? [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.cornerBorderImage;
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
                [self cachedCurrentVariables];
                //            NSLog(@"CustomDefine: CornerRadius = %f, BorderWidth = %f", self.cornerRadius, self.borderWidth);
            });
        }
    });
}

- (void)cachedCurrentVariables
{
    self.cachedVariables[RadiusKBorderColor] = self.borderColor;
    self.cachedVariables[RadiusKBorderWidth] = @(self.borderWidth);
    self.cachedVariables[RadiusKFrame] = [NSValue valueWithCGRect:self.frame];
    self.cachedVariables[RadiusKCornerRadius] = @(self.cornerRadius);
    self.cachedVariables[RadiusKImage] = self.image;
}

-(BOOL)needRedrawUserImage {
//    return YES;
    if([self.cachedVariables[RadiusKCornerRadius] floatValue] != self.cornerRadius){
        return YES;
    }
    
    CGRect a = [self.cachedVariables[RadiusKFrame] CGRectValue];
    if(!CGSizeEqualToSize(a.size, self.frame.size) || !CGPointEqualToPoint(a.origin, self.frame.origin)){
        return YES;
    }
    
    if([self.cachedVariables[RadiusKBorderWidth] floatValue] != self.borderWidth){
        return YES;
    }
    
    if(self.cachedVariables[RadiusKImage] != self.image){
        return YES;
    }
    
    return NO;
}

//tbd: borderWidth
- (BOOL)needRedrawCornerImage {
//    return YES;
    if([self.cachedVariables[RadiusKCornerRadius] floatValue] != self.cornerRadius){
        return YES;
    }
    
    CGRect a = [self.cachedVariables[RadiusKFrame] CGRectValue];
    if(!CGSizeEqualToSize(a.size, self.frame.size) || !CGPointEqualToPoint(a.origin, self.frame.origin)){
        return YES;
    }
    
    if(self.cachedVariables[RadiusKBorderColor] != self.borderColor){
        return YES;
    }
    
    
    return NO;
}
- (void)p_cancelAsyncDraw
{
    [self.sentinel increase];
}

@end
