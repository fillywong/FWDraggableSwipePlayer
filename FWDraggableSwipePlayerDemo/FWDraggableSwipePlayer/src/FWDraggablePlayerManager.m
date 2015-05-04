//
//  FWDraggablePlayerManager.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWDraggablePlayerManager.h"
#import "MovieDetailView.h"
#define ANIMATION_TIME 0.2f

NSString *FWSwipePlayerViewStateChange = @"FWSwipePlayerViewStateChange";

@interface FWDraggablePlayerManager()
{
    NSDictionary * infoDict;
    FWSwipePlayerConfig *config;
    
    UIView* rootView;
    
    UIPanGestureRecognizer *dragRecognizer;
    UIPanGestureRecognizer *swipeRecognizer;
    
    BOOL isSmall;
    BOOL isAnimation;
    BOOL isVertical;
    BOOL isHorizontal;
    BOOL isLock;
    
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSArray *dataList;
}
@end

@implementation FWDraggablePlayerManager

- (id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundView = [[FWSwipePlayerBackgroundView alloc]init];
        
        self.swipeState = FWSwipeNone;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] ;
        [dragRecognizer setMinimumNumberOfTouches:1];
        [dragRecognizer setMaximumNumberOfTouches:1];
        [dragRecognizer setDelegate:self];
        
        swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)] ;
        [swipeRecognizer setMinimumNumberOfTouches:1];
        [swipeRecognizer setMaximumNumberOfTouches:1];
        [swipeRecognizer setDelegate:self];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

- (id)initWithInfo:(NSDictionary *)dict
{
    return [self initWithInfo:dict Config:[[FWSwipePlayerConfig alloc]init]];
}

- (id)initWithInfo:(NSDictionary *)dict Config:(FWSwipePlayerConfig*)configuration
{
    self = [self init];
    if(self)
    {
        infoDict = dict;
        config = configuration;
    }
    return self;
}

- (void)updateInfo:(NSDictionary *)dict
{
    infoDict = dict;
}

- (id)initWithList:(NSArray *)list
{
    return [self initWithList:list Config:[[FWSwipePlayerConfig alloc]init]];
}

- (id)initWithList:(NSArray *)list Config:(FWSwipePlayerConfig*)configuration
{
    self = [self init];
    if(self)
    {
        if([list count] > 0)
            dataList = list;
        infoDict = list[0];
        config = configuration;
    }
    return self;
}

-(void)initConfig
{
    [self configPlayer];
    [self configDetailView];
    [self configSetting];
}

-(void)configPlayer
{
    if(self.playerController != nil)
    {
        [self.playerController.moviePlayer stopAndRemove];
        self.playerController = nil;
    }
    
    self.playerController =  [[FWSwipePlayerViewController alloc]init];
    
    if(dataList)
        [self.playerController updateMoviePlayerWithVideoList:dataList Config:config];
    else
        [self.playerController updateMoviePlayerWithInfo:infoDict Config:config];
    
    self.playerController.moviePlayer.delegate = self;
    
    if(config.draggable)
    {
        [self.playerController.moviePlayer.view addGestureRecognizer:dragRecognizer];
    }
}

-(void)configDetailView
{
    if(self.detailView == nil)
    {
        self.detailView = [[MovieDetailView alloc]init];
        [self.detailView initWithInfo:infoDict];
        self.detailView.backgroundColor = [UIColor whiteColor];
    }
    [self.detailView updateFrame:CGRectMake(0, config.topPlayerHeight, rootView.frame.size.width, rootView.frame.size.height - config.topPlayerHeight)];
    [self.detailView setAlpha:1];
    
    [self.playerController.view addSubview:self.detailView];
}

-(void)configSetting
{
    isSmall = NO;
    isLock = NO;
    isAnimation = NO;
    isVertical = NO;
    isHorizontal = NO;
}

- (void)showAtView:(UIView *)view
{
    rootView = view;
    [self initConfig];
    
    [view addSubview:self.backgroundView];
    [view addSubview:self.playerController.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isSmall],@"isSmall",[NSNumber numberWithBool:isLock],@"isLock",nil] ];
}

- (void)showAtController:(UIViewController *)controller
{
    [self showAtView:controller.view];
}

- (void)showAtControllerAndPlay:(UIViewController *)controller
{
    [self showAtController:controller];
    [self.playerController.moviePlayer prepareToPlay];
}

- (void)showAtViewAndPlay:(UIView *)view
{
    [self showAtView:view];
    [self.playerController.moviePlayer prepareToPlay];
    [self.playerController.moviePlayer play];
    
}

-(void)backgroundAlphaChange:(CGFloat)alpha
{
    self.backgroundView.userInteractionEnabled = alpha == 1 ? NO : YES;
    [self.backgroundView setAlpha:alpha];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)move:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.playerController.view];
    
    [self.playerController.moviePlayer hiddenControls];
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        if(!isAnimation)
        {
            [self updateSwipeState:translatedPoint];
            [self updateEndingMovingFrame];
        }
    }
    else
    {
        if(!isAnimation)
        {
            [self updateMovingSwipeState:translatedPoint];
            [self updateMovingFrame:translatedPoint];
        }
    }
}

-(void)updateMovingSwipeState:(CGPoint)translatedPoint
{
    if(!isSmall && translatedPoint.y > 0 && !isHorizontal )
    {
        isVertical = YES;
        self.swipeState = FWSwipeDown;
    }
    else if(isSmall)
    {
        if(translatedPoint.y < 0 && !isHorizontal)
        {
            isVertical = YES;
            self.swipeState = FWSwipeUp;
        }
        else if(translatedPoint.x > 15 && translatedPoint.x > 0 && !isVertical)
        {
            isHorizontal = YES;
            self.swipeState = FWSwipeRight;
        }
        else if(translatedPoint.x < -15 && translatedPoint.x < 0 && !isVertical)
        {
            isHorizontal = YES;
            self.swipeState = FWSwipeLeft;
        }
        else
            self.swipeState = FWSwipeNone;
    }
    else
        self.swipeState = FWSwipeNone;
}

-(void)updateMovingFrame:(CGPoint)translatedPoint
{
    switch (self.swipeState) {
        case FWSwipeDown:
        case FWSwipeUp:
            [self movingSwipeVertical:translatedPoint];
            break;
        case FWSwipeRight:
        case FWSwipeLeft:
            [self movingSwipeHorizontal:translatedPoint];
            break;
        default:
            break;
    }
}

-(void)movingSwipeVertical:(CGPoint)translatedPoint
{
    float HeightPre = translatedPoint.y / (config.maxVerticalMovingHeight - config.miniPlayerHeight) + ((self.swipeState == FWSwipeDown) ? 0: 1);
    
    if(HeightPre <= 1 && HeightPre > 0)
    {
        [self.playerController.view setFrame:CGRectMake(screenWidth / 2 * HeightPre ,  HeightPre * (config.maxVerticalMovingHeight - config.miniPlayerHeight), screenWidth, screenHeight)];
        [self.playerController.moviePlayer updatePlayerFrame: CGRectMake(0, 0, screenWidth * (1 - HeightPre/ 2)  , config.topPlayerHeight * (1 - HeightPre / 2))];
        [self.detailView setFrame:CGRectMake(0, config.topPlayerHeight * (1 - HeightPre / 2), self.detailView.frame.size.width  , self.detailView.frame.size.height)];
    }
    
    if(self.playerController.view.frame.origin.y < screenHeight / 2)
        [self.detailView setAlpha:1 - (self.playerController.view.frame.origin.y / (screenHeight / 2))];
    else
        [self.detailView setAlpha:0];
    
    [self backgroundAlphaChange:1 - (self.playerController.view.frame.origin.y / screenHeight)];
}

-(void)movingSwipeLeft:(CGPoint)translatedPoint
{
    [self.playerController.view setFrame:CGRectMake((screenWidth / 2) + translatedPoint.x ,  self.playerController.view.frame.origin.y, self.playerController.view.frame.size.width, self.playerController.view.frame.size.height)];
    [self.playerController.view setAlpha: 1 + ((translatedPoint.x / (screenWidth / 2))) / 2];
}

-(void)movingSwipeHorizontal:(CGPoint)translatedPoint
{
    [self.playerController.view setFrame:CGRectMake((screenWidth / 2) + translatedPoint.x ,  self.playerController.view.frame.origin.y, self.playerController.view.frame.size.width, self.playerController.view.frame.size.height)];
    
    CGFloat alpha = 1 + ((translatedPoint.x / (screenWidth / 2))) / 2;
    if(self.swipeState == FWSwipeRight)
        alpha = 1 - ((translatedPoint.x / (screenWidth / 2))) / 2;
    [self.playerController.view setAlpha: alpha];
}

-(void)updateSwipeState:(CGPoint)translatedPoint
{
    self.swipeState = FWSwipeNone;
    
    if(isSmall && !isVertical)
    {
        if((translatedPoint.x < 0 && fabs(translatedPoint.x) > screenWidth / 5) || (translatedPoint.x > 0 && fabs(self.playerController.view.frame.origin.x) > screenWidth / 2 + screenWidth / 4))
        {
            if(translatedPoint.x < 0)
                self.swipeState = FWSwipeLeft;
            else
                self.swipeState = FWSwipeRight;
        }
        else
            self.swipeState = FWSwipeNone;
    }
    else if(self.playerController.view.frame.origin.y > screenHeight / 2 - config.miniPlayerHeight)
        self.swipeState = FWSwipeDown;
    else if(self.playerController.view.frame.origin.y <= screenHeight / 2 - config.miniPlayerHeight)
        self.swipeState = FWSwipeUp;
}

-(void)updateEndingMovingFrame
{
    switch (self.swipeState) {
        case FWSwipeLeft:
        case FWSwipeRight:
            [self endingSwipeHorizontal];
            break;
        case FWSwipeDown:
        case FWSwipeUp:
            [self endingSwipeVertical];
            break;
        case FWSwipeNone:
            [self endingSwipeNone];
            break;
        default:
            break;
    }
    
    isVertical = NO;
    isHorizontal = NO;
}

-(void)endingSwipeHorizontal
{
    isAnimation = YES;
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.playerController.view setFrame:CGRectMake((self.swipeState == FWSwipeLeft)? 0 : screenWidth , config.maxVerticalMovingHeight - config.miniPlayerHeight, screenWidth, screenHeight)];
        [self.playerController.view setAlpha:0];
    } completion:^(BOOL finished){
        if(finished)
        {
            isAnimation = NO;
            isSmall = NO;
            self.playerController.view.frame = CGRectMake(0 , 0, screenWidth, screenHeight);
            [self.playerController.moviePlayer stopAndRemove];
            self.playerController = nil;
        }
    }];
}


- (void)endingSwipeVertical
{
    isAnimation = YES;
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        if(self.swipeState == FWSwipeUp )
        {
            [self.playerController.view setFrame:CGRectMake(0 , 0, screenWidth, screenHeight)];
            [self.playerController.moviePlayer updatePlayerFrame:CGRectMake(0 , 0, screenWidth, config.topPlayerHeight)];
            [self.detailView setFrame:CGRectMake(0 , config.topPlayerHeight, self.detailView.frame.size.width , self.detailView.frame.size.height)];
            [self.detailView setAlpha:1];
       }
       else
       {
           [self.playerController.view setFrame:CGRectMake(screenWidth / 2 , config.maxVerticalMovingHeight - config.miniPlayerHeight, screenWidth, screenHeight)];
           [self.playerController.moviePlayer updatePlayerFrame:CGRectMake(0 , 0, screenWidth / 2, config.topPlayerHeight / 2)];
           [self backgroundAlphaChange:0];
           [self.detailView setAlpha:0];
       }
           
    } completion:^(BOOL finished){
        if(finished)
        {
            isAnimation = NO;
            if(isSmall != ( self.swipeState == FWSwipeDown ))
            {
                isSmall = ( self.swipeState == FWSwipeDown );
                [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isSmall] , @"isSmall",[NSNumber numberWithBool:isLock] , @"isLock",nil]] ;
            }
        }
    }];
}

- (void)endingSwipeNone
{
    isAnimation = YES;
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        [self.playerController.view setFrame:CGRectMake(screenWidth / 2 , config.maxVerticalMovingHeight - config.miniPlayerHeight, screenWidth, screenHeight)];
        [self.playerController.view setAlpha:1];
        [self.playerController.moviePlayer updatePlayerFrame:CGRectMake(0 , 0, screenWidth / 2, config.miniPlayerHeight)];
    } completion:^(BOOL finished){
        if(finished)
        {
            isAnimation = NO;
            isSmall = YES;
            [self.detailView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        }
    }];
}

- (void)swipe:(id)sender
{
    [self.playerController.moviePlayer swipe:sender];
}

#pragma mark UIDeviceOrientationDidChangeNotification
- (void)UIDeviceOrientationDidChangeNotification:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight )
    {
        if(!isAnimation && !isSmall )
        {
            if(config.draggable)
                [self.playerController.moviePlayer.view  removeGestureRecognizer:dragRecognizer];
            [self.playerController.moviePlayer.view  addGestureRecognizer:swipeRecognizer];
            [self.detailView setAlpha:0];
        }
    }
    else if(orientation == UIDeviceOrientationPortrait)
    {
        if(!isAnimation && !isSmall && !isLock)
        {
            if(config.draggable)
                [self.playerController.moviePlayer.view  addGestureRecognizer:dragRecognizer];
            [self.playerController.moviePlayer.view  removeGestureRecognizer:swipeRecognizer];
            [self.detailView setAlpha:1];
        }
    }
}

- (void)printValue
{
    NSLog(@"isSmall %d\n",isSmall);
    NSLog(@"isAnimation %d\n",isAnimation);
    NSLog(@"isVertical %d\n", isVertical);
    NSLog(@"isHorizontal %d\n", isHorizontal);
}

- (void)exit
{
    [self.playerController stopAndRemove];
    self.playerController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

#pragma player delegate

- (void)collapseBtnOnClick:(id)sender
{
    if(config.draggable)
    {
        if(!isSmall)
        {
            self.swipeState = FWSwipeDown;
            [self updateEndingMovingFrame];
        }
        else
        {
            self.swipeState = FWSwipeUp;
            [self updateEndingMovingFrame];
        }
    }
}

-(void)shareBtnOnClick:(id)sender
{
    NSLog(@"shareBtnOnClick");
}

-(void)tapInside:(id)sender
{
    if(isSmall)
    {
        self.swipeState = FWSwipeUp;
       [self endingSwipeVertical];
    }
}

- (void)playBtnOnClick:(id)sender
{
    NSLog(@"playBtnOnClick");
}

- (void)fullScreenBtnOnClick:(id)sender
{
    NSLog(@"fullScreenBtnOnClick");
}

- (void)nextEpisodeBtnOnClick:(id)sender
{
    NSLog(@"nextEpisodeBtnOnClick");
}

- (void)videoTypeBtnOnClick:(id)sender
{
    NSLog(@"videoTypeBtnOnClick");
}

- (void)lockScreenBtnOnClick:(id)sender
{
    isLock = !isLock;
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSwipePlayerViewStateChange object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:isSmall],@"isSmall",[NSNumber numberWithBool:isLock],@"isLock",nil] ];
}

- (void)episodeBtnOnClick:(id)sender
{
    NSLog(@"episodeBtnOnClick");
}

-(void)subtitleBtnOnClick:(id)sender
{
    NSLog(@"subtitleBtnOnClick");
}

-(void)channelBtnOnClick:(id)sender
{
    NSLog(@"channelBtnOnClick");
}

- (void)didFinishPlay:(NSURL*)url
{
    NSLog(@"didFinishPlay");
}

@end
