//
//  IncTableViewCell.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/3/21.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "IncTableViewCell.h"
#import "CornerView.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define AVATAR_WIDTH    60
#define SCORELABEL      20
#define VERSUSLABEL     40
#define TOPLABEL        10
@interface IncTableViewCell()
@property(nonatomic, strong)CornerView *versusLabel;
@property(nonatomic, strong)CornerView *avatar_1;
@property(nonatomic, strong)CornerView *avatar_2;

@property(nonatomic, strong)CornerView *scoreLabel_1;
@property(nonatomic, strong)CornerView *scoreLabel_2;

@property(nonatomic, strong)CornerView *topLabel;

@end

@implementation IncTableViewCell

+(NSString *)identifier {
    return @"RUID_IncTableViewCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib {

}

-(void)setUseSystemDefault:(BOOL)useSystemDefault {
    _useSystemDefault = useSystemDefault;
    self.versusLabel.usedSystemDefault = useSystemDefault;
    self.scoreLabel_1.usedSystemDefault = useSystemDefault;
    self.scoreLabel_2.usedSystemDefault = useSystemDefault;
    self.avatar_1.usedSystemDefault = useSystemDefault;
    self.avatar_2.usedSystemDefault = useSystemDefault;
    self.topLabel.usedSystemDefault = useSystemDefault;
}

- (void)initViews {
    [self initAvatars];
    [self initLabels];
}

- (void)initAvatars {
    CGFloat gap = 20;
    self.avatar_1 = [[CornerView alloc] initWithFrame:CGRectMake(gap, gap, AVATAR_WIDTH, AVATAR_WIDTH)];
    [self addSubview:self.avatar_1];
    self.avatar_2 = [[CornerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (gap + AVATAR_WIDTH), gap, AVATAR_WIDTH, AVATAR_WIDTH)];
    [self addSubview:self.avatar_2];
}

- (void)initLabels {
    CGFloat lineHeight = [IncTableViewCell heightForItem:nil];
    CGFloat versusX = SCREEN_WIDTH / 2 - (VERSUSLABEL / 2);
    
    self.topLabel = [[CornerView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - TOPLABEL * 3, lineHeight / 7 - TOPLABEL / 9, 6 * TOPLABEL, TOPLABEL * 1.7)];
    [self addSubview:self.topLabel];
    
    self.versusLabel = [[CornerView alloc] initWithFrame:CGRectMake(versusX, lineHeight / 2 - (VERSUSLABEL / 2), VERSUSLABEL, VERSUSLABEL)];
    [self addSubview:self.versusLabel];
    
    self.scoreLabel_1 = [[CornerView alloc] initWithFrame:CGRectMake(versusX - SCORELABEL * 3, lineHeight / 2 - SCORELABEL / 2, SCORELABEL, SCORELABEL)];
    [self addSubview:self.scoreLabel_1];
    
    self.scoreLabel_2 = [[CornerView alloc] initWithFrame:CGRectMake(versusX + VERSUSLABEL + SCORELABEL * 2, lineHeight / 2 - SCORELABEL / 2, SCORELABEL, SCORELABEL)];
    [self addSubview:self.scoreLabel_2];
}

- (void)setupLabel {
    self.topLabel.borderWidth = 2;
    self.topLabel.labelType = IncLabelType_Hollow;
    self.topLabel.cornerRadius = 2;
    self.topLabel.text = @"SCORE";
    
    self.scoreLabel_1.labelType = IncLabelType_Solid;
    self.scoreLabel_1.borderWidth = 0;
    self.versusLabel.borderWidth = 0;
    self.versusLabel.cornerRadius = (VERSUSLABEL / 2);
    self.versusLabel.backgroundImage = [UIImage imageNamed:@"Versus"];
    
    self.scoreLabel_1.labelType = IncLabelType_Solid;
    self.scoreLabel_2.labelType = IncLabelType_Solid;
    self.scoreLabel_1.borderWidth = 0;
    self.scoreLabel_2.borderWidth = 0;
    self.scoreLabel_1.cornerRadius = SCORELABEL / 2;
    self.scoreLabel_2.cornerRadius = SCORELABEL / 2;
    self.scoreLabel_1.text = [[NSString alloc] initWithFormat:@"%d",[self randomNumberStartFrom:0 ToEnd:20]];
    self.scoreLabel_2.text = [[NSString alloc] initWithFormat:@"%d",[self randomNumberStartFrom:0 ToEnd:20]];
}

- (void)setupItems {
    [self setupAvatar];
    [self setupLabel];
}

- (void)setupAvatar {
    self.avatar_1.borderWidth = 5;
    self.avatar_2.borderWidth = 5;
    NSString *avaName = [[NSString alloc] initWithFormat:@"Avatar_%d", [self randomNumberStartFrom:0 ToEnd:3]];
    self.avatar_1.cornerRadius = AVATAR_WIDTH / 2;
    self.avatar_1.backgroundImage = [UIImage imageNamed:avaName];
    NSString *avaName_1 = [[NSString alloc] initWithFormat:@"Avatar_%d", [self randomNumberStartFrom:0 ToEnd:3]];
    self.avatar_2.cornerRadius = AVATAR_WIDTH / 2;
    self.avatar_2.backgroundImage = [UIImage imageNamed:avaName_1];
}

- (int)randomNumberStartFrom: (int)base ToEnd: (int)top {
    if(base >= top){
        return base;
    }
    return (arc4random() % top) + base;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)heightForItem:(id)item;{
    return 100;
}
@end
