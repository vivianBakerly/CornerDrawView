//
//  FMEntryViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/4/18.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "FMEntryViewController.h"
#import "DrawRadiusViewController.h"
#import "FMSketchpadViewController.h"

typedef enum:NSUInteger {
    FMEntryViewControllerRowType_ComparisonImg = 0,
    FMEntryViewControllerRowType_Sketchpad,
    FMEntryViewControllerRowType_Count,
}FMEntryViewControllerRowType;

@interface FMEntryViewController()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *names;
@end

@implementation FMEntryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.names = @[@"Comparison(ImageViews)", @"Sketchpad"];
    self.title = @"Catalog";
    [self.view addSubview:self.tableView];
}

#pragma MARK tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return FMEntryViewControllerRowType_Count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row < self.names.count){
        CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, height)];
        nameLabel.text = self.names[indexPath.row];
        [cell addSubview:nameLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    switch (indexPath.row) {
        case FMEntryViewControllerRowType_Sketchpad:
        {
            vc = [[FMSketchpadViewController alloc] init];
        }
            break;
        case FMEntryViewControllerRowType_ComparisonImg:
        {
            vc = [[DrawRadiusViewController alloc] init];
        }
            break;
        default:
            break;
    }
    
    if(vc){
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
