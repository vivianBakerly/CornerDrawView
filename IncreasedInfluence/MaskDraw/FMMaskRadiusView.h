//
//  FMMaskRadiusView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/5/9.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMMaskRadiusView : UIImageView

@property(nonatomic, assign)CGFloat cornerRadius;

-(instancetype)initWithCornerRadius:(CGFloat)cornerRadius andImage:(UIImage *)image andFrame:(CGRect)frame;
@end
