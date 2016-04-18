//
//  CornerView.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/3/21.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    IncLabelType_None,
    IncLabelType_Solid,
    IncLabelType_Hollow,
}IncLabelType;

@interface CornerView : UIView
/**
 *  image和Label共有属性
 */
@property(nonatomic)CGFloat cornerRadius;
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic)CGFloat borderWidth;

/**
 *  image属性
 */
@property(nonatomic, strong)UIImage *backgroundImage;
@property(nonatomic, assign) BOOL isCircle;

/**
 *  label属性
 */
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic)IncLabelType labelType;
@property(nonatomic, strong)UIColor *labelBackGroundColor;

//optional
@property(nonatomic)BOOL usedSystemDefault;


@end
