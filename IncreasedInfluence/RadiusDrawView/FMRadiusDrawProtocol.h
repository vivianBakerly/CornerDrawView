//
//  FMRadiusDrawProtocol.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const RadiusKCornerRadius = @"RadiusKCornerRadius";
static NSString *const RadiusKBorderWidth = @"RadiusKBorderWidth";
static NSString *const RadiusKBorderColor = @"RadiusKBorderColor";
static NSString *const RadiusKFrame = @"RadiusKFrame";

static NSString *const RadiusKLabelBgColor = @"RadiusKLabelBgColor";
static NSString *const RadiusKLabelTextColor = @"RadiusKLabelTextColor";
static NSString *const RadiusKLabelText = @"RadiusKLabelText";

@protocol FMRadiusDrawProtocol <NSObject>

@required
@property(nonatomic)CGFloat cornerRadius;
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic)CGFloat borderWidth;

@optional
@property(nonatomic, assign) BOOL maskToBound;
@end
