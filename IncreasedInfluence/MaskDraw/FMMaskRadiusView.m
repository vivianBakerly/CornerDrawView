//
//  FMMaskRadiusView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/5/9.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMMaskRadiusView.h"
#import "FMRadiusImageView.h"
#import <libkern/OSAtomic.h>

@interface FMMaskRadiusView()

@property (nonatomic, strong)FMRadiusImageTask *lastTask;
@property (nonatomic, assign)int32_t identifier;
@end
@implementation FMMaskRadiusView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.identifier = 0;
    }
    return self;
}

-(instancetype)initWithCornerRadius:(CGFloat)cornerRadius andImage:(UIImage *)image andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.cornerRadius = cornerRadius;
        self.image = image;
        [self startDraw];
    }
    return self;
}

- (void)setupCornerRadius:(CGFloat)cornerRadius andImage:(UIImage *)image andFrame:(CGRect)frame
{
    self.cornerRadius = cornerRadius;
    self.image = image;
    [self startDraw];
}

-(CAShapeLayer *)createMaskWithTask:(FMRadiusImageTask *)task
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGRect bounds = CGRectMake(0, 0, task.frame.size.width, task.frame.size.height);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:task.frame.size.width / 2];
    shapeLayer.path = aPath.CGPath;
    return shapeLayer;
}

-(void)startDraw
{
    OSAtomicIncrement32(&_identifier);
    FMRadiusImageTask *currentTask = [[FMRadiusImageTask alloc] initWithFrame:self.frame andCornerRadius:self.cornerRadius andBorderWidth:0 andImg:self.image andBorderColor:nil];
    [self p_drawWithImageWithTask:currentTask];
}

-(void)p_drawWithImageWithTask:(FMRadiusImageTask *)draftTask
{
    int32_t value = self.identifier;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.identifier);
    };
    
    dispatch_async(getRadiusDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        
        BOOL needRedraw = [self needRedrawWithCurrentTask:draftTask];
        if(needRedraw){
            CAShapeLayer *maskLayer = [self createMaskWithTask:draftTask];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (isCancelled()) {
                    return;
                }
                self.layer.mask = maskLayer;
                self.lastTask = draftTask;
            });
        }
    });
}


-(CAShapeLayer *)createMaskWithTask
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    shapeLayer.path = aPath.CGPath;
    return shapeLayer;
}

-(void)drawMask
{
      OSAtomicIncrement32(&_identifier);
    int32_t value = self.identifier;
    BOOL (^isCancelled)() = ^BOOL(){
        return (value != self.identifier);
    };
    
    dispatch_async(getRadiusDisplayQueue(), ^{
        if(isCancelled()){
            return;
        }
        CAShapeLayer *maskLayer = [self createMaskWithTask];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (isCancelled()) {
                return;
            }
            self.layer.mask = maskLayer;
        });
    });
}

-(BOOL)needRedrawWithCurrentTask:(FMRadiusImageTask *)currentTask
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
@end
