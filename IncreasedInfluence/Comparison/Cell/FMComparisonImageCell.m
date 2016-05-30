//
//  FMComparisonCell.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/18.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMComparisonImageCell.h"
#import "FMRadiusImageView.h"
#import "UIImage+DrawRadius.h"

static const NSUInteger kElementInRow = 5;
static const CGFloat kGapBetweenElement = 5;

@interface FMComparisonImageCell()
@property (nonatomic, strong)NSArray *imageViewArray;
@end
@implementation FMComparisonImageCell

+(NSString *)identifier
{
    return @"REUSEID_CUSTOM_IMG";
}

+(NSString *)identifierForOriginType
{
    return @"REUSEID_ORIGIN_IMG";
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
            if([reuseIdentifier isEqualToString:[FMComparisonImageCell identifierForOriginType]]){
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i + kGapBetweenElement * (i + 1), 10, width, width)];
                imgView.layer.cornerRadius = imgView.frame.size.width / 2;
                imgView.layer.borderColor = [UIColor yellowColor].CGColor;
                imgView.layer.borderWidth = 5;
                imgView.layer.masksToBounds = YES;
                imgView.layer.shouldRasterize = YES;
                imgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
                [self addSubview:imgView];
                [tempArray addObject:imgView];
            }else{
                FMRadiusImageView *imgView = [[FMRadiusImageView alloc] initWithFrame:CGRectMake(width * i + kGapBetweenElement * (i + 1), 10, width, width)];
                imgView.cornerRadius = imgView.frame.size.width / 2;
                imgView.borderColor = [UIColor yellowColor];
                imgView.borderWidth = 5;
                [self addSubview:imgView];
                [tempArray addObject:imgView];
            }
            
        }
        self.imageViewArray = [tempArray copy];
    }
    return self;
}

-(void)setupItemWithSwitcher:(BOOL)useSystemDefault
{
    if(useSystemDefault){
        for(int i = 0; i < kElementInRow ; i++){
            UIImageView *imgView = self.imageViewArray[i];
            imgView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"Avatar_%d", [UIImage randomNumberStartFrom:0 ToEnd:3]]];
        }
    }else{
        for(int i = 0; i < kElementInRow ; i++){
            FMRadiusImageView *imgView = self.imageViewArray[i];
            imgView.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"Avatar_%d", [UIImage randomNumberStartFrom:0 ToEnd:3]]];
        }
    }
}
@end
