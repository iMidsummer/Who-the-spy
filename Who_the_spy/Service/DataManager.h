//
//  DataManager.h
//  Who the spy
//
//  Created by charles wong on 14-4-7.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager;
- (NSArray *)wordPairs;

@end
