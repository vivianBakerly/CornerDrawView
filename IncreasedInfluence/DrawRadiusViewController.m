//
//  DrawRadiusViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/11.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "DrawRadiusViewController.h"
#import "FMComparisonCell.h"
//#import "CornerRadiusMicro.h"

@interface DrawRadiusViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, assign)BOOL useSystemDefault;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation DrawRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_settingNavRightBtn];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.useSystemDefault = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_settingNavRightBtn
{
    UISwitch *setting = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [setting addTarget:self action:@selector(p_changeMode) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:setting];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)p_changeMode
{
    _useSystemDefault = !_useSystemDefault;
}

#pragma mark tableView protocol
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [FMComparisonCell identifier];
    FMComparisonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[FMComparisonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setupItem];
    return cell;
}
@end
