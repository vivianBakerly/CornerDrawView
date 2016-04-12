//
//  FMRadiusDrawProtocol.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FMRadiusDrawProtocol <NSObject>

@required
@property(nonatomic)CGFloat cornerRadius;
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic)CGFloat borderWidth;

@optional
@property(nonatomic, assign) BOOL maskToBound;
@property(nonatomic)BOOL usedSystemDefault;
@end
