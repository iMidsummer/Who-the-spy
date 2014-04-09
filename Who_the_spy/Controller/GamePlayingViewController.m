//
//  GamePlayingViewController.m
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "GamePlayingViewController.h"
#import "SpyGame.h"
#import "Player.h"

typedef enum
{
    AV_ShowWord,
    AV_ConfirmKilling
} AlertViewType;

@interface GamePlayingViewController ()<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView * previewWordView;
@property (nonatomic, strong) IBOutlet UIImageView * playerIDImageView;
@property (nonatomic, strong) IBOutlet UILabel * promotLabel;
@property (nonatomic, strong) UITableView * playerListTableView;
@property (nonatomic, strong) UILabel * notifyLable;
@property (nonatomic, strong) SpyGame * spyGame;
@property (nonatomic, assign) int curPreviewPlayIndex;
@property (nonatomic, assign) int curSelectedToKillPlayerIndex;

- (IBAction)onShowWordBtnClicked:(id)sender;

@end

@implementation GamePlayingViewController

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
    self.playerListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.playerListTableView.dataSource = self;
    self.playerListTableView.delegate = self;
    [self.view addSubview:self.playerListTableView];
    
    self.notifyLable = [[UILabel alloc] init];
    self.notifyLable.frame = CGRectMake(0, 0, self.playerListTableView.bounds.size.width, 30);
    self.notifyLable.backgroundColor = [UIColor clearColor];
    self.notifyLable.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
    [self.notifyLable setTextAlignment:NSTextAlignmentLeft];
    [self.playerListTableView setTableHeaderView:self.notifyLable];
    
    [self.playerListTableView setHidden:YES];
    [self.previewWordView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
}

- (void)initGameWithTotalPlayerNum:(int)totalPlayerNum SpyNum:(int)spyNum whiteboardNum:(int)whiteboardNum LoseNum:(int)loseNum
{
    self.spyGame = [[SpyGame alloc] initWithTotalPlayersNum:totalPlayerNum SpyNum:spyNum whiteBoardsNum:whiteboardNum LoseNum:loseNum];
    self.curPreviewPlayIndex = 0;
    [self showNextPreviewPlayer];
}

- (void)showNextPreviewPlayer
{
    self.curPreviewPlayIndex++;
    if(self.curPreviewPlayIndex <= [self.spyGame totalPlayersNum])
    {
        self.playerIDImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.png", self.curPreviewPlayIndex]];
        self.promotLabel.text = [NSString stringWithFormat:@"请把手机传给%i号玩家", self.curPreviewPlayIndex];
    }
    else
    {
        [self.playerListTableView setHidden:NO];
        [self.previewWordView setHidden:YES];
        self.notifyLable.text = [NSString stringWithFormat:@"   请选择被投票最多的玩家"];
        self.curSelectedToKillPlayerIndex = -1;
        [self.playerListTableView reloadData];
    }
}

- (NSString *)notificationForKilledPlayer:(Player *)killedPlayer
{
    //卧底还在, 游戏继续~
    
    NSString * notifyString;
    
    if(killedPlayer.role == PR_Civilian)
        notifyString = [NSString stringWithFormat:@"   %i号被冤死!", killedPlayer.ID];
    else if(killedPlayer.role == PR_WhiteBoard)
        notifyString = [NSString stringWithFormat:@"   %i号是白板!", killedPlayer.ID];
    else
        notifyString = [NSString stringWithFormat:@"   %i号是卧底!", killedPlayer.ID];
    
    GameState state = [self.spyGame currentGameState];
    if(state == SG_Killing)
    {
        int spyLeftNum = [self.spyGame spyAliveNum];
        int whiteLeftNum = [self.spyGame whileBoardAliveNum];
        if(spyLeftNum > 0)
        {
            notifyString = [notifyString stringByAppendingString:[NSString stringWithFormat:@"还有%i卧底", spyLeftNum]];
            if(whiteLeftNum > 0)
                notifyString = [notifyString stringByAppendingString:[NSString stringWithFormat:@"和%i白板, ", whiteLeftNum]];
            else
                notifyString = [notifyString stringByAppendingString:@", "];
        }
        else if(whiteLeftNum > 0)
            notifyString = [notifyString stringByAppendingString:[NSString stringWithFormat:@"还有%i白板, ", whiteLeftNum]];
        
        notifyString = [notifyString stringByAppendingString:@"游戏继续~"];
    }
    else if(state == SG_Win)
    {
        notifyString = [notifyString stringByAppendingString:@"大部队胜利! 游戏结束~"];
    }
    else
    {
        notifyString = [notifyString stringByAppendingString:@"卧底胜利! 游戏结束~"];
    }
    
    return notifyString;
}

#pragma -mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GameState state = [self.spyGame currentGameState];
    if(state == SG_Killing)
        return [self.spyGame playersAliveNum];
    else if(state == SG_Win || state == SG_Failed)
        return [self.spyGame totalPlayersNum];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    GameState state = [self.spyGame currentGameState];
    if(state == SG_Killing)
    {
        static NSString * MyKillingCellIdentifier = @"KillingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:MyKillingCellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyKillingCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        Player * player = [[self.spyGame alivePlayersInfo] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%i号", player.ID];
        
        if(self.curSelectedToKillPlayerIndex == indexPath.row)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(state == SG_Win || state == SG_Failed)
    {
        static NSString * MyInfoListCellIdentifier = @"PlayerInfoListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:MyInfoListCellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyInfoListCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        Player * player = [[self.spyGame allPlayersInfo] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:player.roleImage];
        cell.textLabel.text = [NSString stringWithFormat:@"%i号", player.ID];
        cell.detailTextLabel.text = player.wordInHand;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameState state = [self.spyGame currentGameState];
    if(state == SG_Killing)
    {
        if(indexPath.row != self.curSelectedToKillPlayerIndex)
        {
            UITableViewCell * lastCheckedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curSelectedToKillPlayerIndex inSection:0]];
            UITableViewCell * nextCheckCell = [tableView cellForRowAtIndexPath:indexPath];
            lastCheckedCell.accessoryType = UITableViewCellAccessoryNone;
            nextCheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.curSelectedToKillPlayerIndex = indexPath.row;
        }
        
        Player * player = [[self.spyGame alivePlayersInfo] objectAtIndex:self.curSelectedToKillPlayerIndex];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: [NSString stringWithFormat:@"确认票出%i号？", player.ID]
														   delegate: self
												  cancelButtonTitle: @"取消"
												  otherButtonTitles: @"确定", nil];
        alertView.tag = AV_ConfirmKilling;
        [alertView show];
    }
}

#pragma -mark alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == AV_ShowWord)
    {
        [self showNextPreviewPlayer];
    }
    else if(alertView.tag == AV_ConfirmKilling)
    {
        if(buttonIndex == 1)
        {
            //confirm killing
            Player * killedPlayer = [self.spyGame killPlayerAtIndex:self.curSelectedToKillPlayerIndex];
            NSString * notify = [self notificationForKilledPlayer:killedPlayer];
            self.notifyLable.text = notify;
            self.curSelectedToKillPlayerIndex = -1;
            [self.playerListTableView reloadData];
        }
        
    }
}

#pragma -mark interaction
- (IBAction)onShowWordBtnClicked:(id)sender
{
    if(self.curPreviewPlayIndex <= [self.spyGame totalPlayersNum])
    {
        NSString * word = [self.spyGame wordForPlayerAtIndex:self.curPreviewPlayIndex-1];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @""
															message: word
														   delegate: self
												  cancelButtonTitle: @"记住了"
												  otherButtonTitles: nil];
        alertView.tag = AV_ShowWord;
		[alertView show];
    }
}

#pragma mark - utility
// utility routine to display aleart view
- (void)displayAlertViewOnMainQueueWithTitle:(NSString *) title Message:(NSString *)message cancelButtonTitle:(NSString *)buttonString
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
															message: message
														   delegate: self
												  cancelButtonTitle: buttonString
												  otherButtonTitles: nil];
		[alertView show];
	});
}

@end
