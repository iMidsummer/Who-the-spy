//
//  GamePlayingViewController.m
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "GamePlayingViewController.h"
#import "SpyGame.h"

@interface GamePlayingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIView * previewWordView;
@property (nonatomic, strong) IBOutlet UIImageView * playerIDImageView;
@property (nonatomic, strong) IBOutlet UILabel * promotLabel;
@property (nonatomic, strong) SpyGame * spyGame;
@property (nonatomic, assign) int curPreviewPlayIndex;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

#pragma -mark alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self showNextPreviewPlayer];
}

#pragma -mark interaction
- (IBAction)onShowWordBtnClicked:(id)sender
{
    if(self.curPreviewPlayIndex <= [self.spyGame totalPlayersNum])
    {
        NSString * word = [self.spyGame wordForPlayerAtIndex:self.curPreviewPlayIndex-1];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
															message: word
														   delegate: self
												  cancelButtonTitle: @"记住了"
												  otherButtonTitles: nil];
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
