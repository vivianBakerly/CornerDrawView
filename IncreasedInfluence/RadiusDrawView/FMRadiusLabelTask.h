//
//  FMRadiusLabelTask.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/25.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FMRadiusLabelTask : NSObject

@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic, assign)CGFloat borderWidth;
@property(nonatomic, assign)CGFloat cornerRadius;
@property(nonatomic, assign)CGRect frame;
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIColor *labelBgColor;


-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor andTextColor:(UIColor *)textColor andlabelBgColor:(UIColor *)labelBgColor andText:(NSString *)text;
@end
