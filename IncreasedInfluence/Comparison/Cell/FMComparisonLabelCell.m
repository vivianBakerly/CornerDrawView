
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
    return @"REUSEID_CUSTOM_LABEL";
}

+(NSString *)identifierForOriginType
{
    return @"REUSEID_ORIGIN_LABEL";
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
            if([reuseIdentifier isEqualToString:[FMComparisonLabelCell identifier]]){
                FMRadiusLabel *label = [[FMRadiusLabel alloc] initWithFrame:CGRectMake(width * i + kGapBetweenElement * (i + 1), 5, width, width * 0.5)];
                label.cornerRadius = label.frame.size.width / 4;
                label.borderColor = [UIColor yellowColor];
                label.borderWidth = 2;
                label.labelBgColor = [UIColor blackColor];
                label.textColor = [UIColor yellowColor];
                
                [self addSubview:label];
                [tempArray addObject:label];
            }else{
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i + kGapBetweenElement * (i + 1), 5, width, width * 0.5)];
                label.layer.cornerRadius = label.frame.size.width / 4;
                label.layer.borderColor = [UIColor yellowColor].CGColor;
                label.layer.borderWidth = 2;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor yellowColor];
                label.font = [UIFont systemFontOfSize:14];
                label.layer.masksToBounds = YES;
                label.backgroundColor = [UIColor blackColor];
                [self addSubview:label];
                [tempArray addObject:label];
            }
        }
        self.labelsArray = [tempArray copy];
    }
    return self;
}

-(void)setupItemWithSwitcher:(BOOL)useSystemDefault
{
    if(useSystemDefault){
        for(int i = 0; i < kElementInRow ; i++){
            UILabel *label = self.labelsArray[i];
            label.text = [[NSString alloc] initWithFormat:@"%d", [UIImage randomNumberStartFrom:0 ToEnd:17]];
        }
    }else{
        for(int i = 0; i < kElementInRow ; i++){
            FMRadiusLabel *label = self.labelsArray[i];
            label.text = [[NSString alloc] initWithFormat:@"%d", [UIImage randomNumberStartFrom:0 ToEnd:17]];
        }
    }
}

-(void)dealloc
{
    
}
@end
