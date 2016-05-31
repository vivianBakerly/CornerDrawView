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

/** Explanation of private properties:
 *  identifier: the unique id for each draw task
 *  resultImg: the ImageView which represents the final mixed Images
 *  cornerBorderImage: Buttom Image(For Border): borderWidth, frame and borderColor, cornerRadius could decide whether it should be redraw.
 *  cornerUserImage: Upper Image(For customed Image): frame, cornerRadius, borderWidth could decide whether it should be redraw.
 *  lastTask: the last successful task
 */

@property(nonatomic, assign)int32_t identifier;
@property(nonatomic, strong)UIImageView *resultImg;
@property(nonatomic, strong)UIImage *cornerBorderImage;
@property(nonatomic, strong)UIImage *cornerUserImage;
@property(nonatomic, strong)FMRadiusImageTask *lastTask;

@end
@implementation FMRadiusImageView

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
    self.identifier = 0;
    _borderColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.resultImg];
}

#pragma mark 绘制
-(void)drawWithImageWithTask:(FMRadiusImageTask *)draftTask
{
    int32_t value = self.identifier;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.identifier) && (!self.image);
    };
    
    dispatch_async(getRadiusDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        
        BOOL needRedrawUserImage = [self needRedrawUserImageCompareTo:draftTask];
        BOOL needRedrawCornerImage = [self needRedrawCornerImageCompareTo:draftTask];
        if(needRedrawCornerImage || needRedrawUserImage){
            CGRect drawFrame = self.resultImg.frame;
            UIImage *final;
            UIImage *top = (needRedrawUserImage) ?  [UIImage drawCornerRadiusWithBgImg:self.image withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.cornerUserImage;
            UIImage *bg;
            if(self.borderWidth > 0 && !isCancelled()){
                //Buttom Image
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
    if([self mustRedraw:currentTask]){
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
    if([self mustRedraw:currentTask]){
        return YES;
    }
    if(currentTask.borderColor != self.lastTask.borderColor){
        return YES;
    }
    return NO;
}

- (BOOL)mustRedraw:(FMRadiusImageTask *)currentTask
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
    [self drawWithImageWithTask:[[FMRadiusImageTask alloc] initWithFrame:self.frame andCornerRadius:self.cornerRadius andBorderWidth:self.borderWidth andImg:self.image andBorderColor:self.borderColor]];
}

- (void)cancelAsyncDraw
{
    OSAtomicIncrement32(&_identifier);
}

#pragma mark 属性
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        [self cancelAsyncDraw];
        _cornerRadius = cornerRadius;
        [self startDraw];
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if(_borderWidth != borderWidth && borderWidth >= 0){
        [self cancelAsyncDraw];
        _borderWidth = borderWidth;
        [self startDraw];
    }
}

-(void)setBorderColor:(UIColor *)borderColor
{
    if(borderColor && borderColor != _borderColor){
        [self cancelAsyncDraw];
        _borderColor = borderColor;
        [self startDraw];
    }
}

- (void)setIsCircle:(BOOL)isCircle
{
    [self cancelAsyncDraw];
    _isCircle = isCircle;
    if(isCircle){
        CGSize size = self.bounds.size;
        _cornerRadius = (size.width <= size.height) ? size.width : size.height;
    }
    [self startDraw];
}

- (void)setImage:(UIImage *)image
{
    if(image){
        [self cancelAsyncDraw];
        _image = image;
        [self startDraw];
    }
}

-(void)setFrame:(CGRect)frame{
    [self cancelAsyncDraw];
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
