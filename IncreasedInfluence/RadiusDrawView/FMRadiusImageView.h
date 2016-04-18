//
//  FMRadiusImageView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRadiusDrawProtocol.h"

@interface FMRadiusImageView : UIView <FMRadiusDrawProtocol>

-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderColor:(UIColor *)borderColor andWithBorderWidth:(CGFloat)borderWidth;

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign) BOOL isCircle;
@end
