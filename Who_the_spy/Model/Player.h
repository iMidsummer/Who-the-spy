//
//  Player.h
//  Who_the_spy
//
//  Created by charles wong on 14-4-9.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    PR_Civilian,
    PR_WhiteBoard,
    PR_Spy
} PlayerRole;

@interface Player : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, assign) PlayerRole role;
@property (nonatomic, copy) NSString * wordInHand;
@property (nonatomic, copy) NSString * roleImage;

- (id)initWithID:(int)ID Role:(int)role Word:(NSString *)word;

@end
