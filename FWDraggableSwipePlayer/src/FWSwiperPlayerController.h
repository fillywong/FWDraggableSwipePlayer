//
//  FWSwiperPlayerController.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FWPlayerColorUtil.h"
#import "FWPlayerProgressSlider.h"
#import "FWSwipePlayerConfig.h"

extern NSString *FWSwipePlayerLockBtnOnclick;
extern NSString *FWSwipePlayerShareBtnOnclick;
extern NSString *FWSwipePlayerCollapseBtnOnclick;
extern NSString *FWSwipePlayerPlayBtnOnclick;
extern NSString *FWSwipePlayerFullScreenBtnOnclick;
extern NSString *FWSwipePlayerNextEpisodeBtnOnclick;
extern NSString *FWSwipePlayerVideoTypeBtnOnclick;
extern NSString *FWSwipePlayerEpisodeBtnOnclick;
extern NSString *FWSwipePlayerOnTap;
extern NSString *FWSwipePlayerSubtitleBtnOnclick;
extern NSString *FWSwipePlayerChannelBtnOnclick;
extern NSString *FWSwipePlayerViewStateChange;
extern NSString *FWSwipePlayerSettingBtnOnclick;
extern NSString *FWSwipePlayerDoneBtnOnclick;
extern NSString *FWSwipePlayerSettingViewCloseBtnOnclick;

typedef enum _FWPlayerMoveState {
    FWPlayerMoveNone = 0,
    FWPlayerMoveProgress = 1,
    FWPlayerMoveVolume  = 2,
    FWPlayerMoveBright  = 3
} FWPlayerMoveState;

@protocol FWPlayerDelegate <NSObject>

@optional
- (void)collapseBtnOnClick:(id)sender;
- (void)shareBtnOnClick:(id)sender;
- (void)tapInside:(id)sender;
- (void)playBtnOnClick:(id)sender;
- (void)fullScreenBtnOnClick:(id)sender;
- (void)nextEpisodeBtnOnClick:(id)sender;
- (void)videoTypeBtnOnClick:(id)sender;
- (void)lockScreenBtnOnClick:(id)sender;
- (void)episodeBtnOnClick:(id)sender;
- (void)subtitleBtnOnClick:(id)sender;
- (void)channelBtnOnClick:(id)sender;
- (void)didFinishPlay:(NSURL*)url;
- (void)doneBtnOnClick:(id)sender;
- (void)settingBtnOnClick:(id)sender;
- (void)settingViewCloseBtnOnClick:(id)sender;

@end

@interface FWSwiperPlayerController : MPMoviePlayerController<UIGestureRecognizerDelegate>

@property (nonatomic, assign)FWPlayerMoveState moveState;
@property (nonatomic, assign)id<FWPlayerDelegate> delegate;

- (id)initWithContentURL:(NSURL *)url;
- (id)initWithContentURL:(NSURL *)url andConfig:(FWSwipePlayerConfig*)config;
- (id)initWithContentDataList:(NSArray *)list;
- (id)initWithContentDataList:(NSArray *)list andConfig:(FWSwipePlayerConfig*)config;


- (void)hiddenControls;
- (void)showControls;
- (void)showControlsAndHiddenControlsAfter:(NSTimeInterval)time;
- (void)swipe:(id)sender;
- (void)updatePlayerFrame:(CGRect)rect;

- (void)play;
- (void)pause;
- (void)stop;
- (void)stopAndRemove;

- (void)playStartAt:(NSTimeInterval)time;

- (void)attachTo:(UIViewController*)controller;

@end
