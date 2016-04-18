//
//  FMComparisonCell.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/18.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMComparisonCell : UITableViewCell

+(NSString *)identifier;
+(CGFloat)heightForRow;

-(void)setupItemWithSwitcher:(BOOL)useSystemDefault;
@end
