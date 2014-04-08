//
//  DataManager.m
//  Who the spy
//
//  Created by charles wong on 14-4-7.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import "DataManager.h"
#import "WordPair.h"
#import <sqlite3.h>

@interface DataManager()
{
    sqlite3 * _Database;
}

@end

@implementation DataManager

+ (DataManager *)sharedManager
{
    static DataManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

- (id)init
{
    if(self = [super init])
    {
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask ,YES) objectAtIndex:0];
        NSString * sqliteDBPath = [documentPath stringByAppendingPathComponent:@"sswd.sqlite"];
        if(sqlite3_open([sqliteDBPath UTF8String], &_Database) != SQLITE_OK)
            NSLog(@"Failed to open database.\n");
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_Database);
}

- (NSArray *)wordPairs
{
    NSMutableArray * rstArray = [[NSMutableArray alloc] init];
    NSString * query = [NSString stringWithFormat:
                        @"select id, first_word, second_word from game_word"];
    sqlite3_stmt * statement;
    if(sqlite3_prepare_v2(_Database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int uniqueID = sqlite3_column_int(statement, 0);
            char * firstWordChars = (char *)sqlite3_column_text(statement, 1);
            char * secondWordChars = (char *)sqlite3_column_text(statement, 2);
            NSString * firstWord = [NSString stringWithUTF8String:firstWordChars];
            NSString * secondWord = [NSString stringWithUTF8String:secondWordChars];
            WordPair * wordPair = [[WordPair alloc] initWithUniqueId:uniqueID firstWord:firstWord secondWord:secondWord];
            [rstArray addObject:wordPair];
        }
        sqlite3_finalize(statement);
    }
    return rstArray;
}

@end
