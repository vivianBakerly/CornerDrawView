//
//  FMRadiusImageView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMRadiusImageView.h"
#import "UIImage+DrawRadius.h"
#import <libkern/OSAtomic.h>

@interface FMRadiusImageView()
/**
 *  value:     每次绘制任务的唯一标识符
 *  resultImg:
 */
@property(nonatomic, assign)int32_t value;
@property(nonatomic, strong)UIImageView *resultImg;

//下层图片，用于边框，borderWidth决定是否绘制，frame和borderColor, cornerRadius决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerBorderImage;
//上层图片，用于传入的图片，frame, cornerRadius, borderWidth决定是否重新绘制
@property(nonatomic, strong)UIImage *cornerUserImage;
@property(nonatomic, strong)FMRadiusImageTask *lastTask;

@end
@implementation FMRadiusImageView

@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initSettings];
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if(self){
        [self initSettings];
    }
    return self;
}

- (void)setupWithCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andImage:(UIImage *)image
{
    self.borderColor = borderColor;
    self.borderWidth = borderWidth;
    self.cornerRadius = cornerRadius;
    self.image = image;
}

- (void)initSettings
{
    self.value = 0;
    _borderColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.resultImg];
}

#pragma mark 绘制
-(void)p_drawWithImageWithTask:(FMRadiusImageTask *)draftTask
{
    int32_t value = self.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.value) && (!self.image);
    };
    
    dispatch_async(getRadiusDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        
        BOOL needRedrawUserImage = [self needRedrawUserImageCompareTo:draftTask];
        BOOL needRedrawCornerImage = [self needRedrawCornerImageCompareTo:draftTask];
        
        if(needRedrawCornerImage || needRedrawUserImage){
            CGRect drawFrame = self.resultImg.frame;
            //上层图片
            UIImage *final;
            UIImage *top = (needRedrawUserImage) ?  [UIImage drawCornerRadiusWithBgImg:self.image withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.cornerUserImage;
            UIImage *bg;
            if(self.borderWidth > 0 && !isCancelled()){
                //下层图片，用于边框
                bg = (needRedrawCornerImage) ? [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.cornerBorderImage;
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
                self.lastTask = draftTask;
            });
        }
    });
}

#pragma -mark 是否需要重绘
-(BOOL)needRedrawUserImageCompareTo:(FMRadiusImageTask *)currentTask
{
    if([self p_mustRedraw:currentTask]){
        return YES;
    }
    
    if(self.lastTask.borderWidth != currentTask.borderWidth){
        return YES;
    }
    
    if(self.lastTask.image != currentTask.image){
        return YES;
    }
    return NO;
}

- (BOOL)needRedrawCornerImageCompareTo:(FMRadiusImageTask *)currentTask
{
    if([self p_mustRedraw:currentTask]){
        return YES;
    }
    if(currentTask.borderColor != self.lastTask.borderColor){
        return YES;
    }
    return NO;
}

- (BOOL)p_mustRedraw:(FMRadiusImageTask *)currentTask
{
    if(self.lastTask.cornerRadius != currentTask.cornerRadius){
        return YES;
    }
    
    CGRect a = self.lastTask.frame;
    CGRect b = currentTask.frame;
    if(!CGSizeEqualToSize(a.size, b.size) || !CGPointEqualToPoint(a.origin, b.origin)){
        return YES;
    }
    
    return NO;
}

#pragma -mark 开始 & 取消
-(void)startDraw
{
    [self p_drawWithImageWithTask:[[FMRadiusImageTask alloc] initWithFrame:self.frame andCornerRadius:self.cornerRadius andBorderWidth:self.borderWidth andImg:self.image andBorderColor:self.borderColor]];
}

- (void)p_cancelAsyncDraw
{
    OSAtomicIncrement32(&_value);
}

#pragma mark 属性
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        [self p_cancelAsyncDraw];
        _cornerRadius = cornerRadius;
        [self startDraw];
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if(_borderWidth != borderWidth && borderWidth >= 0){
        [self p_cancelAsyncDraw];
        _borderWidth = borderWidth;
        [self startDraw];
    }
}

-(void)setBorderColor:(UIColor *)borderColor
{
    if(borderColor && borderColor != _borderColor){
        [self p_cancelAsyncDraw];
        _borderColor = borderColor;
        [self startDraw];
    }
}

- (void)setIsCircle:(BOOL)isCircle
{
    [self p_cancelAsyncDraw];
    _isCircle = isCircle;
    if(isCircle){
        CGSize size = self.bounds.size;
        //取小的值, 避免裁剪过度
        self.cornerRadius = (size.width <= size.height) ? size.width : size.height;
    }
    [self startDraw];
}

- (void)setImage:(UIImage *)image
{
    if(image){
        [self p_cancelAsyncDraw];
        _image = image;
        [self startDraw];
    }
}

-(void)setFrame:(CGRect)frame{
    [self p_cancelAsyncDraw];
    [super setFrame:frame];
    [self startDraw];
}

@end

@implementation FMRadiusImageTask
-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andImg:(UIImage *)image andBorderColor:(UIColor *)borderColor
{
    self = [super init];
    if(self){
        self.frame = frame;
        self.cornerRadius = cornerRadius;
        self.borderWidth = borderWidth;
        self.image = image;
        self.borderColor = borderColor;
    }
    return self;
}
@end
