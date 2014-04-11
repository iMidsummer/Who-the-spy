//
//  GuessWordViewController.h
//  Who_the_spy
//
//  Created by wangchao on 14-4-10.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Player;
@class SpyGame;

@protocol GuessWordDelegate <NSObject>
@optional
- (void)didEndGuessing:(Player *)player IsSelfExposure:(BOOL)isSelfExposure;
@end

@interface GuessWordViewController : UIViewController

@property (nonatomic, weak) id<GuessWordDelegate> delegate;

- (id)initWithPlayer:(Player *)killedPlayer IsSelfExposure:(BOOL)isSelfExposure SpyGame:(SpyGame *)spyGame;

@end
