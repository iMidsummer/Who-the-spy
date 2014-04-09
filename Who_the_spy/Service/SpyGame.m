//
//  SpyGame.m
//  Who_the_spy
//
//  Created by charles wong on 14-4-9.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "SpyGame.h"
#import "Player.h"
#import "DataManager.h"
#import "WordPair.h"

@interface SpyGame()
{
    
}

@property (nonatomic, assign) GameState gameState;
@property (nonatomic, assign) int totalPlayerNum;
@property (nonatomic, assign) int spyNum;
@property (nonatomic, assign) int whiteBoardNum;
@property (nonatomic, assign) int loseNum;
@property (nonatomic, copy) NSString * spyWord;
@property (nonatomic, copy) NSString * civilianWord;
@property (nonatomic, strong) NSArray * allPlayers;
@property (nonatomic, strong) NSMutableArray * playersAliveArray;
@property (nonatomic, assign) int spyLeftNum;
@property (nonatomic, assign) int whiteBoardLeftNum;
@property (nonatomic, assign) int civilianLeftNum;

- (void)resetGame;

@end

@implementation SpyGame

- (id)initWithTotalPlayersNum:(int)totalPlayerNum SpyNum:(int)spyNum whiteBoardsNum:(int)whiteBoardNum LoseNum:(int)loseNum
{
    if(self = [super init])
    {
        self.totalPlayerNum = totalPlayerNum;
        self.spyNum = spyNum;
        self.whiteBoardNum = whiteBoardNum;
        self.loseNum = loseNum;
        [self resetGame];
    }
    return self;
}

- (void)resetGame
{
    //select a word pair
    NSArray * wordPairs = [[DataManager sharedManager] wordPairs];
    int pairIndex = arc4random() % [wordPairs count];
    pairIndex = 0;
    WordPair * selectedWordPair = wordPairs[pairIndex];
    
    //decide spy and civilian words
    if((arc4random() % 2) == 0)
    {
        self.spyWord = selectedWordPair.firstWord;
        self.civilianWord = selectedWordPair.secondWord;
    }
    else
    {
        self.spyWord = selectedWordPair.secondWord;
        self.civilianWord = selectedWordPair.firstWord;
    }
    
    //assign roles
    NSMutableArray * markArray = [[NSMutableArray alloc] initWithCapacity:self.totalPlayerNum];
    for(int i=0; i<self.spyNum; i++)
        [markArray addObject:[NSNumber numberWithInt:0]];
    for(int i=0; i<self.whiteBoardNum; i++)
        [markArray addObject:[NSNumber numberWithInt:1]];
    for(int i=(self.totalPlayerNum - self.spyNum - self.whiteBoardNum - 1); i>=0; i--)
        [markArray addObject:[NSNumber numberWithInt:2]];
    for(int i=0; i<self.totalPlayerNum; i++)
    {
        int swapIndex = arc4random() % (self.totalPlayerNum - i) + i;
        if(swapIndex != i)
        {
            NSNumber * tmpNum = [[markArray objectAtIndex:i] copy];
            [markArray replaceObjectAtIndex:i withObject:[markArray objectAtIndex:swapIndex]];
            [markArray replaceObjectAtIndex:swapIndex withObject:tmpNum];
        }
    }
    NSMutableArray * tmpRoleArray = [[NSMutableArray alloc] initWithCapacity:self.totalPlayerNum];
    for(int i=0; i<self.totalPlayerNum; i++)
    {
        int mark = [[markArray objectAtIndex:i] intValue];
        if(mark == 0)
            [tmpRoleArray addObject:[[Player alloc] initWithID:i+1 Role:PR_Spy Word:self.spyWord]];
        else if(mark == 1)
            [tmpRoleArray addObject:[[Player alloc] initWithID:i+1 Role:PR_WhiteBoard Word:@""]];
        else
            [tmpRoleArray addObject:[[Player alloc] initWithID:i+1 Role:PR_Civilian Word:self.civilianWord]];
    }
    self.allPlayers = [tmpRoleArray copy];
    self.playersAliveArray = [NSMutableArray arrayWithArray:tmpRoleArray];
    
    //init other params
    self.gameState = SG_Init_Done;
    self.spyLeftNum = self.spyNum;
    self.whiteBoardLeftNum = self.whiteBoardNum;
    self.civilianLeftNum = self.totalPlayerNum - self.spyNum - self.whiteBoardNum;
}

- (NSString *)wordForPlayerAtIndex:(int)playerIndex
{
    NSString * word = nil;
    if(self.gameState == SG_Init_Done)
    {
        if(playerIndex < 0 || playerIndex >= self.allPlayers.count)
            word = @"#^&_出错了";
        else
        {
            if(playerIndex == (self.allPlayers.count -1))
                self.gameState = SG_Killing;
            word = [[self.allPlayers objectAtIndex:playerIndex] wordInHand];
        }
    }
    return  word;
}

- (Player *)killPlayerAtIndex:(int)playerIndex
{
    Player * killedPlayer = nil;
    if(self.gameState == SG_Killing)
    {
        if(playerIndex < 0 || playerIndex >= self.playersAliveArray.count)
        {
            NSLog(@"Error playerIndex in killPlayerAtIndex (%d/%d)", playerIndex, self.playersAliveArray.count);
            return nil;
        }
        killedPlayer = [self.playersAliveArray objectAtIndex:playerIndex];
        [self.playersAliveArray removeObjectAtIndex:playerIndex];
        
        //update game statistics
        if(killedPlayer.role == PR_Civilian)
            self.civilianLeftNum--;
        else if(killedPlayer.role == PR_Spy)
            self.spyLeftNum--;
        else if(killedPlayer.role == PR_WhiteBoard)
            self.whiteBoardLeftNum--;
        
        if((self.spyLeftNum + self.whiteBoardNum) == 0)
            self.gameState = SG_Win;
        else if(self.civilianLeftNum < 0 ||(self.spyLeftNum + self.whiteBoardLeftNum + self.civilianLeftNum) <= self.loseNum)
            self.gameState = SG_Failed;
    }
    
    return killedPlayer;
}

- (NSArray *)allPlayersInfo
{
    return self.allPlayers;
}

- (NSArray *)alivePlayersInfo
{
    return self.playersAliveArray;
}

- (int)totalPlayersNum
{
    return self.totalPlayerNum;
}

- (int)playersAliveNum
{
    return self.playersAliveArray.count;
}

- (int)spyAliveNum
{
    return self.spyLeftNum;
}

- (int)whileBoardAliveNum
{
    return self.whiteBoardLeftNum;
}

- (GameState)currentGameState
{
    return self.gameState;
}

@end
