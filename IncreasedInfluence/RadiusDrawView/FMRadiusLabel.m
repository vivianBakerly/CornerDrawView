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
@property(nonatomic, strong)UIImageView *resultImg;

@property(nonatomic, strong)UIImage *borderImage;
@property(nonatomic, strong)UIImage *upperImage;
@property(nonatomic, strong)UILabel *textLabel;

@property(nonatomic, strong)NSMutableDictionary *cachedVariables;
@property(nonatomic, assign)BOOL needReDrawBgImg;
@property(nonatomic, assign)BOOL needReDrawUpperImg;
@property(nonatomic, assign)BOOL needReDrawText;
@end

@implementation FMRadiusLabel

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

- (void)initSettings {
    self.sentinel = [YYSentinel new];
    self.borderColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.resultImg.backgroundColor =[UIColor clearColor];
    self.cachedVariables = [NSMutableDictionary new];
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
    [self beginDrawTextLabel];
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
    if(borderColor && borderColor != _borderColor){
        _borderColor = borderColor;
        //颜色改变且有宽度时才绘制
        if(_borderWidth > 0){
            [self setNeedsDisplay];
        }
    }
}

-(void)setTextColor:(UIColor *)textColor {
    if(textColor && textColor != _textColor){
        _textColor = textColor;
        [self setNeedsDisplay];
    }
}

-(void)setlabelBgColor:(UIColor *)labelBgColor
{
    if(labelBgColor && labelBgColor != _labelBgColor){
        _labelBgColor = labelBgColor;
        [self setNeedsDisplay];
    }
}

-(void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

-(void)beginDrawTextLabel
{
    if([self hasBorder]){
        [self p_drawWithImage: [UIImage drawsolidRecInFrame:self.resultImg.frame andfillWithColor:self.labelBgColor]];
    }else{
        [self p_drawWithImage:nil];
    }
}

-(BOOL)hasBorder
{
    return (self.borderWidth > 0);
}

#pragma mark draw
-(void)p_drawWithImage:(UIImage *)img {
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value);
    };
    
    dispatch_async(YYAsyncLayerGetDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        CGRect drawFrame = self.resultImg.frame;
        //上层图片
        UIImage *topImg = self.needReDrawUpperImg ? [UIImage drawCornerRadiusWithBgImg:img withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.upperImage;
        UIImage *final;
        UIImage *bg;
        if([self hasBorder]){
            //下层图片，用于边框
            bg = self.needReDrawBgImg ? [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.borderImage;
            final = [UIImage mixTopImg:topImg withBgImg:bg inFrame:drawFrame WithBorderWidth:self.borderWidth];
        }else{
            final = topImg;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.resultImg.image = final;
            //cache
            self.upperImage = topImg;
            self.borderImage = bg;
            [self p_drawText];
            
            [self cachedCurrentVariables];
        });
    });
}

- (void)cachedCurrentVariables
{
    self.cachedVariables[RadiusKBorderColor] = self.borderColor;
    self.cachedVariables[RadiusKBorderWidth] = @(self.borderWidth);
    self.cachedVariables[RadiusKFrame] = [NSValue valueWithCGRect:self.frame];
    self.cachedVariables[RadiusKCornerRadius] = @(self.cornerRadius);
    self.cachedVariables[RadiusKLabelText] = self.text;
    self.cachedVariables[RadiusKLabelTextColor] = self.textColor;
    self.cachedVariables[RadiusKLabelBgColor] = self.labelBgColor;
}

-(BOOL)needReDrawBgImg
{
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

-(BOOL)needReDrawUpperImg
{
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
    
    if(self.cachedVariables[RadiusKLabelBgColor] != self.labelBgColor){
        return YES;
    }
    return NO;
}

- (BOOL)needReDrawText
{
    if(self.cachedVariables[RadiusKLabelText] != self.text){
        return YES;
    }
    
    //tbd font
    return NO;
}
-(void)p_drawText {
    if(self.text.length > 0 && [self needReDrawText]){
        [self.textLabel removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:self.resultImg.bounds];
        label.font = [UIFont systemFontOfSize:14];
        label.text = self.text;
        label.textColor = self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
        self.textLabel = label;
        [self addSubview:self.textLabel];
    }else{
        //nothing
    }
}

- (void)p_cancelAsyncDraw
{
    [self.sentinel increase];
}

-(void)dealloc
{
    
}
@end
