//
//  FWDraggablePlayerManager.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWSwipePlayerBackgroundView.h"
#import "FWSwipePlayerViewController.h"
#import "FWSwipePlayerConfig.h"
@class MovieDetailView;

extern NSString *FWSwipePlayerViewStateChange;

typedef enum _FWSwipeState {
    FWSwipeNone = 0,
    FWSwipeUp = 1,
    FWSwipeDown = 2,
    FWSwipeLeft = 3,
    FWSwipeRight = 4
} FWSwipeState;

@interface FWDraggablePlayerManager : NSObject<UIGestureRecognizerDelegate, FWPlayerDelegate>
@property (nonatomic, strong) FWSwipePlayerBackgroundView *backgroundView;
@property (nonatomic, strong) FWSwipePlayerViewController *playerController;
@property (nonatomic, assign) FWSwipeState swipeState;
@property (nonatomic, strong) MovieDetailView *detailView;

- (id)initWithInfo:(NSDictionary *)infoDict;
- (id)initWithInfo:(NSDictionary *)infoDict Config:(FWSwipePlayerConfig*)config;
- (id)initWithList:(NSArray *)dataList;
- (id)initWithList:(NSArray *)list Config:(FWSwipePlayerConfig*)config;
- (void)updateInfo:(NSDictionary *)infoDict;

- (void)showAtController:(UIViewController *)controller;
- (void)showAtView:(UIView *)view;
- (void)showAtControllerAndPlay:(UIViewController *)controller;
- (void)showAtViewAndPlay:(UIView *)view;

- (void)exit;
@end
