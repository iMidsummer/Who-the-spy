//
//  GamePlayingViewController.h
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamePlayingViewController : UIViewController

- (void)initGameWithTotalPlayerNum:(int)totalPlayerNum SpyNum:(int)spyNum whiteboardNum:(int)whiteboardNum LoseNum:(int)loseNum;

@end
