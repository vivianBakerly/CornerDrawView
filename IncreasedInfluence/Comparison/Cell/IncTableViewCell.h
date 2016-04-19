//
//  IncTableViewCell.h
//  IncreasedInfluence
//
//  Created by isahuang on 16/3/21.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncTableViewCell : UITableViewCell

@property(nonatomic)BOOL useSystemDefault;


+(NSString *)identifier;
+(CGFloat)heightForItem:(id)item;
- (void)setupItems;
@end
