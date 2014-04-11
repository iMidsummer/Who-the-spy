//
//  GuessWordViewController.h
//  Who_the_spy
//
//  Created by wangchao on 14-4-10.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuessWordDelegate <NSObject>
@optional
- (void)didEndGuessing;
@end

@class Player;
@class SpyGame;

@interface GuessWordViewController : UIViewController

@property (nonatomic, weak) id<GuessWordDelegate> delegate;

- (id)initWithPlayer:(Player *)killedPlayer NumofChances:(int)num SpyGame:(SpyGame *)spyGame;

@end
