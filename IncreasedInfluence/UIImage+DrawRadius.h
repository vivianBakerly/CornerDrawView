//
//  UIImage+DrawRadius.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DrawRadius)

+ (UIImage *)drawCornerRadiusWithBgImg:(UIImage *)img withBorderWidth:(CGFloat)borderWidth andCorderRadius:(CGFloat)cornerRadius inFrame:(CGRect)frame;
+ (UIImage *)drawsolidRecInFrame:(CGRect)frame andfillWithColor:(UIColor *)color;
+ (UIImage *)mixTopImg:(UIImage *)topImg withBgImg:(UIImage *)bg inFrame:(CGRect)frame WithBorderWidth:(CGFloat)borderWidth;
@end
