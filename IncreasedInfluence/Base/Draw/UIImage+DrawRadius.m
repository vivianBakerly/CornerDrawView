//
//  UIImage+DrawRadius.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "UIImage+DrawRadius.h"

@implementation UIImage (DrawRadius)

//把一个图片按照cornerRadius和borderWidth画成带边框圆角图片
+ (UIImage *)drawCornerRadiusWithBgImg:(UIImage *)img withBorderWidth:(CGFloat)borderWidth andCorderRadius:(CGFloat)cornerRadius inFrame:(CGRect)frame{
    CGSize size = CGSizeMake(frame.size.width - 2 * borderWidth, frame.size.height - 2 * borderWidth);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect bounds = CGRectMake(0, 0, frame.size.width - 2 * borderWidth, frame.size.height - 2 * borderWidth);
    [[UIColor clearColor] set];
    UIRectFill(bounds);
    
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius] addClip];
    UIImage *cornerImg = img;
    [cornerImg drawInRect:bounds];
    UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempImg;
}

//画实心方形图
+ (UIImage *)drawsolidRecInFrame:(CGRect)frame andfillWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    [color set];
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIRectFill(bounds);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//两张图片叠加
+ (UIImage *)mixTopImg:(UIImage *)topImg withBgImg:(UIImage *)bg inFrame:(CGRect)frame WithBorderWidth:(CGFloat)borderWidth{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    CGRect outerBounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    CGFloat width = borderWidth;
    CGRect innerBounds = CGRectMake(width, width, frame.size.width - 2 * width, frame.size.height - 2 * width);
    [bg drawInRect:outerBounds];
    [topImg drawInRect:innerBounds];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}

+ (int)randomNumberStartFrom: (int)base ToEnd: (int)top {
    if(base >= top){
        return base;
    }
    return (arc4random() % top) + base;
}
@end
