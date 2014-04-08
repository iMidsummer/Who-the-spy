//
//  WordPair.m
//  Who the spy
//
//  Created by charles wong on 14-4-7.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "WordPair.h"

@implementation WordPair

- (id)initWithUniqueId:(int)uniqueID firstWord:(NSString *)firstWord secondWord:(NSString *)secondWord
{
    if(self = [super init])
    {
        self.uniqueID = uniqueID;
        self.firstWord = firstWord;
        self.secondWord = secondWord;
    }
    return self;
}

@end
