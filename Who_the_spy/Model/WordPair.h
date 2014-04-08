//
//  WordPair.h
//  Who the spy
//
//  Created by charles wong on 14-4-7.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordPair : NSObject

@property (nonatomic, assign) int uniqueID;
@property (nonatomic, copy) NSString * firstWord;
@property (nonatomic, copy) NSString * secondWord;

- (id)initWithUniqueId:(int)uniqueID firstWord:(NSString *)firstWord secondWord:(NSString *)secondWord;

@end
