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
    self.backgroundColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.resultImg.backgroundColor =[UIColor clearColor];
    [self addSubview:self.resultImg];
}

#pragma mark override
- (void)setNeedsDisplay
{
    if(!self.usedSystemDefault){
        [self p_cancelAsyncDraw];
    }
    [super setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(!self.usedSystemDefault){
        [self beginDrawTextLabel];
    }
}
#pragma mark properties setting
- (void)setCornerRadius:(CGFloat)cornerRadius {
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        _cornerRadius = cornerRadius;
        if(!self.usedSystemDefault){
            [self setNeedsDisplay];
        }
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(_borderWidth != borderWidth && borderWidth >= 0){
        _borderWidth = borderWidth;
        if(!self.usedSystemDefault){
            [self setNeedsDisplay];
        }
    }
}

-(void)setBorderColor:(UIColor *)borderColor {
    if(borderColor && borderColor != _borderColor){
        _borderColor = borderColor;
        //颜色改变且有宽度时才绘制
        if(_borderWidth > 0){
            if(!self.usedSystemDefault){
                [self setNeedsDisplay];
            }
        }
    }
}

-(void)setUsedSystemDefault:(BOOL)usedSystemDefault{
    _usedSystemDefault = usedSystemDefault;
    if(usedSystemDefault){
        self.textLabel.layer.cornerRadius = self.cornerRadius;
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.layer.borderWidth = self.borderWidth;
        self.textLabel.layer.borderColor = self.borderColor.CGColor;
        self.textLabel.backgroundColor = self.labelBgColor;
    }else{
        self.textLabel.layer.cornerRadius = 0;
        self.textLabel.layer.masksToBounds = NO;
        self.textLabel.layer.borderWidth = 0;
        self.textLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    
}

-(void)setTextColor:(UIColor *)textColor {
    if(textColor && textColor != _textColor){
        _textColor = textColor;
        if(!self.usedSystemDefault){
            [self setNeedsDisplay];
        }
    }
}

-(void)setlabelBgColor:(UIColor *)labelBgColor
{
    if(labelBgColor && labelBgColor != _labelBgColor){
        _labelBgColor = labelBgColor;
        if(!self.usedSystemDefault){
            [self setNeedsDisplay];
        }
    }
}

-(void)setText:(NSString *)text {
    _text = text;
    if(!self.usedSystemDefault){
        [self setNeedsDisplay];
    }
}

-(void)beginDrawTextLabel
{
    if(self.usedSystemDefault){
        [self p_drawText];
    }else{
        if([self hasBorder]){
             [self p_drawWithImage: [UIImage drawsolidRecInFrame:self.resultImg.frame andfillWithColor:self.labelBgColor]];
        }else{
             [self p_drawWithImage:nil];
        }
    }
}

-(BOOL)hasBorder
{
    return (self.borderWidth > 0);
}

#pragma mark draw
-(void)p_drawWithImage:(UIImage *)img {
//    [self.sentinel increase];
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
            self.resultImg.image = final;
            [self p_drawText];
        });
    });
}


-(void)p_drawText {
    [self.textLabel removeFromSuperview];
    if(self.text.length > 0){
        UILabel *label = [[UILabel alloc] initWithFrame:self.resultImg.bounds];
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

- (void)p_cancelAsyncDraw
{
    [self.sentinel increase];
}
@end
