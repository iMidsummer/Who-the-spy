//
//  Player.m
//  Who_the_spy
//
//  Created by charles wong on 14-4-9.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithID:(int)ID Role:(int)role Word:(NSString *)word
{
    if(self = [super init])
    {
        self.ID = ID;
        self.role = role;
        self.wordInHand = word;
        if(role == PR_Civilian)
            self.roleImage = @"goodguy.png";
        else if(role == PR_Spy)
            self.roleImage = @"spy.png";
        else
            self.roleImage = @"white.png";
            
    }
    return self;
}

@end
