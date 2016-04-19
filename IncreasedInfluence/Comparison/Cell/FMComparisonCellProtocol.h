//
//  FMComparisonCellProtocol.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/19.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMComparisonCellProtocol <NSObject>

@required
+(NSString *)identifier;
+(CGFloat)heightForRow;

-(void)setupItemWithSwitcher:(BOOL)useSystemDefault;
@end
