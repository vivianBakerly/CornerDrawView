//
//  FMRadiusLabelView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRadiusDrawProtocol.h"

@interface FMRadiusLabel : UIView<FMRadiusDrawProtocol>

@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIColor *labelBgColor;
@end
