//
//  FMComparisonLabelCell.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/19.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMComparisonLabelCell.h"
#import "FMRadiusLabel.h"
#import "UIImage+DrawRadius.h"
static const NSUInteger kElementInRow = 6;
static const CGFloat kGapBetweenElement = 3;
@interface FMComparisonLabelCell()
@property (nonatomic, strong)NSArray *labelsArray;

@end
@implementation FMComparisonLabelCell

+(NSString *)identifier
{
    return @"FMCELLID_COMPARISON_LABEL";
}

+(CGFloat)heightForRow
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - kGapBetweenElement * (kElementInRow + 1))/ kElementInRow;
    return width * 0.5 + 10;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - kGapBetweenElement * (kElementInRow + 1))/ kElementInRow;
        NSMutableArray *tempArray = [NSMutableArray new];
        for(int i = 0; i < kElementInRow ; i++){
            FMRadiusLabel *imgView = [[FMRadiusLabel alloc] initWithFrame:CGRectMake(width * i + kGapBetweenElement * (i + 1), 5, width, width * 0.5)];
            imgView.cornerRadius = imgView.frame.size.width / 4;
            imgView.borderColor = [UIColor yellowColor];
            imgView.borderWidth = 2;
            imgView.labelBgColor = [UIColor blackColor];
            imgView.textColor = [UIColor yellowColor];
            [self addSubview:imgView];
            [tempArray addObject:imgView];
        }
        self.labelsArray = [tempArray copy];
    }
    return self;
}

-(void)setupItemWithSwitcher:(BOOL)useSystemDefault
{
    for(int i = 0; i < kElementInRow ; i++){
        FMRadiusLabel *label = self.labelsArray[i];
        label.usedSystemDefault = useSystemDefault;
        label.text = [[NSString alloc] initWithFormat:@"%d", [UIImage randomNumberStartFrom:0 ToEnd:17]];
    }
}

@end
