//
//  FMRadiusLabelTask.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/25.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMRadiusLabelTask.h"

@implementation FMRadiusLabelTask

-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andTextColor:(UIColor *)textColor andlabelBgColor:(UIColor *)labelBgColor andText:(NSString *)text
{
    self = [super init];
    if(self){
        self.frame = frame;
        self.cornerRadius = cornerRadius;
        self.borderWidth = borderWidth;
        self.borderColor = borderColor;
        self.textColor = textColor;
        self.text = text;
        self.labelBgColor = labelBgColor;
    }
    return self;
}
@end
