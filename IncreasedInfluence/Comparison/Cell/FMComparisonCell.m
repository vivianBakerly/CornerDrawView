//
//  FMComparisonCell.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/18.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMComparisonCell.h"
#import "FMRadiusImageView.h"
static const NSUInteger kElementInRow = 5;
static const CGFloat kGapBetweenElement = 5;

@interface FMComparisonCell()
@property (nonatomic, strong)NSArray *imageViewArray;
@end
@implementation FMComparisonCell

+(NSString *)identifier
{
    return @"FMCELLID_COMPARISON";
}

+(CGFloat)heightForRow
{
    return [UIScreen mainScreen].bounds.size.width / kElementInRow + 20;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - kGapBetweenElement * (kElementInRow + 1))/ kElementInRow;
        NSMutableArray *tempArray = [NSMutableArray new];
        for(int i = 0; i < kElementInRow ; i++){
            FMRadiusImageView *imgView =[[FMRadiusImageView alloc] initWithFrame:CGRectMake(0, 10, width, width)];
            [self addSubview:imgView];
            [tempArray addObject:imgView];
        }
        self.imageViewArray = [tempArray copy];
    }
    return self;
}

@end
