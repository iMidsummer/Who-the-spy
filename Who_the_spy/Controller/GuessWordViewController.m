//
//  GuessWordViewController.m
//  Who_the_spy
//
//  Created by wangchao on 14-4-10.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "GuessWordViewController.h"
#import "SpyGame.h"
#import "Player.h"

@interface GuessWordViewController ()

@property (nonatomic, strong) IBOutlet UILabel * promptLabel;
@property (nonatomic, strong) IBOutlet UITextField * textFiled;
@property (nonatomic, weak) SpyGame * spyGame;
@property (nonatomic, strong) Player * killedPlayer;
@property (nonatomic, assign) BOOL isSelfExposure;
@property (nonatomic, assign) int numOfChances;

- (IBAction)onGuessBtnClicked:(id)sender;

@end

@implementation GuessWordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPlayer:(Player *)killedPlayer IsSelfExposure:(BOOL)isSelfExposure SpyGame:(SpyGame *)spyGame
{
    if(self = [super init])
    {
        self.killedPlayer = killedPlayer;
        self.isSelfExposure = isSelfExposure;
        self.numOfChances = self.isSelfExposure?2:1;
        self.spyGame = spyGame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.promptLabel.text = [self promptString:self.killedPlayer];
    self.navigationItem.title = @"猜词";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"放弃" style:UIBarButtonItemStylePlain target:self action:@selector(giveUpGuessing:)];
    
    UIColor * backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"vc_bg.png"]];
    [self.view setBackgroundColor:backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)promptString:(Player *)player
{
    NSString * promptStr;
    if(player.role == PR_Spy)
        promptStr = [NSString stringWithFormat:@"%i号是卧底!", player.ID];
    else
        promptStr = [NSString stringWithFormat:@"%i号是白板!", player.ID];
    promptStr = [promptStr stringByAppendingString:[NSString stringWithFormat:@"还有%i次机会", self.numOfChances]];
    return promptStr;
}

- (void)giveUpGuessing:(id)sender
{
    [self.spyGame updateGameState];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didEndGuessing:IsSelfExposure:)])
        [self.delegate didEndGuessing:self.killedPlayer IsSelfExposure:self.isSelfExposure];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onGuessBtnClicked:(id)sender
{
    NSString * guessWord = [self.textFiled text];
    if(![guessWord isEqualToString:@""])
    {
        self.numOfChances--;
        if([self.spyGame judgeGuessWord:guessWord] || self.numOfChances <=0)
        {
            [self.spyGame updateGameState];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(didEndGuessing:IsSelfExposure:)])
                [self.delegate didEndGuessing:self.killedPlayer IsSelfExposure:self.isSelfExposure];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            self.promptLabel.textColor = [UIColor redColor];
            self.promptLabel.text = [self promptString:self.killedPlayer];
        }
    }
}

@end
