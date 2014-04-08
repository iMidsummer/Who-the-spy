//
//  NumberPickerViewController.m
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "NumberPickerViewController.h"

@interface NumberPickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) int startNum;
@property (nonatomic, assign) int endNum;
@property (nonatomic, assign) int selectedRowIndex;

@end

@implementation NumberPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRangeStart:(int)startNum End:(int)endNum InitSelectedNum:(int)initSelected
{
    if(self = [super init])
    {
        if(startNum > endNum)
            startNum = endNum = 0;
        if(initSelected > endNum || initSelected < startNum)
            initSelected = startNum;
        
        self.startNum = startNum;
        self.endNum = endNum;
        self.selectedRowIndex = initSelected - startNum;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self.navigationItem setTitle:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectNumber:)])
        [self.delegate  didSelectNumber:(self.selectedRowIndex + self.startNum)];
}

- (void)viewWillLayoutSubviews
{
    self.tableView.frame = self.view.bounds;
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.endNum - self.startNum + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MyIdentifier = @"NumberPickerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%i人", self.startNum+indexPath.row];
    if(self.selectedRowIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    [tableView reloadData];
    
//    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectNumber:)])
//        [self.delegate  didSelectNumber:(self.selectedRowIndex + self.startNum)];
}

@end
