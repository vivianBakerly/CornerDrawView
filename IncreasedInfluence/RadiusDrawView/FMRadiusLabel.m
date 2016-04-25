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
#import "FMRadiusLabelTask.h"

@interface FMRadiusLabel()
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *resultImg;

@property(nonatomic, strong)UIImage *borderImage;
@property(nonatomic, strong)UIImage *upperImage;
@property(nonatomic, strong)UILabel *textLabel;

@property(nonatomic, assign)BOOL needReDrawText;
@property(nonatomic, strong)FMRadiusLabelTask *lastTask;
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
    self.font = [UIFont systemFontOfSize:14];
    self.backgroundColor = [UIColor clearColor];
    self.resultImg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.resultImg.contentMode = UIViewContentModeScaleAspectFit;
    self.resultImg.backgroundColor =[UIColor clearColor];
    [self addSubview:self.resultImg];
}

#pragma mark properties setting
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if(cornerRadius != _cornerRadius && (cornerRadius >= 0)){
        [self p_cancelAsyncDraw];
        _cornerRadius = cornerRadius;
        [self restartDraw];
    }
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    if(_borderWidth != borderWidth && borderWidth >= 0){
        [self p_cancelAsyncDraw];
        _borderWidth = borderWidth;
        [self restartDraw];
    }
}

-(void)setBorderColor:(UIColor *)borderColor
{
    if(borderColor && borderColor != _borderColor){
        [self p_cancelAsyncDraw];
        _borderColor = borderColor;
        [self restartDraw];
    }
}

-(void)setFont:(UIFont *)font
{
    if(font != _font){
        [self p_cancelAsyncDraw];
        _font = font;
        [self restartDraw];
    }
}

-(void)setTextColor:(UIColor *)textColor
{
    if(textColor && textColor != _textColor){
        [self p_cancelAsyncDraw];
        _textColor = textColor;
        [self restartDraw];
    }
}

-(void)setlabelBgColor:(UIColor *)labelBgColor
{
    if(labelBgColor && labelBgColor != _labelBgColor){
        [self p_cancelAsyncDraw];
        _labelBgColor = labelBgColor;
        [self restartDraw];
    }
}

-(void)setText:(NSString *)text
{
    if(text && text != _text){
        [self p_cancelAsyncDraw];
        _text = text;
        [self restartDraw];
    }
}

-(void)beginDrawTextLabel
{
    if([self hasBorder]){
        [self p_drawWithImage: [UIImage drawsolidRecInFrame:self.resultImg.frame andfillWithColor:self.labelBgColor] andCurrentTask:[self createCurrentTask]];
    }else{
        [self p_drawWithImage:nil andCurrentTask:[self createCurrentTask]];
    }
}

- (FMRadiusLabelTask *)createCurrentTask
{
    return [[FMRadiusLabelTask alloc] initWithFrame:self.frame andCornerRadius:self.cornerRadius andBorderWidth:self.borderWidth  andBorderColor:self.borderColor andTextColor:self.textColor andlabelBgColor:self.labelBgColor andText:self.text];
}

-(BOOL)hasBorder
{
    return (self.borderWidth > 0);
}

#pragma mark draw
-(void)p_drawWithImage:(UIImage *)img andCurrentTask:(FMRadiusLabelTask *)currentTask{
    int32_t value = self.sentinel.value;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.sentinel.value || self.text.length == 0);
    };
    
    dispatch_async(YYAsyncLayerGetDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        CGRect drawFrame = self.resultImg.frame;
        //上层图片
        BOOL needDrawUpper = [self needReDrawUpperImg:currentTask];
        BOOL needDrawBg = [self needReDrawBgImg:currentTask];
        
        if(needDrawBg || needDrawUpper){
            UIImage *final;
            UIImage *topImg = needDrawUpper ? [UIImage drawCornerRadiusWithBgImg:img withBorderWidth:self.borderWidth andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.upperImage;
            UIImage *bg;
            if([self hasBorder]){
                //下层图片，用于边框
                bg = needDrawBg ? [UIImage drawCornerRadiusWithBgImg:[UIImage drawsolidRecInFrame:drawFrame andfillWithColor:self.borderColor] withBorderWidth:0 andCorderRadius:self.cornerRadius inFrame:drawFrame] : self.borderImage;
                final = [UIImage mixTopImg:topImg withBgImg:bg inFrame:drawFrame WithBorderWidth:self.borderWidth];
            }else{
                final = topImg;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (isCancelled()) {
                    return;
                }
                self.resultImg.image = final;
                self.upperImage = topImg;
                self.borderImage = bg;
                self.lastTask = currentTask;
                [self p_drawText];
            });
        }
    });
}


-(BOOL)needReDrawBgImg:(FMRadiusLabelTask *)currentTask
{
    if(self.lastTask.cornerRadius != currentTask.cornerRadius){
        return YES;
    }
    
    CGRect a = self.lastTask.frame;
    CGRect b = currentTask.frame;
    
    if(!CGSizeEqualToSize(a.size, b.size) || !CGPointEqualToPoint(a.origin, b.origin)){
        return YES;
    }
    
    if(self.lastTask.borderColor != currentTask.borderColor){
        return YES;
    }
    
    return NO;
}

-(BOOL)needReDrawUpperImg:(FMRadiusLabelTask *)currentTask
{
    if(self.lastTask.cornerRadius != currentTask.cornerRadius){
        return YES;
    }
    
    CGRect a = self.lastTask.frame;
    CGRect b = currentTask.frame;
    
    if(!CGSizeEqualToSize(a.size, b.size) || !CGPointEqualToPoint(a.origin, b.origin)){
        return YES;
    }
    
    if(self.lastTask.borderWidth != currentTask.borderWidth){
        return YES;
    }
    
    if(self.lastTask.labelBgColor != currentTask.labelBgColor){
        return YES;
    }
    return NO;
}

- (BOOL)needReDrawText:(FMRadiusLabelTask *)currentTask
{
    if(self.lastTask.text != self.text){
        return YES;
    }

    //tbd font
    return NO;
}

-(void)restartDraw
{
    [self beginDrawTextLabel];
}

-(void)p_drawText {
    if(self.text.length > 0){
        [self.textLabel removeFromSuperview];
        UILabel *label = [[UILabel alloc] initWithFrame:self.resultImg.bounds];
        label.font = [UIFont systemFontOfSize:14];
        label.text = self.text;
        label.textColor = self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
        self.textLabel = label;
        [self addSubview:self.textLabel];
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
