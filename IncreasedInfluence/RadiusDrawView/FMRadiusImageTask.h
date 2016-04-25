//
//  FMRadiusTask.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/25.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMRadiusImageTask : NSObject
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic, assign)CGFloat borderWidth;
@property(nonatomic, assign)CGFloat cornerRadius;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign)CGRect frame;


-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andImg:(UIImage *)image andBorderColor:(UIColor *)borderColor;
@end
