//
//  FWSwipePlayerBottomLayer.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerBottomLayer.h"
#import "FWPlayerProgressSlider.h"
#import "FWPlayerColorUtil.h"

@interface FWSwipePlayerBottomLayer()
{
    FWPlayerColorUtil *colorUtil;
}

@end

@implementation FWSwipePlayerBottomLayer

@synthesize bottomView, sliderProgress, cacheProgress, currentPlayTimeLabel, remainPlayTimeLabel, fullScreenBtn;

- (id)initLayerAttachTo:(UIView *)view
{
    self = [super initLayerAttachTo:view];
    if(self)
    {
        colorUtil = [[FWPlayerColorUtil alloc]init];
        [self configBottomView];
    }
    return self;
}

- (void)configBottomView
{
    bottomView = [[UIImageView alloc] init];
    [colorUtil setGradientWhiteToBlackColor:bottomView];
    bottomView.userInteractionEnabled = YES;
    
    fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"play_mini_p"] forState:UIControlStateNormal];
    [fullScreenBtn addTarget:self action:@selector(fullScreenOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:fullScreenBtn];
    
    currentPlayTimeLabel = [[UILabel alloc] init];
    currentPlayTimeLabel.font = [UIFont systemFontOfSize:12];
    currentPlayTimeLabel.textColor = [UIColor whiteColor];
    currentPlayTimeLabel.backgroundColor = [UIColor clearColor];
    currentPlayTimeLabel.text = @"--:--";
    currentPlayTimeLabel.textAlignment = NSTextAlignmentLeft;
    
    [bottomView addSubview:currentPlayTimeLabel];
    
    remainPlayTimeLabel = [[UILabel alloc] init];
    remainPlayTimeLabel.font = [UIFont systemFontOfSize:12];
    remainPlayTimeLabel.textColor = [UIColor whiteColor];
    remainPlayTimeLabel.backgroundColor = [UIColor clearColor];
    remainPlayTimeLabel.text = @"--:--";
    remainPlayTimeLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:remainPlayTimeLabel];
    
    cacheProgress = [[FWPlayerProgressSlider alloc] init];
    cacheProgress.minimumTrackTintColor = [colorUtil colorWithHex:@"#000000" alpha:0.50];
    [cacheProgress setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [bottomView addSubview:cacheProgress];
    
    sliderProgress = [[FWPlayerProgressSlider alloc] init];
    sliderProgress.minimumTrackTintColor = [UIColor orangeColor];
    sliderProgress.maximumTrackTintColor = [colorUtil colorWithHex:@"#000000" alpha:0.50];
    sliderProgress.thumbTintColor = [colorUtil colorWithHex:@"#000000" alpha:0.50];
    [sliderProgress setThumbImage:[UIImage imageNamed:@"api_scrubber_selected"] forState:UIControlStateNormal];
    [sliderProgress setThumbImage:[UIImage imageNamed:@"api_scrubber_selected"] forState:UIControlStateHighlighted];
    [sliderProgress addTarget:self action:@selector(changePlayerProgress:) forControlEvents:UIControlEventValueChanged];
    [sliderProgress addTarget:self action:@selector(progressTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside | UIControlEventTouchDragExit | UIControlEventTouchCancel];
    [sliderProgress addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:sliderProgress];
    
    [self.layerView addSubview:bottomView];
}

- (void)updateFrame:(CGRect)frame
{
    [super updateFrame:frame];
    bottomView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    bottomView.layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    fullScreenBtn.frame = CGRectMake(bottomView.frame.size.width - 22 - 20, 0 , 40, 40);
    currentPlayTimeLabel.frame = CGRectMake(12,bottomView.frame.size.height - 8 - 9, 32, 9);
    remainPlayTimeLabel.frame = CGRectMake(fullScreenBtn.frame.origin.x - 12 - currentPlayTimeLabel.frame.size.width, currentPlayTimeLabel.frame.origin.y, currentPlayTimeLabel.frame.size.width, currentPlayTimeLabel.frame.size.height);
    cacheProgress.frame = CGRectMake(currentPlayTimeLabel.frame.size.width + currentPlayTimeLabel.frame.origin.x + 5, bottomView.frame.size.height - 4 - 10, remainPlayTimeLabel.frame.origin.x - currentPlayTimeLabel.frame.size.width - currentPlayTimeLabel.frame.origin.x - 10, 4);
    sliderProgress.frame = CGRectMake(cacheProgress.frame.origin.x, cacheProgress.frame.origin.y, cacheProgress.frame.size.width, 30);
}

-(void)fullScreenOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(fullScreenOnClick:)])
            [self.delegate fullScreenOnClick:sender];
}

-(void)changePlayerProgress:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(changePlayerProgress:)])
            [self.delegate changePlayerProgress:sender];
}

-(void)progressTouchUp:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(progressTouchUp:)])
            [self.delegate progressTouchUp:sender];
}

-(void)progressTouchDown:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(progressTouchDown:)])
            [self.delegate progressTouchDown:sender];
}

@end
