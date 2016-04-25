//
//  FMRadiusTask.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/25.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMRadiusImageTask.h"

@interface FMRadiusImageTask ()

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
