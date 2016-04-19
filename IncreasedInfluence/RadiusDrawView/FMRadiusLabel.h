//
//  FMRadiusLabelView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMRadiusDrawProtocol.h"

typedef enum : NSUInteger {
    FMLabelType_Solid,
    FMLabelType_Hollow,
}FMRadiusLabelType;

@interface FMRadiusLabel : UIView<FMRadiusDrawProtocol>

@property(nonatomic)FMRadiusLabelType labelType;
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIColor *backgroundColor;
@end
