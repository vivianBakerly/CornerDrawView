//
//  FMComparisonCell.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/18.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMComparisonCellProtocol.h"

@interface FMComparisonImageCell : UITableViewCell<FMComparisonCellProtocol>

+(NSString *)identifierForOriginType;
@end
