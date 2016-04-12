//
//  FMRadiusImageView.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "YYSentinel.h"
#import "FMRadiusImageView.h"
#import "FMRadiusDrawProtocol.h"
#import "UIImage+DrawRadius.h"

@interface FMRadiusImageView() <FMRadiusDrawProtocol>
@property(nonatomic, strong)YYSentinel *sentinel;
@property(nonatomic, strong)UIImageView *bgImgView;
@end
@implementation FMRadiusImageView

@synthesize cornerRadius = _cornerRadius;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

#pragma mark init
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        //
        self.usedSystemDefault = NO;
        //
        
        self.sentinel = [YYSentinel new];
        //default property
        self.borderColor = [UIColor clearColor];
        self.borderWidth = 0.0f;
        self.isCircle = NO;
        self.bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.bgImgView];
    }
    return self;
}

#pragma mark properties setting
-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    if(!self.usedSystemDefault){
        self.bgImgView.layer.cornerRadius = 0;
        self.bgImgView.layer.masksToBounds = NO;
    }else{
        self.bgImgView.layer.cornerRadius = cornerRadius;
        self.bgImgView.layer.masksToBounds = YES;
    }
}

-(void)setImage:(UIImage *)image {
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
