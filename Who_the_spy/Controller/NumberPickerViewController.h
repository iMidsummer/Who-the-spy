//
//  NumberPickerViewController.h
//  Who the spy
//
//  Created by charles wong on 14-4-8.
//  Copyright (c) 2014年 charles wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberPickerDelegate <NSObject>
@optional
- (void)didSelectNumber:(int)number;
@end

@interface NumberPickerViewController : UIViewController

@property (nonatomic, copy) NSString * title;
@property (nonatomic, weak) id<NumberPickerDelegate> delegate;

- (id)initWithRangeStart:(int)startNum End:(int)endNum InitSelectedNum:(int)initSelected;

@end
