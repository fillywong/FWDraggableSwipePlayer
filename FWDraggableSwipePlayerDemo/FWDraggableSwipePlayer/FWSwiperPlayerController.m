//
//  FWSwiperPlayerController.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwiperPlayerController.h"

NSString *FWSwipePlayerLockBtnOnclick = @"FWSwipePlayerLockBtnOnclick";
NSString *FWSwipePlayerShareBtnOnclick = @"FWSwipePlayerShareBtnOnclick";
NSString *FWSwipePlayerSettingBtnOnclick = @"FWSwipePlayerSettingBtnOnclick";
NSString *FWSwipePlayerCollapseBtnOnclick = @"FWSwipePlayerCollapseBtnOnclick";
NSString *FWSwipePlayerDoneBtnOnclick = @"FWSwipePlayerDoneBtnOnclick";
NSString *FWSwipePlayerPlayBtnOnclick = @"FWSwipePlayerPlayBtnOnclick";
NSString *FWSwipePlayerFullScreenBtnOnclick = @"FWSwipePlayerFullScreenBtnOnclick";
NSString *FWSwipePlayerNextEpisodeBtnOnclick = @"FWSwipePlayerNextEpisodeBtnOnclick";
NSString *FWSwipePlayerVideoTypeBtnOnclick = @"FWSwipePlayerVideoTypeBtnOnclick";
NSString *FWSwipePlayerSettingViewCloseBtnOnclick = @"FWSwipePlayerSettingViewCloseBtnOnclick";
NSString *FWSwipePlayerEpisodeBtnOnclick = @"FWSwipePlayerEpisodeBtnOnclick";
NSString *FWSwipePlayerSubtitleBtnOnclick = @"FWSwipePlayerSuntitleBtnOnclick";
NSString *FWSwipePlayerChannelBtnOnclick = @"FWSwipePlayerChannelBtnOnclick";
NSString *FWSwipePlayerOnTap = @"FWSwipePlayerOnTap";


@interface FWSwiperPlayerController()
{
    UIImageView *loadingBgImageViw;
    UIActivityIndicatorView *loadingActiviy;
    UILabel *loadingLabel;
    
    UIImageView *navView;
    UIButton *collapseBtn;
    UIButton *doneBtn;
    UIButton *shareBtn;
    UIButton *settingBtn;
    UIButton *lockScreenBtn;
    UILabel *titleLabel;
    
    UIImageView *bottomView;
    FWPlayerProgressSlider *sliderProgress;
    FWPlayerProgressSlider *cacheProgress;
    UILabel *currentPlayTimeLabel;
    UILabel *remainPlayTimeLabel;
    UIButton *fullScreenBtn;
    
    UIImageView *settingView;
    UIButton *settingViewCloseBtn;
    UIButton *episodeBtn;
    UIButton *chapterBtn;
    UIButton *subtitleBtn;
    UIButton *channelBtn;
    UIButton *videoTypeBtn;
    
    UIImageView *nextView;
    UILabel *nextEpisodeLabel;
    UIButton *nextEpisodeBtn;
    
    UIImageView *centerView;
    UIButton *playBtn;
    UIImageView *swipeView;
    UIImageView *middleBackground;
    UIImageView *middleImageView;
    UILabel *middleLabel;
    UILabel *progressLabel;
    
    BOOL isPlaying;
    BOOL isFullScreen;
    BOOL isAnimationing;
    BOOL isShowingCtrls;
    BOOL needToHideController;
    BOOL isLock;
    BOOL isSmall;
    BOOL isSettingViewShow;
    BOOL isLoading;
    
    float curVolume;
    float curPlaytime;
    
    FWSWipePlayerConfig * config;
    FWPlayerColorUtil *colorUtil;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    NSURL *currentVideoUrl;
    NSArray *videoList;
    
    UIPanGestureRecognizer *swipeRecognizer;
    UIViewController * attachViewController;
    
    NSTimer *bandwidthTimer;
}
@end

@implementation FWSwiperPlayerController

-(id)initWithContentURL:(NSURL *)url
{
    return [self initWithContentURL:url andConfig:[[FWSWipePlayerConfig alloc]init]];
}

- (id)initWithContentURL:(NSURL *)url andConfig:(FWSWipePlayerConfig*)configuration
{
    self = [super initWithContentURL:url];
    if(self)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        
        self.view.frame = CGRectMake(0, 0, screenHeight, screenHeight);
        currentVideoUrl = url;
        needToHideController = NO;
        isLock = NO;
        isSmall = NO;
        isLoading = YES;
        isSettingViewShow = NO;
        config = configuration;
        colorUtil = [[FWPlayerColorUtil alloc]init];
        self.moveState = FWPlayerMoveNone;
        [self configControls];
        [self showControls];
    }
    return self;
}

- (id)initWithContentDataList:(NSArray *)list
{
    return [self initWithContentDataList:list andConfig:[[FWSWipePlayerConfig alloc]init]];
}

- (id)initWithContentDataList:(NSArray *)list andConfig:(FWSWipePlayerConfig*)configuration
{
    if([list count] > 0)
    {
        self = [super initWithContentURL:[NSURL URLWithString: [list[0] objectForKey:@"url"]]];
        if(self)
        {
            videoList = list;
            
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            screenWidth = screenRect.size.width;
            screenHeight = screenRect.size.height;
            
            self.view.frame = CGRectMake(0, 0, screenHeight, screenHeight);
            currentVideoUrl = [NSURL URLWithString: [list[0] objectForKey:@"url"]];
            needToHideController = NO;
            isLock = NO;
            isSmall = NO;
            isLoading = YES;
            isSettingViewShow = NO;
            config = configuration;
            colorUtil = [[FWPlayerColorUtil alloc]init];
            self.moveState = FWPlayerMoveNone;
            [self configControls];
            [self showControls];
        }
        return self;
    }
    else
        return [self initWithContentURL:[NSURL URLWithString: @"http://techslides.com/demos/sample-videos/small.mp4"] andConfig:[[FWSWipePlayerConfig alloc]init]];
}



- (void)configControls {
    [self initMoviePlayer];
    [self configNavControls];
    [self configCenterControls];
    [self configPreloadPage];
    [self configBottomControls];
    [self configNextView];
    [self configSettingView];
}

-(void)initMoviePlayer
{
    [self setControlStyle:MPMovieControlStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDurationAvailableNotification:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiviy:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UIDeviceOrientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSwipePlayerViewStateChange:)
                                                 name:FWSwipePlayerViewStateChange object:nil];
    
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    control.backgroundColor = [UIColor clearColor];
    [control addTarget:self action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    if(!config.draggable)
    {
        swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)] ;
        [swipeRecognizer setMinimumNumberOfTouches:1];
        [swipeRecognizer setMaximumNumberOfTouches:1];
        [swipeRecognizer setDelegate:self];
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    
}

-(void)configCenterControls
{
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 - 100, config.topPlayerHeight/2 - 100, 200, 200)];
    centerView.userInteractionEnabled = NO;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    middleBackground = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 456 / 4) / 2, (screenHeight - 447 / 4) / 2, 456 / 4, 447 / 4)];
    [middleBackground setImage:[UIImage imageNamed:@"mini_middle_bg"]];
    middleBackground.backgroundColor = [UIColor clearColor];
    [middleBackground setHidden:YES];
    [self.view addSubview:middleBackground];
    
    middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, middleBackground.frame.size.width, 30)];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.font = [UIFont systemFontOfSize:12];
    middleLabel.textColor = [UIColor grayColor];
    middleLabel.text = NSLocalizedString(@"lightness",@"光度");
    [middleBackground addSubview:middleLabel];
    
    middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((middleBackground.frame.size.width - 35) / 2, (middleBackground.frame.size.height - 35) / 2, 70 / 2, 70/ 2)];
    [middleImageView setImage:[UIImage imageNamed:@"play_gesture_brightness"]];
    [middleBackground addSubview:middleImageView];
    
    swipeView = [[UIImageView alloc] initWithFrame:CGRectMake((centerView.frame.size.width - 70) / 2, (centerView.frame.size.height - 70) / 2, 70, 70)];
    [swipeView setImage:[UIImage imageNamed:@"play_gesture_forward"]];
    [swipeView setHidden:YES];
    [centerView addSubview:swipeView];
    
    
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    playBtn.frame = CGRectMake((screenWidth - 35) / 2, (screenHeight - 35) / 2, 35, 35);
    [playBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_play"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setAlpha:1];
    
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, swipeView.frame.origin.y + swipeView.frame.size.height, centerView.frame.size.width, 30)];
    progressLabel.text = @"--:--:-- / --:--:--";
    progressLabel.font = [UIFont systemFontOfSize:18];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.backgroundColor = [UIColor clearColor];
    [progressLabel setHidden:YES];
    [centerView addSubview:progressLabel];
}

-(void)configPreloadPage
{
    loadingBgImageViw = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, config.topPlayerHeight)];
    loadingBgImageViw.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"play_back" ofType:@"png"]];
    [centerView addSubview:loadingBgImageViw];
    
    loadingActiviy = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((centerView.frame.size.width - 35) / 2, (centerView.frame.size.height - 35) / 2, 35, 35)];
    loadingActiviy.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [centerView addSubview:loadingActiviy];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerView.frame.size.width/2 - 75, centerView.frame.size.height/2 + 15, 150, 30)];
    loadingLabel.text = NSLocalizedString(@"loading", @"loading...");
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [centerView addSubview:loadingLabel];
    
    [loadingActiviy startAnimating];
    [self startBandwidthTimer];
}

-(void)configNavControls
{
    navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    navView.userInteractionEnabled = YES;
    [colorUtil setGradientBlackToWhiteColor:navView];
    
    
    collapseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collapseBtn.frame = CGRectMake(0, 0, 40, 40);
    [collapseBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_collapse"] forState:UIControlStateNormal];
    [collapseBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_collapse_pressed"] forState:UIControlStateHighlighted];
    [collapseBtn addTarget:self action:@selector(collapseBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    if(config.draggable)
        [navView addSubview:collapseBtn];
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(0, 0, 40, 40);
    [doneBtn setTitle:@"X" forState:UIControlStateNormal];
    [doneBtn setTitle:@"X" forState:UIControlStateHighlighted];
    [doneBtn addTarget:self action:@selector(doneBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    if(!config.draggable)
       [navView addSubview:doneBtn];
    
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    settingBtn.frame = CGRectMake(self.view.frame.size.width - 33, 0, 33, 33);
    [settingBtn addTarget:self action:@selector(settingBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:[UIImage imageNamed: @"btn_player_setting"] forState:UIControlStateNormal];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"btn_player_setting"] forState:UIControlStateHighlighted];
    [navView addSubview:settingBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    shareBtn.frame = CGRectMake(settingBtn.frame.origin.x - 33, -5, 33, 33);
    [shareBtn addTarget:self action:@selector(shareBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed: @"ic_vidcontrol_share"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_share_pressed"] forState:UIControlStateHighlighted];
    [navView addSubview:shareBtn];
    
    lockScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    lockScreenBtn.frame = CGRectMake(shareBtn.frame.origin.x - 74 / 2, 3, 74 / 2, 92 / 2);
    [lockScreenBtn addTarget:self action:@selector(lockScreenBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [lockScreenBtn setImage:[UIImage imageNamed: @"plugin_fullscreen_bottom_lock_btn_normal"] forState:UIControlStateNormal];
    
    [navView addSubview:lockScreenBtn];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 140, 33)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = config.currentVideoTitle;
    [titleLabel setHidden:YES];
    [navView addSubview:titleLabel];
}

-(void)configBottomControls
{
    bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, config.topPlayerHeight - 30, self.view.frame.size.width, 30)];
    [colorUtil setGradientWhiteToBlackColor:bottomView];
    bottomView.userInteractionEnabled = YES;
    
    
    cacheProgress = [[FWPlayerProgressSlider alloc] initWithFrame:CGRectMake(35, 13, self.view.frame.size.width - 125, 0)];
    [cacheProgress setMinimumTrackImage:[UIImage imageNamed:@"api_tv_scrubber_buffer"] forState:UIControlStateNormal];
    [cacheProgress setMaximumTrackImage:[UIImage imageNamed:@"api_tv_scrubber_background"] forState:UIControlStateNormal];
    [cacheProgress setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [bottomView addSubview:cacheProgress];
    sliderProgress = [[FWPlayerProgressSlider alloc] initWithFrame:CGRectMake(cacheProgress.frame.origin.x, cacheProgress.frame.origin.y, cacheProgress.frame.size.width, 50)];
    sliderProgress.backgroundColor = [UIColor clearColor];
    [sliderProgress setMinimumTrackImage:[UIImage imageNamed:@"phone_my_main_line"] forState:UIControlStateNormal];
    [sliderProgress setMaximumTrackImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [sliderProgress setThumbImage:[UIImage imageNamed:@"api_scrubber_selected"] forState:UIControlStateNormal];
    [sliderProgress addTarget:self action:@selector(changePlayerProgress:) forControlEvents:UIControlEventValueChanged];
    [sliderProgress addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
    [bottomView addSubview:sliderProgress];
    
    currentPlayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 40, 20)];
    currentPlayTimeLabel.font = [UIFont systemFontOfSize:9];
    currentPlayTimeLabel.textColor = [UIColor whiteColor];
    currentPlayTimeLabel.backgroundColor = [UIColor clearColor];
    currentPlayTimeLabel.text = @"--:--:--";
    currentPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    [bottomView addSubview:currentPlayTimeLabel];
    
    remainPlayTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, currentPlayTimeLabel.frame.origin.y, currentPlayTimeLabel.frame.size.width, currentPlayTimeLabel.frame.size.height)];
    remainPlayTimeLabel.font = [UIFont systemFontOfSize:9];
    remainPlayTimeLabel.textColor = [UIColor whiteColor];
    remainPlayTimeLabel.backgroundColor = [UIColor clearColor];
    remainPlayTimeLabel.text = @"--:--:--";
    remainPlayTimeLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:remainPlayTimeLabel];
    
    fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    fullScreenBtn.frame = CGRectMake(self.view.frame.size.width - 50, -7, 50, 50);
    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_fullscreen_off"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fullScreenOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:fullScreenBtn];
    
}

-(void)configNextView
{
    nextView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth / 2, bottomView.frame.origin.y - 20, screenWidth / 2, 20)];
    nextView.userInteractionEnabled = YES;
    nextView.backgroundColor = [colorUtil colorWithHex:@"#222222" alpha:0.5];
    
    nextEpisodeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    nextEpisodeBtn.frame = CGRectMake(nextView.frame.size.width - 40 / 2, 0, 40 / 2, 40 / 2);
    [nextEpisodeBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_next_series"] forState:UIControlStateNormal];
    [nextEpisodeBtn addTarget:self action:@selector(nextEpisodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:nextEpisodeBtn];
    
    nextEpisodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nextView.frame.size.width - 20, nextView.frame.size.height)];
    nextEpisodeLabel.font = [UIFont systemFontOfSize:9];
    nextEpisodeLabel.textColor = [UIColor whiteColor];
    nextEpisodeLabel.text = NSLocalizedString(@"nextplay", @"nextplay");
    nextEpisodeLabel.textAlignment = NSTextAlignmentCenter;
    [nextView addSubview:nextEpisodeLabel];
    
    [nextView setHidden:YES];
}

-(void)configSettingView
{
    settingView = [[UIImageView alloc] init];
    settingView.backgroundColor = [colorUtil colorWithHex:@"#000000" alpha:0.5];
    settingView.userInteractionEnabled = YES;
    
    settingViewCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [settingViewCloseBtn addTarget:self action:@selector(settingViewCloseBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [settingViewCloseBtn setTitle:NSLocalizedString(@"done", @"done") forState:UIControlStateNormal];
    settingViewCloseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [settingViewCloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingViewCloseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    settingViewCloseBtn.layer.borderWidth = 1;
    settingViewCloseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:settingViewCloseBtn];
    
    videoTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [videoTypeBtn addTarget:self action:@selector(videoTypeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [videoTypeBtn setTitle:NSLocalizedString(@"quality", @"quality") forState:UIControlStateNormal];
    videoTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    videoTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    videoTypeBtn.layer.borderWidth = 1;
    videoTypeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:videoTypeBtn];
    
    if([videoList count] > 0)
    {
        episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [episodeBtn addTarget:self action:@selector(episodeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
        [episodeBtn setTitle:NSLocalizedString(@"episode", @"episode") forState:UIControlStateNormal];
        episodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        episodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        episodeBtn.layer.borderWidth = 1;
        episodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [settingView addSubview:episodeBtn];
    }
    
    if([videoList[0][@"subtitles"] count] > 0)
    {
        subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [subtitleBtn addTarget:self action:@selector(subtitleBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
        [subtitleBtn setTitle:NSLocalizedString(@"subtitle", @"subtitle") forState:UIControlStateNormal];
        subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        subtitleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleBtn.layer.borderWidth = 1;
        subtitleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [settingView addSubview:subtitleBtn];
    }
    
    if([videoList[0][@"audio"] count] > 0)
    {
        channelBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [channelBtn addTarget:self action:@selector(channelBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
        [channelBtn setTitle:NSLocalizedString(@"channel", @"channel") forState:UIControlStateNormal];
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        channelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        channelBtn.layer.borderWidth = 1;
        channelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [settingView addSubview:channelBtn];
    }
    
    settingView.hidden = YES;
    [self.view addSubview:settingView];
}

-(void)showControls
{
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    [UIView animateWithDuration:0.2 animations:^{
        navView.alpha = 1;
        bottomView.alpha = 1;
        playBtn.alpha = 1;
        settingView.alpha = 1;
    } completion:^(BOOL finished) {
        isAnimationing = NO;
        isShowingCtrls = YES;
    }];
}

-(void)showControlsAndHiddenControlsAfter:(NSTimeInterval)time
{
    [self showControls];
    if(time != 0)
        [self performSelector:@selector(hiddenControls) withObject:nil afterDelay:time];
}

-(void)hiddenControls
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControls) object:nil];
    
    if (isAnimationing) {
        return;
    }
    isAnimationing = YES;
    [UIView animateWithDuration:0.2 animations:^{
        navView.alpha = 0;
        bottomView.alpha = 0;
        playBtn.alpha = 0;
    } completion:^(BOOL finished) {
        isAnimationing = NO;
        isShowingCtrls = NO;
    }];
}

-(void)startBandwidthTimer
{
    [self stopBandwidthTimer];
    bandwidthTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(retrieveTraffic:) userInfo:nil repeats:YES];
}

#pragma mark slider
- (void)changePlayerProgress:(id)sender {
    self.currentPlaybackTime = sliderProgress.value * self.duration;
}
-(void)progressTouchUp:(id)sender
{
    self.currentPlaybackTime = sliderProgress.value * self.duration;

    if(isPlaying)
        [self temporyaryPause];
    else
        [self pause];
    
    [self startLoading];
}

#pragma mark delegate
-(void)handleTap:(id)sender
{
    if (isShowingCtrls) {
        [self hiddenControls];
    } else {
        if(needToHideController)
        {
            
        }
        else if(!isSettingViewShow)
            [self showControlsAndHiddenControlsAfter:6];
        else
        {
           
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerOnTap object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(tapInside:)])
            [self.delegate tapInside:sender];
}

-(void)fullScreenOnClick:(id)sender
{
    if(isLock)
        [self lockScreenBtnOnClick:self];
    
    if (isFullScreen) {
        [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_fullscreen_off"] forState:UIControlStateNormal];
        [self setOrientation:UIDeviceOrientationPortrait];
        isFullScreen = NO;
    } else {
        [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_fullscreen_on"] forState:UIControlStateNormal];
        [self setOrientation:UIDeviceOrientationLandscapeLeft];
        isFullScreen = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerFullScreenBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(fullScreenBtnOnClick:)])
            [self.delegate fullScreenBtnOnClick:sender];
}

-(void)playBtnOnClick:(id)sender
{
    if (isPlaying) {
        [self pause];
    } else {
        [self play];
        [self showControlsAndHiddenControlsAfter:6];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerPlayBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(playBtnOnClick:)])
            [self.delegate playBtnOnClick:sender];
}

-(void)videoTypeBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerVideoTypeBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(videoTypeBtnOnClick:)])
            [self.delegate videoTypeBtnOnClick:sender];
}

-(void)settingViewCloseBtnOnClick:(id)sender
{
    [settingView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerSettingViewCloseBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(settingViewCloseBtnOnClick:)])
            [self.delegate settingViewCloseBtnOnClick:sender];
}

-(void)lockScreenBtnOnClick:(id)sender
{
    if(!isLock)
        [lockScreenBtn setImage:[UIImage imageNamed:@"plugin_fullscreen_bottom_lock_btn_selected"] forState:UIControlStateNormal];
    else
        [lockScreenBtn setImage:[UIImage imageNamed:@"plugin_fullscreen_bottom_lock_btn_normal"] forState:UIControlStateNormal];
    
    isLock = !isLock;
    
    if(!config.draggable)
        [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isSmall],@"isSmall",[NSNumber numberWithBool:isLock],@"isLock",nil] ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerLockBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(lockScreenBtnOnClick:)])
            [self.delegate lockScreenBtnOnClick:sender];
}


-(void)episodeBtnOnClick:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerEpisodeBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(episodeBtnOnClick:)])
            [self.delegate episodeBtnOnClick:sender];
}

-(void)subtitleBtnOnClick:(id)sender
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerSubtitleBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(subtitleBtnOnClick:)])
            [self.delegate subtitleBtnOnClick:sender];
}

- (void)channelBtnOnClick:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerChannelBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(channelBtnOnClick:)])
            [self.delegate channelBtnOnClick:sender];
}

-(void)collapseBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerCollapseBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(collapseBtnOnClick:)])
            [self.delegate collapseBtnOnClick:sender];
}

-(void)doneBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerDoneBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(doneBtnOnClick:)])
            [self.delegate doneBtnOnClick:sender];
}

-(void)shareBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerShareBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(shareBtnOnClick:)])
            [self.delegate shareBtnOnClick:sender];
}

-(void)settingBtnOnClick:(id)sender
{
    [self hiddenControls];
    [settingView setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerSettingBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(settingBtnOnClick:)])
            [self.delegate settingBtnOnClick:sender];
}

-(void)nextEpisodeBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerNextEpisodeBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(nextEpisodeBtnOnClick:)])
            [self.delegate nextEpisodeBtnOnClick:sender];
}

#pragma swipePlayerGesture

- (void)swipe:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint locationPoint = [(UIPanGestureRecognizer*)sender locationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        [self moveStateEnd:translatedPoint];
    }
    else
    {
        CGFloat width = self.view.frame.size.width;
        
        if(self.moveState == FWPlayerMoveNone)
        {
            if(fabs(translatedPoint.y) > 5 && locationPoint.x < width / 3 * 2)
                self.moveState = FWPlayerMoveBright;
            else if( fabs(translatedPoint.y) > 5 && locationPoint.x > width / 3 * 2)
                self.moveState = FWPlayerMoveVolume;
            else if( fabs(translatedPoint.y) < 4 && fabs(translatedPoint.x) > 5)
                self.moveState = FWPlayerMoveProgress;
        }
        if(self.moveState != FWPlayerMoveNone)
            [self movingStateChange:translatedPoint];
    }
}

-(void)moveStateEnd :(CGPoint)point
{
    switch (self.moveState) {
        case FWPlayerMoveProgress:
            [self progressHide:point];
            break;
        case FWPlayerMoveVolume:
            [self volumeHide:point];
            break;
        case FWPlayerMoveBright:
            [self brightHide:point];
            break;
        default:
            break;
    }
    self.moveState = FWPlayerMoveNone;
}

-(void)volumeHide:(CGPoint)point
{
    [swipeView setHidden:YES];
}

-(void)brightHide:(CGPoint)point
{
    [swipeView setHidden:YES];
    [middleBackground setHidden:YES];
}

-(void)progressHide:(CGPoint)point
{
    int progressNumber = point.x;
    NSTimeInterval time = self.currentPlaybackTime + (int)(progressNumber / 10);
    if(time < 0)
        time = 0;
    [self setCurrentPlaybackTime:time];
    if(isPlaying)
        [self play];
    [swipeView setHidden:YES];
    [progressLabel setHidden:YES];
}

-(void)movingStateChange:(CGPoint)point
{
    switch (self.moveState) {
        case FWPlayerMoveProgress:
            [self progressShow:point];
            break;
        case FWPlayerMoveVolume:
            [self volumeShow:point];
            break;
        case FWPlayerMoveBright:
            [self brightShow:point];
            break;
        default:
            break;
    }
}

-(void)progressShow:(CGPoint)point
{
    int number = point.x;
    [swipeView setImage:[UIImage imageNamed:number > 0 ? @"play_gesture_forward" : @"play_gesture_rewind" ]];
    
    [self showSwipeView];
    
    [progressLabel setHidden:NO];
    if((self.currentPlaybackTime + (int)(number / 10)) < 0 )
    {
        progressLabel.text = [NSString stringWithFormat:@"%@ / %@" ,[self convertStringFromInterval:0],[self convertStringFromInterval:self.duration]];
    }
    else
    {
        progressLabel.text = [NSString stringWithFormat:@"%@ / %@" ,[self convertStringFromInterval:self.currentPlaybackTime + (int)(number / 10)],[self convertStringFromInterval:self.duration]];
    }
    if(isPlaying)
        [self temporyaryPause];
    
    [middleBackground setHidden:YES];
}

-(void)volumeShow:(CGPoint)point
{
    if(!isSettingViewShow)
    {
        int number = point.y;
        
        float volume0 = [MPMusicPlayerController applicationMusicPlayer].volume;
        float add =  - number / screenWidth ;
        float volume = volume0 + add ;
        volume = floorf(volume * 100) / 100;
        
        if(volume != volume0)
            [MPMusicPlayerController applicationMusicPlayer].volume = volume;
        
        [middleBackground setHidden:YES];
    }
}

-(void)brightShow:(CGPoint)point
{
    if(!isSettingViewShow)
    {
        int number = point.y;
        
        float brightness0 = [UIScreen mainScreen].brightness;
        float add =   - number / screenWidth ;
        float brightness = brightness0 + add ;
        brightness = floorf(brightness * 100) / 100;
        
        if(brightness != brightness0)
            [[UIScreen mainScreen] setBrightness:brightness];
        [self showSwipeView];
        [swipeView setHidden:YES];
        [middleBackground setHidden:NO];
    }
}

-(void)showSwipeView
{
    [swipeView setHidden:NO];
    if(isShowingCtrls)
        [self hiddenControls];
}


- (void) monitorPlaybackTime {
    cacheProgress.value = self.playableDuration;
    sliderProgress.value = self.currentPlaybackTime * 1.0 / self.duration;
    currentPlayTimeLabel.text =[self convertStringFromInterval:self.currentPlaybackTime];
    int remainTime = self.duration - self.currentPlaybackTime;
    remainPlayTimeLabel.text = [self convertStringFromInterval:remainTime];
    
    if(remainTime < config.autoPlayLabelShowTime && config.autoplay)
    {
        [nextView setHidden:NO];
        nextEpisodeLabel.text = [NSString stringWithFormat:@"%d秒後自動播放下一集", remainTime];
    }
    else
    {
        [nextView setHidden:YES];
    }
    
    if (self.duration != 0 && self.currentPlaybackTime >= self.duration - 1)
    {
        self.currentPlaybackTime = 0;
        sliderProgress.value = 0;
        currentPlayTimeLabel.text =[self convertStringFromInterval:self.currentPlaybackTime];
        [self pause];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_play"] forState:UIControlStateNormal];
        isPlaying = NO;
    } else {
        if (isPlaying) {
            [self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:1];
        }
    }
}

-(void)setOrientation:(int)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (NSString *)convertStringFromInterval:(NSTimeInterval)timeInterval {
    int hour = (int)timeInterval%3600/60/60;
    int min = (int)timeInterval%3600/60;
    int second = (int)timeInterval%3600%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, second];
}

-(void)updatePlayerFrame:(CGRect)rect
{
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    self.view.frame = rect;
    
    centerView.frame = CGRectMake(viewWidth/2 - 100, viewHeight/2 - 100, 200, 200);
    
    if(loadingActiviy) loadingActiviy.frame = CGRectMake(centerView.frame.size.width/2 - 15, centerView.frame.size.height/2 - 15, 35, 35);
    if(loadingLabel) loadingLabel.frame = CGRectMake(centerView.frame.size.width/2 - 75, centerView.frame.size.height/2 + 15, 150, 30);
    if(loadingBgImageViw) loadingBgImageViw.frame = CGRectMake(centerView.frame.size.width/2 - 40, centerView.frame.size.height/2 + 15, 80, 30);
    
    titleLabel.frame = CGRectMake(5, 0, viewWidth - 140, 33);
    navView.frame = CGRectMake(0, 0, viewWidth, 40);
    settingBtn.frame = CGRectMake(viewWidth - 44, 12, 22, 22);
    shareBtn.frame = CGRectMake(settingBtn.frame.origin.x - 33, 7, 33, 33);
    
    settingView.frame = rect;
    settingViewCloseBtn.frame = CGRectMake(rect.size.width - 44 - 12, 12, 44, 22);
    videoTypeBtn.frame = CGRectMake(22, viewHeight / 2 - 11, 66, 22);
    episodeBtn.frame = CGRectMake(videoTypeBtn.frame.origin.x + videoTypeBtn.frame.size.width + 11, viewHeight / 2 - 11, 66, 22);
    channelBtn.frame = CGRectMake(episodeBtn.frame.origin.x + episodeBtn.frame.size.width + 11, viewHeight / 2 - 11, 66, 22);
    subtitleBtn.frame = CGRectMake(channelBtn.frame.origin.x + channelBtn.frame.size.width + 11, viewHeight / 2 - 11, 66, 22);
    
    bottomView.frame = CGRectMake(0, viewHeight - 30, viewWidth, 30);
    bottomView.layer.frame = CGRectMake(0, viewHeight - 30, viewWidth, 30);
    currentPlayTimeLabel.frame = CGRectMake(2, 4, 40, 20);
    cacheProgress.frame = CGRectMake(currentPlayTimeLabel.frame.size.width + 5, 13, viewWidth - 150, 50);
    sliderProgress.frame = CGRectMake(cacheProgress.frame.origin.x, cacheProgress.frame.origin.y, cacheProgress.frame.size.width, 50);
    remainPlayTimeLabel.frame = CGRectMake(sliderProgress.frame.size.width + sliderProgress.frame.origin.x + 5, 4, currentPlayTimeLabel.frame.size.width, currentPlayTimeLabel.frame.size.height);
    fullScreenBtn.frame = CGRectMake(viewWidth - 50, -7, 45, 45);
    
    nextView.frame = CGRectMake(viewWidth / 2, viewHeight - 50, viewWidth / 2, 20);
    nextEpisodeLabel.frame = CGRectMake(0, 0, nextView.frame.size.width - 20, nextView.frame.size.height);
    float precent = viewHeight / config.topPlayerHeight;
    
    if(precent < 1)
        nextEpisodeLabel.font = [UIFont systemFontOfSize:9 * precent];
    else
        nextEpisodeLabel.font = [UIFont systemFontOfSize:9];
    
    nextEpisodeBtn.frame = CGRectMake(nextView.frame.size.width - 40 / 2, 0, 40 / 2, 40 / 2);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        playBtn.frame = CGRectMake(viewWidth/2 - 35, viewHeight/2 - 35, 75, 75);
        swipeView.frame = CGRectMake((centerView.frame.size.width - 70) / 2, (centerView.frame.size.height - 70) / 2, 70, 70);
        isFullScreen = YES;
        [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_fullscreen_on"] forState:UIControlStateNormal];
        [collapseBtn setHidden:YES];
        [doneBtn setHidden:YES];
        [titleLabel setHidden:NO];
        middleBackground.frame = CGRectMake((viewWidth - 456 / 4) / 2, (viewHeight - 447 / 4) / 2, 456 / 4, 447 / 4);
    }
    else if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        playBtn.frame = CGRectMake(viewWidth/2 - 15, viewHeight/2 - 15, 35, 35);
        swipeView.frame = CGRectMake((centerView.frame.size.width - 35) / 2, (centerView.frame.size.height - 35) / 2, 35, 35);
        isFullScreen = NO;
        [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_fullscreen_off"] forState:UIControlStateNormal];
        [collapseBtn setHidden:NO];
        [doneBtn setHidden:NO];
        [titleLabel setHidden:YES];
        middleBackground.frame = CGRectMake((screenWidth - 456 / 4) / 2, (screenHeight - 447 / 4) / 2, 456 / 4, 447 / 4);
    }
    else
    {
        playBtn.frame = CGRectMake(viewWidth/2 - 15, viewHeight/2 - 15, 35, 35);
    }
    
    progressLabel.frame = CGRectMake(0, swipeView.frame.origin.y + swipeView.frame.size.height, centerView.frame.size.width, 30);
    
}

- (void)addViewAfterLoading
{
    [self.view addSubview:navView];
    [self.view addSubview:bottomView];
    [self.view addSubview:nextView];
    [self.view addSubview:settingView];
    [self.view addSubview:playBtn];
}

- (void)stopLoading
{
    if(isLoading)
    {
        isLoading = NO;
        [loadingActiviy stopAnimating];
        [loadingActiviy removeFromSuperview];
        [loadingLabel  removeFromSuperview];
        [loadingBgImageViw removeFromSuperview];
        
        [self addViewAfterLoading];
    }
}

-(void)startLoading
{
    if(!isLoading)
    {
        [playBtn removeFromSuperview];
        [navView removeFromSuperview];
        [bottomView removeFromSuperview];
        [nextView removeFromSuperview];
        
        isLoading = YES;
        [loadingActiviy startAnimating];
        [centerView addSubview:loadingBgImageViw];
        [centerView addSubview:loadingActiviy ];
        [centerView addSubview:loadingLabel ];
    }
}

#pragma mark playerDelagate
-(void)moviePlayerLoadStateChanged:(NSNotification*)notification
{
    NSLog(@"moviePlayerLoadStateChanged ---------%ld", [self loadState]);
    if ([self loadState] != MPMovieLoadStateUnknown) {
        if(!self.view.superview)
            [attachViewController.view addSubview:self.view];
        [self stopLoading];
        
        if(isPlaying)
            [self play];
    }
}

-(void)moviePlayBackDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    if(self.delegate != nil)
        if ([self.delegate  respondsToSelector:@selector(didFinishPlay:)])
            [self.delegate didFinishPlay:currentVideoUrl];
}

-(void)handleDurationAvailableNotification:(NSNotification*)notification
{
    cacheProgress.maximumValue = self.duration;
    currentPlayTimeLabel.text = [self convertStringFromInterval:self.currentPlaybackTime];
    remainPlayTimeLabel.text = [self convertStringFromInterval:self.duration - self.currentPlaybackTime];
}

- (void)becomeActiviy:(NSNotification *)notify {
    
}

- (void)enterBackground:(NSNotification *)notity {
    [super pause];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_play"] forState:UIControlStateNormal];
    isPlaying = NO;
}

-(void)UIDeviceOrientationDidChangeNotification:(NSNotification *)notity
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight )
    {
        if(config.rotatable && !isSmall)
            [self updatePlayerFrame:CGRectMake(0, 0, screenHeight, screenWidth)];
    }
    else if(orientation == UIDeviceOrientationPortrait)
    {
        if(self.view.frame.size.height > config.topPlayerHeight && !isLock)
            [self updatePlayerFrame:CGRectMake(0, 0, screenWidth, config.topPlayerHeight)];
    }
}

-(void)handleSwipePlayerViewStateChange:(NSNotification *)notity
{
    isSmall = [[[notity userInfo] valueForKey:@"isSmall"] boolValue];
    if(isSmall)
        needToHideController = YES;
    else
        needToHideController = NO;
    
    [self hiddenControls];
}

#pragma mark timer

- (void)retrieveTraffic:(NSTimer*) timer {
    MPMovieAccessLog *log = self.accessLog;
    if(log != nil) {
        if(self.playableDuration - self.currentPlaybackTime < 10)
        {
            if(log.events.count > 0) {
                if(isPlaying)
                    [self temporyaryPause];
                else
                    [self pause];
                
                [self startLoading];
                
                double bt = [[log.events objectAtIndex:log.events.count - 1] observedBitrate];
                
                if(loadingLabel)
                {
                    loadingLabel.text = [NSLocalizedString(@"loading", @"loading..") stringByAppendingString : [NSString stringWithFormat: @"%.1f Kbps/s", bt / 1024]];
                    NSLog(@"%@", loadingLabel.text);
                }
                
            }
        }
        else if (isLoading)
        {
            [self stopLoading];
            if(isPlaying)
                [self play];
        }
    }
}


#pragma mark player base control

-(void)play
{
    [super play];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_pause_pressed"] forState:UIControlStateNormal];
    isPlaying = YES;
    [self monitorPlaybackTime];
}

-(void)temporyaryPause
{
    [self pause];
    isPlaying = YES;
}

-(void)pause
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(monitorPlaybackTime) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControls) object:nil];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_play"] forState:UIControlStateNormal];
    [super pause];
    isPlaying = NO;
}

-(void)stop
{
    [super stop];
    isPlaying = NO;
}

-(void)stopBandwidthTimer
{
    if(bandwidthTimer)
    {
        [bandwidthTimer invalidate];
        bandwidthTimer = nil;
    }
}

-(void)stopAndRemove
{
    [self stop];
    [self endPlayer];
}

-(void)playStartAt:(NSTimeInterval)time
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setInitialPlaybackTime:time];
        [self setCurrentPlaybackTime:time];
        [self play];
    });
}

- (void)endPlayer{
    [navView removeFromSuperview];
    [sliderProgress removeFromSuperview];
    [currentPlayTimeLabel removeFromSuperview];
    [titleLabel removeFromSuperview];
    [bottomView removeFromSuperview];
    [centerView removeFromSuperview];
    [self.view removeFromSuperview];
    
    [self stopBandwidthTimer];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(monitorPlaybackTime) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControls) object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerLoadStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMovieDurationAvailableNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FWSwipePlayerViewStateChange
                                                  object:nil];
}

- (void)attachTo:(UIViewController*)controller
{
    attachViewController = controller;
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
