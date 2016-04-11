//
//  FMRadiusLabelView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    FMLabelType_None,
    FMLabelType_Solid,
    FMLabelType_Hollow,
}FMLabelType;

@interface FMRadiusLabelView : UIView

@property(nonatomic)FMLabelType labelType;
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIColor *labelBackGroundColor;
@end
