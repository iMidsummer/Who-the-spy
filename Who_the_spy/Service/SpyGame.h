//
//  SpyGame.h
//  Who_the_spy
//
//  Created by charles wong on 14-4-9.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

typedef enum
{
    SG_Init_Done,
    SG_Killing,
    SG_Failed,
    SG_Win
} GameState;

@interface SpyGame : NSObject

- (id)initWithTotalPlayersNum:(int)totalPlayerNum SpyNum:(int)spyNum whiteBoardsNum:(int)whiteBoardNum LoseNum:(int)loseNum;
- (NSString *)wordForPlayerAtIndex:(int)playerIndex;
- (Player *)killPlayerAtIndex:(int)playerIndex;
- (BOOL)judgeGuessWord:(NSString *)word;
- (void)updateGameState;
- (NSArray *)allPlayersInfo;
- (NSArray *)alivePlayersInfo;
- (int)totalPlayersNum;
- (int)playersAliveNum;
- (int)spyAliveNum;
- (int)whileBoardAliveNum;
- (GameState)currentGameState;

@end
