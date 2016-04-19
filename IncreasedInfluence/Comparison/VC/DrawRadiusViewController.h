//
//  DrawRadiusViewController.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger{
    FMComparisonType_Img,
    FMComparisonType_Label,
}FMComparisonType;
@interface DrawRadiusViewController : UIViewController

@property(nonatomic, assign)FMComparisonType compareType;
@end
