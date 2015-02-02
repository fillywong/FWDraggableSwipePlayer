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
NSString *FWSwipePlayerCollapseBtnOnclick = @"FWSwipePlayerCollapseBtnOnclick";
NSString *FWSwipePlayerPlayBtnOnclick = @"FWSwipePlayerPlayBtnOnclick";
NSString *FWSwipePlayerFullScreenBtnOnclick = @"FWSwipePlayerFullScreenBtnOnclick";
NSString *FWSwipePlayerNextEpisodeBtnOnclick = @"FWSwipePlayerNextEpisodeBtnOnclick";
NSString *FWSwipePlayerVideoTypeBtnOnclick = @"FWSwipePlayerVideoTypeBtnOnclick";
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
    UIButton *shareBtn;
    UIButton *videoTypeBtn;
    UIButton *lockScreenBtn;
    UILabel *titleLabel;
    FWVideoTypeSelectView *videoTypeSelectView;
    
    UIImageView *bottomView;
    FWPlayerProgressSlider *sliderProgress;
    FWPlayerProgressSlider *cacheProgress;
    UILabel *currentPlayTimeLabel;
    UILabel *remainPlayTimeLabel;
    UIButton *fullScreenBtn;
    
    UIImageView *rightView;
    UIButton *episodeBtn;
    UIButton *subtitleBtn;
    UIButton *channelBtn;
    UIImageView *selectView;
    FWSelectView *episodeView;
    FWSelectView *subtitleView;
    FWSelectView *channelView;
    
    UIImageView *nextView;
    UILabel *nextEpisodeLabel;
    UIButton *nextEpisodeBtn;
    
    UIImageView *centerView;
    UIButton *playBtn;
    UIImageView *swipeView;
    UIImageView *middleBackground;
    UILabel *middleLabel;
    UILabel *progressLabel;
    
    BOOL isPlaying;
    BOOL isFullScreen;
    BOOL isAnimationing;
    BOOL isShowingCtrls;
    BOOL needToHideController;
    BOOL isLock;
    BOOL isSmall;
    BOOL isSelectViewShow;
    
    float curVolume;
    float curPlaytime;
    
    FWSWipePlayerConfig * config;
    FWPlayerColorUtil *colorUtil;
    
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    NSURL *currentVideoUrl;
    NSArray *videoList;
    
    UIPanGestureRecognizer *swipeRecognizer;
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
        isSelectViewShow = NO;
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
            isSelectViewShow = NO;
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
    [self configRightControls];
    [self configSelectView];
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
    middleLabel.text = @"光度";
    [middleBackground addSubview:middleLabel];
    
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
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerView.frame.size.width/2 - 40, centerView.frame.size.height/2 + 15, 80, 30)];
    loadingLabel.text = @"努力加载中...";
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [centerView addSubview:loadingLabel];
    
    [loadingActiviy startAnimating];
}

-(void)configNavControls
{
    navView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    navView.userInteractionEnabled = YES;
    [colorUtil setGradientBlackToWhiteColor:navView];
    [self.view addSubview:navView];
    
    collapseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collapseBtn.frame = CGRectMake(0, 0, 40, 40);
    [collapseBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_collapse"] forState:UIControlStateNormal];
    [collapseBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_collapse_pressed"] forState:UIControlStateHighlighted];
    [collapseBtn addTarget:self action:@selector(collapseBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    if(config.draggable)
        [navView addSubview:collapseBtn];
    
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    shareBtn.frame = CGRectMake(self.view.frame.size.width - 50, -5, 50, 50);
    [shareBtn addTarget:self action:@selector(shareBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed: @"ic_vidcontrol_share"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_vidcontrol_share_pressed"] forState:UIControlStateHighlighted];
    [navView addSubview:shareBtn];
    
    videoTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    videoTypeBtn.frame = CGRectMake(shareBtn.frame.origin.x  - 100 / 2 + 10, 5, 100 / 2, 52 / 2);
    [videoTypeBtn addTarget:self action:@selector(videoTypeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [videoTypeBtn setTitle:@"高清" forState:UIControlStateNormal];
    videoTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [navView addSubview:videoTypeBtn];
    
    NSDictionary *obj1 = [NSDictionary dictionaryWithObjectsAndKeys:@"标清" , @"title",nil];
    NSDictionary *obj2 = [NSDictionary dictionaryWithObjectsAndKeys:@"高清" , @"title",nil];
    NSDictionary *obj3 = [NSDictionary dictionaryWithObjectsAndKeys:@"超清" , @"title",nil];
    NSArray *videoTypeList = [[NSArray alloc]initWithObjects:obj1,obj2,obj3, nil];
    videoTypeSelectView = [[FWVideoTypeSelectView alloc]initWithFrame:CGRectMake(videoTypeBtn.frame.origin.x, videoTypeBtn.frame.origin.y + videoTypeBtn.frame.size.height, videoTypeBtn.frame.size.width, videoTypeBtn.frame.size.height * [videoTypeList count])];
    videoTypeSelectView.backgroundColor = [UIColor clearColor];
    [videoTypeSelectView reloadSelectViewWithArray:videoTypeList];
    [videoTypeSelectView setHidden:YES];
    [navView addSubview:videoTypeSelectView];
    
    lockScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    lockScreenBtn.frame = CGRectMake(videoTypeBtn.frame.origin.x - 74 / 2, 3, 74 / 2, 92 / 2);
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
    [self.view addSubview:bottomView];
    
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
    [self.view addSubview:nextView];
    
    nextEpisodeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    nextEpisodeBtn.frame = CGRectMake(nextView.frame.size.width - 40 / 2, 0, 40 / 2, 40 / 2);
    [nextEpisodeBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_next_series"] forState:UIControlStateNormal];
    [nextEpisodeBtn addTarget:self action:@selector(nextEpisodeBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextView addSubview:nextEpisodeBtn];
    
    nextEpisodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nextView.frame.size.width - 20, nextView.frame.size.height)];
    nextEpisodeLabel.font = [UIFont systemFontOfSize:9];
    nextEpisodeLabel.textColor = [UIColor whiteColor];
    nextEpisodeLabel.text = @"還有3秒即將播放下一集";
    nextEpisodeLabel.textAlignment = NSTextAlignmentCenter;
    [nextView addSubview:nextEpisodeLabel];
    
    [nextView setHidden:YES];
}

-(void)configRightControls
{
    rightView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth > screenHeight ? screenWidth : screenHeight) - 30, ((screenHeight > screenWidth ? screenWidth : screenHeight) - 90 ) / 2 - 50, 30, 90)];
    
    rightView.userInteractionEnabled = YES;
    [self.view addSubview:rightView];
    
    episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    episodeBtn.frame = CGRectMake(0, 0, 30 , 30 );
    [episodeBtn addTarget:self action:@selector(episodeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [episodeBtn setTitle:@"專輯" forState:UIControlStateNormal];
    episodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    episodeBtn.backgroundColor = [UIColor blackColor];
    [episodeBtn setAlpha:0.7];
    [rightView addSubview:episodeBtn];
    
    subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    subtitleBtn.frame = CGRectMake(0, episodeBtn.frame.size.height + episodeBtn.frame.origin.y, 30 , 30 );
    [subtitleBtn addTarget:self action:@selector(subtitleBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [subtitleBtn setTitle:@"字幕" forState:UIControlStateNormal];
    subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    subtitleBtn.backgroundColor = [UIColor blackColor];
    [subtitleBtn setAlpha:0.7];
    [rightView addSubview:subtitleBtn];
    
    channelBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    channelBtn.frame = CGRectMake(0, subtitleBtn.frame.size.height + subtitleBtn.frame.origin.y, 30 , 30 );
    [channelBtn addTarget:self action:@selector(channelBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [channelBtn setTitle:@"聲道" forState:UIControlStateNormal];
    channelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    channelBtn.backgroundColor = [UIColor blackColor];
    [channelBtn setAlpha:0.7];
    [rightView addSubview:channelBtn];
    
    [self.view addSubview:rightView];
}

-(void)configSelectView
{
    selectView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, navView.frame.size.height, 200, (screenWidth > screenHeight ? screenHeight : screenWidth))];
    selectView.backgroundColor = [UIColor clearColor];
    selectView.userInteractionEnabled = YES;
    [self.view addSubview:selectView];
    
    if([videoList count] > 0)
    {
        episodeView = [[FWSelectView alloc]initWithFrame:CGRectMake(0,0,selectView.frame.size.width,selectView.frame.size.height) ];
        episodeView.backgroundColor = [UIColor blackColor];
        [episodeView reloadSelectViewWithArray:videoList withSectionTitle:@"专辑列表"];
        [episodeView setHidden:YES];
        [selectView addSubview:episodeView];
    }
    
    subtitleView = [[FWSelectView alloc]initWithFrame:CGRectMake(0,0,selectView.frame.size.width,selectView.frame.size.height) ];
    subtitleView.backgroundColor = [UIColor blackColor];
    [subtitleView reloadSelectViewWithArray:videoList[0][@"subtitles"] withSectionTitle:@"字幕"];
    [subtitleView setHidden:YES];
    [selectView addSubview:subtitleView];
    
    channelView = [[FWSelectView alloc]initWithFrame:CGRectMake(0,0,selectView.frame.size.width,selectView.frame.size.height) ];
    channelView.backgroundColor = [UIColor blackColor];
    [channelView reloadSelectViewWithArray:videoList[0][@"audio"]  withSectionTitle:@"聲道"];
    [channelView setHidden:YES];
    [selectView addSubview:channelView];
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
        
        rightView.alpha = 1;
        if(!isSelectViewShow)
            rightView.frame = CGRectMake(self.view.frame.size.width - 30, (self.view.frame.size.height - 90) / 2, 30, 90);
        
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
        if(!isSelectViewShow)
            rightView.alpha = 0;
        [videoTypeSelectView setHidden:YES];
    } completion:^(BOOL finished) {
        isAnimationing = NO;
        isShowingCtrls = NO;
    }];
}

#pragma mark slider
- (void)changePlayerProgress:(id)sender {
    self.currentPlaybackTime = sliderProgress.value * self.duration;
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
        else if(!isSelectViewShow)
            [self showControlsAndHiddenControlsAfter:6];
        else
        {
            [self hideSelectView];
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
    [videoTypeSelectView setHidden:!videoTypeSelectView.hidden];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerVideoTypeBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(videoTypeBtnOnClick:)])
            [self.delegate videoTypeBtnOnClick:sender];
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



-(void)hideSelectView
{
    episodeBtn.alpha = 0.7;
    subtitleBtn.alpha = 0.7;
    channelBtn.alpha = 0.7;
    
    [UIView animateWithDuration:0.2f animations:^{
        isSelectViewShow = NO;
        if(navView.alpha == 0)
            rightView.frame = CGRectMake(self.view.frame.size.width, (self.view.frame.size.height - 90) / 2, 30, 90);
        else
            rightView.frame = CGRectMake(self.view.frame.size.width - 30, (self.view.frame.size.height - 90) / 2, 30, 90);
        
        selectView.frame = CGRectMake(self.view.frame.size.width, selectView.frame.origin.y, selectView.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished){
        if(finished)
        {
        }
    }];
}

-(void)showSelectView
{
    [UIView animateWithDuration:0.2f animations:^{
        isSelectViewShow = YES;
        [self hiddenControls];
        selectView.frame = CGRectMake(self.view.frame.size.width - selectView.frame.size.width, 0, selectView.frame.size.width, self.view.frame.size.height);
        
        if(rightView.frame.origin.x == (self.view.frame.size.width - 30))
            rightView.frame = CGRectMake(rightView.frame.origin.x - selectView.frame.size.width,  selectView.frame.origin.y, 30, selectView.frame.size.height);
        
    } completion:^(BOOL finished){
        if(finished)
        {
        }
    }];
}

-(void)showEpisodeView
{
    episodeBtn.alpha = 1.0;
    channelBtn.alpha = 0.7;
    subtitleBtn.alpha = 0.7;
    
    [episodeView setHidden:NO];
    [subtitleView setHidden:YES];
    [channelView setHidden:YES];
}

-(void)showSubtitleView
{
    subtitleBtn.alpha = 1.0;
    channelBtn.alpha = 0.7;
    episodeBtn.alpha = 0.7;
    
    [subtitleView setHidden:NO];
    [episodeView setHidden:YES];
    [channelView setHidden:YES];
}

-(void)showChannelView
{
    channelBtn.alpha = 1.0;
    subtitleBtn.alpha = 0.7;
    episodeBtn.alpha = 0.7;
    
    [channelView setHidden:NO];
    [subtitleView setHidden:YES];
    [episodeView setHidden:YES];
}

-(void)episodeBtnOnClick:(id)sender
{
    if(selectView.frame.origin.x >= self.view.frame.size.width)
    {
        [self showEpisodeView];
        [self showSelectView];
    }
    else if(episodeView.hidden)
    {
        [self showEpisodeView];
    }
    else
        [self hideSelectView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerEpisodeBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(episodeBtnOnClick:)])
            [self.delegate episodeBtnOnClick:sender];
}

-(void)subtitleBtnOnClick:(id)sender
{
    if(selectView.frame.origin.x >= self.view.frame.size.width )
    {
        [self showSubtitleView];
        [self showSelectView];
    }
    else if(subtitleView.hidden)
    {
        [self showSubtitleView];
    }
    else
        [self hideSelectView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerSubtitleBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(subtitleBtnOnClick:)])
            [self.delegate subtitleBtnOnClick:sender];
}

- (void)channelBtnOnClick:(id)sender
{
    if(selectView.frame.origin.x >= self.view.frame.size.width )
    {
        [self showChannelView];
        [self showSelectView];
    }
    else if(channelView.hidden)
    {
        [self showChannelView];
    }
    else
        [self hideSelectView];
    
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

-(void)shareBtnOnClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerShareBtnOnclick object:self userInfo:nil] ;
    
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(shareBtnOnClick:)])
            [self.delegate shareBtnOnClick:sender];
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
    if(!isSelectViewShow)
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
    if(!isSelectViewShow)
    {
        int number = point.y;
        
        float brightness0 = [UIScreen mainScreen].brightness;
        float add =   - number / screenWidth ;
        float brightness = brightness0 + add ;
        brightness = floorf(brightness * 100) / 100;
        
        if(brightness != brightness0)
            [[UIScreen mainScreen] setBrightness:brightness];
        
        [swipeView setImage:[UIImage imageNamed:@"play_gesture_brightness"]];
        [middleBackground setHidden:NO];
        [self showSwipeView];
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
    if(loadingLabel) loadingLabel.frame = CGRectMake(centerView.frame.size.width/2 - 40, centerView.frame.size.height/2 + 15, 80, 30);
    if(loadingBgImageViw) loadingBgImageViw.frame = CGRectMake(centerView.frame.size.width/2 - 40, centerView.frame.size.height/2 + 15, 80, 30);
    
    titleLabel.frame = CGRectMake(5, 0, viewWidth - 140, 33);
    navView.frame = CGRectMake(0, 0, viewWidth, 20);
    shareBtn.frame = CGRectMake(viewWidth - 50, -5, 50, 50);
    
    bottomView.frame = CGRectMake(0, viewHeight - 30, viewWidth, 30);
    bottomView.layer.frame = CGRectMake(0, viewHeight - 30, viewWidth, 30);
    currentPlayTimeLabel.frame = CGRectMake(2, 4, 40, 20);
    cacheProgress.frame = CGRectMake(currentPlayTimeLabel.frame.size.width + 5, 13, viewWidth - 150, 0);
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
        [titleLabel setHidden:YES];
        middleBackground.frame = CGRectMake((screenWidth - 456 / 4) / 2, (screenHeight - 447 / 4) / 2, 456 / 4, 447 / 4);
    }
    else
    {
        playBtn.frame = CGRectMake(viewWidth/2 - 15, viewHeight/2 - 15, 35, 35);
    }
    
    progressLabel.frame = CGRectMake(0, swipeView.frame.origin.y + swipeView.frame.size.height, centerView.frame.size.width, 30);
    
    
    
    if(!isSelectViewShow)
    {
        selectView.frame = CGRectMake(viewWidth, selectView.frame.origin.y, selectView.frame.size.width, viewHeight);
        rightView.frame = CGRectMake(viewWidth - 30, (viewHeight - 90) / 2 , 30, 90);
    }
    else
    {
        selectView.frame = CGRectMake(viewWidth - selectView.frame.size.width, selectView.frame.origin.y, selectView.frame.size.width, viewHeight);
        rightView.frame = CGRectMake(viewWidth - 30 - selectView.frame.size.width, 0 , 30, 90);
    }
    
    [episodeView updateFrame:CGRectMake(episodeView.frame.origin.x, episodeView.frame.origin.y, episodeView.frame.size.width, viewHeight)];
    [subtitleView updateFrame:CGRectMake(subtitleView.frame.origin.x, subtitleView.frame.origin.y, subtitleView.frame.size.width, viewHeight)];
    [channelView updateFrame:CGRectMake(channelView.frame.origin.x, channelView.frame.origin.y, channelView.frame.size.width, viewHeight)];
}

#pragma mark playerDelagate
-(void)moviePlayerLoadStateChanged:(NSNotification*)notification
{
    [loadingActiviy stopAnimating];
    [loadingActiviy removeFromSuperview];
    loadingActiviy = nil;
    [loadingLabel  removeFromSuperview];
    loadingLabel = nil;
    [loadingBgImageViw removeFromSuperview];
    loadingBgImageViw = nil;
    
    [self.view addSubview:playBtn];
    
    NSLog(@"moviePlayerLoadStateChanged ---------%ld", [self loadState]);
    if ([self loadState] != MPMovieLoadStateUnknown) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        
        [self play];
    } else
        [self stop];
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

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
