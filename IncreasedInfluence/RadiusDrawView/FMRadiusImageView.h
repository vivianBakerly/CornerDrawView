//
//  FMRadiusImageView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRadiusDrawProtocol.h"

#define useSetup 1

@interface FMRadiusImageView : UIView <FMRadiusDrawProtocol>

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, assign) BOOL isCircle;

- (void)setupWithCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andImage:(UIImage *)image;
@end
