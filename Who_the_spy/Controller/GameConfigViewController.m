//
//  GameConfigViewController.m
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "GameConfigViewController.h"
#import "NumberPickerViewController.h"

@interface GameConfigViewController ()<UITableViewDataSource, UITableViewDelegate, NumberPickerDelegate>

@property (nonatomic, strong) IBOutlet UITableView * configTableView;
@property (nonatomic, strong) NSMutableDictionary * configDict;
@property (nonatomic, strong) NSMutableDictionary * rangeDict;
@property (nonatomic, assign) int selectedRowIndex;

- (IBAction)onStartGameBtnClicked:(id)sender;

@end

@implementation GameConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray * titleArray = [NSMutableArray arrayWithObjects:@"游戏人数", @"卧底人数", @"白板人数", @"剩余几人卧底获胜", nil];
    NSMutableArray * valueArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:6],
                                                                   [NSNumber numberWithInt:1],
                                                                   [NSNumber numberWithInt:0],
                                                                    [NSNumber numberWithInt:3],nil];
    self.configDict = [NSMutableDictionary dictionaryWithDictionary:@{@"titles":titleArray, @"values":valueArray}];
    
    
    NSMutableArray * minArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:3],
                                                                   [NSNumber numberWithInt:1],
                                                                   [NSNumber numberWithInt:0],
                                                                   [NSNumber numberWithInt:2],nil];
    NSMutableArray * maxArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:20],
                                 [NSNumber numberWithInt:2],
                                 [NSNumber numberWithInt:1],
                                 [NSNumber numberWithInt:3],nil];
    self.rangeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"min":minArray, @"max":maxArray}];
    
    self.selectedRowIndex = -1;
    [self.navigationItem setTitle:@"手机主持"];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark interaction
- (IBAction)onStartGameBtnClicked:(id)sender
{
    NSLog(@"Clicked.\n");
}

#pragma -mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.configDict[@"titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * MyIdentifier = @"ConfigCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    }
    cell.textLabel.text = [self.configDict[@"titles"] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i人", [[self.configDict[@"values"] objectAtIndex:indexPath.row] intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    int min = [[self.rangeDict[@"min"] objectAtIndex:indexPath.row] intValue];
    int max = [[self.rangeDict[@"max"] objectAtIndex:indexPath.row] intValue];
    int initSelected = [[self.configDict[@"values"] objectAtIndex:indexPath.row] intValue];
    NSString * title = [self.configDict[@"titles"] objectAtIndex:indexPath.row];
    
    NumberPickerViewController * numPickerController = [[NumberPickerViewController alloc] initWithRangeStart:min End:max InitSelectedNum:initSelected];
    numPickerController.title = title;
    numPickerController.delegate = self;
    [self.navigationController pushViewController:numPickerController animated:YES];
}

#pragma -mark NumberPicker delegate
- (void)didSelectNumber:(int)number
{
    [self.configDict[@"values"] replaceObjectAtIndex:self.selectedRowIndex withObject:[NSNumber numberWithInt:number]];
    [self.configTableView reloadData];
}

@end
