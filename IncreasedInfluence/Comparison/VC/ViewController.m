//
//  ViewController.m
//  IncreasedInfluence
//
//  Created by isahuang on 16/3/21.
//  Copyright © 2016年 isahuang. All rights reserved.
//

#import "ViewController.h"
#import "IncTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic)BOOL usedSystemDefault;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.usedSystemDefault = YES;
    UISwitch *turnOn = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [turnOn addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:turnOn];
    self.navigationItem.rightBarButtonItem = searchButton;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark TableView
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [IncTableViewCell heightForItem:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[IncTableViewCell identifier]];
    if(nil == cell){
        cell = [[IncTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[IncTableViewCell identifier]];
    }
    cell.useSystemDefault = _usedSystemDefault;
    [cell setupItems];
    return cell;
}

- (void)switchMode:(id)sender
{
    _usedSystemDefault = !_usedSystemDefault;
    
    if (_usedSystemDefault) {
        self.title = @"System";
    }
    else
    {
        self.title = @"Custom";
    }
    
    [self.tableView reloadData];
}
@end
