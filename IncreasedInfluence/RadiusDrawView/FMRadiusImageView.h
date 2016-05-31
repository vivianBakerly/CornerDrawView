//
//  FMRadiusImageView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
static dispatch_queue_t getRadiusDisplayQueue() {
    static dispatch_queue_t renderRadiusQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
            renderRadiusQueue = dispatch_queue_create("renderRadiusQueue", attr);
        } else {
            renderRadiusQueue = dispatch_queue_create("renderRadiusQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(renderRadiusQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        }
    });
    return renderRadiusQueue;
}

@interface FMRadiusImageView : UIView

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign) BOOL isCircle;
@property(nonatomic)CGFloat cornerRadius;
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic)CGFloat borderWidth;

- (void)setupWithCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andImage:(UIImage *)image;

@end

@interface FMRadiusImageTask : NSObject
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic, assign)CGFloat borderWidth;
@property(nonatomic, assign)CGFloat cornerRadius;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)CGRect frame;

-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andImg:(UIImage *)image andBorderColor:(UIColor *)borderColor;
@end
