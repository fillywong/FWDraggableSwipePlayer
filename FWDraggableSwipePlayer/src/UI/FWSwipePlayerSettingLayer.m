//
//  FWSwipePlayerSettingLayer.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerSettingLayer.h"
#import "FWPlayerColorUtil.h"

@interface FWSwipePlayerSettingLayer()
{
    FWPlayerColorUtil *colorUtil;
    
    UIImageView *settingView;
    UILabel *subtitleBtnLabel;
    UILabel *channelBtnLabel;
    UILabel *videoTypeBtnLabel;
    UILabel *episodeTypeBtnLabel;
    UILabel *subtitleValueLabel;
    UILabel *channelValueLabel;
    UILabel *videoTypeValueLabel;
    UILabel *episodeValueLabel;
    UIButton *subtitleBtn;
    UIButton *channelBtn;
    UIButton *videoTypeBtn;
    UIButton *settingViewCloseBtn;
    UIButton *episodeBtn;
}

@end

@implementation FWSwipePlayerSettingLayer

- (id)initLayerAttachTo:(UIView *)view
{
    self = [super initLayerAttachTo:view];
    if(self)
    {
        colorUtil = [[FWPlayerColorUtil alloc]init];
        [self configSettingView];
    }
    return self;
}

-(void)configSettingView
{
    settingView = [[UIImageView alloc] init];
    settingView.userInteractionEnabled = YES;
    settingView.backgroundColor = [colorUtil colorWithHex:@"#000000" alpha:0.5];
    
    subtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [subtitleBtn addTarget:self action:@selector(subtitleBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [subtitleBtn setTitle:NSLocalizedString(@"subtitle", @"subtitle") forState:UIControlStateNormal];
    subtitleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    subtitleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleBtn.layer.borderWidth = 1;
    subtitleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:subtitleBtn];
    
    channelBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [channelBtn addTarget:self action:@selector(channelBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [channelBtn setTitle:NSLocalizedString(@"channel", @"channel") forState:UIControlStateNormal];
    channelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    channelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    channelBtn.layer.borderWidth = 1;
    channelBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:channelBtn];
    
    videoTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [videoTypeBtn addTarget:self action:@selector(videoTypeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [videoTypeBtn setTitle:NSLocalizedString(@"quality", @"quality") forState:UIControlStateNormal];
    videoTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    videoTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    videoTypeBtn.layer.borderWidth = 1;
    videoTypeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:videoTypeBtn];
    
    episodeBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [episodeBtn addTarget:self action:@selector(episodeBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [episodeBtn setTitle:NSLocalizedString(@"episode", @"episode") forState:UIControlStateNormal];
    episodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    episodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    episodeBtn.layer.borderWidth = 1;
    episodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:episodeBtn];
    
    settingViewCloseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [settingViewCloseBtn addTarget:self action:@selector(settingViewCloseBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [settingViewCloseBtn setTitle:NSLocalizedString(@"done", @"done")  forState:UIControlStateNormal];
    [settingViewCloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingViewCloseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    settingViewCloseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    settingViewCloseBtn.layer.borderWidth = 1;
    settingViewCloseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:settingViewCloseBtn];
    
    subtitleBtnLabel = [[UILabel alloc] init];
    subtitleBtnLabel.text = NSLocalizedString(@"Subtitle", @"subtitle")  ;
    subtitleBtnLabel.font = [UIFont systemFontOfSize:12];
    subtitleBtnLabel.textAlignment = NSTextAlignmentCenter;
    subtitleBtnLabel.textColor = [UIColor whiteColor];
    subtitleBtnLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:subtitleBtnLabel];
    
    channelBtnLabel = [[UILabel alloc] init];
    channelBtnLabel.text = NSLocalizedString(@"Channel", @"channel");
    channelBtnLabel.font = [UIFont systemFontOfSize:12];
    channelBtnLabel.textAlignment = NSTextAlignmentCenter;
    channelBtnLabel.textColor = [UIColor whiteColor];
    channelBtnLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:channelBtnLabel];
    
    videoTypeBtnLabel = [[UILabel alloc] init];
    videoTypeBtnLabel.text = NSLocalizedString(@"Quality", @"quality");
    videoTypeBtnLabel.font = [UIFont systemFontOfSize:12];
    videoTypeBtnLabel.textAlignment = NSTextAlignmentCenter;
    videoTypeBtnLabel.textColor = [UIColor whiteColor];
    videoTypeBtnLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:videoTypeBtnLabel];
    
    episodeTypeBtnLabel = [[UILabel alloc] init];
    episodeTypeBtnLabel.text = NSLocalizedString(@"Episode", @"episode");
    episodeTypeBtnLabel.font = [UIFont systemFontOfSize:12];
    episodeTypeBtnLabel.textAlignment = NSTextAlignmentCenter;
    episodeTypeBtnLabel.textColor = [UIColor whiteColor];
    episodeTypeBtnLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:episodeTypeBtnLabel];
   
    
    episodeValueLabel = [[UILabel alloc] init];
    episodeValueLabel.text = @"one" ;
    episodeValueLabel.font = [UIFont systemFontOfSize:16];
    episodeValueLabel.textAlignment = NSTextAlignmentCenter;
    episodeValueLabel.textColor = [UIColor whiteColor];
    episodeValueLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:episodeValueLabel];
    
    subtitleValueLabel = [[UILabel alloc] init];
    subtitleValueLabel.text =  @"English" ;
    subtitleValueLabel.font = [UIFont systemFontOfSize:16];
    subtitleValueLabel.textAlignment = NSTextAlignmentCenter;
    subtitleValueLabel.textColor = [UIColor whiteColor];
    subtitleValueLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:subtitleValueLabel];
    
    channelValueLabel = [[UILabel alloc] init];
    channelValueLabel.text = @"English" ;
    channelValueLabel.font = [UIFont systemFontOfSize:16];
    channelValueLabel.textAlignment = NSTextAlignmentCenter;
    channelValueLabel.textColor = [UIColor whiteColor];
    channelValueLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:channelValueLabel];
    
    videoTypeValueLabel = [[UILabel alloc] init];
    videoTypeValueLabel.text = @"HD";
    videoTypeValueLabel.font = [UIFont systemFontOfSize:16];
    videoTypeValueLabel.textAlignment = NSTextAlignmentCenter;
    videoTypeValueLabel.textColor = [UIColor whiteColor];
    videoTypeValueLabel.backgroundColor = [UIColor clearColor];
    [settingView addSubview:videoTypeValueLabel];
    
    [self.layerView addSubview:settingView];
}

- (void)updateFrame:(CGRect)frame
{
    [super updateFrame:frame];
    settingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    channelBtn.frame = CGRectMake(settingView.frame.size.width / 2 - 50 - 16, settingView.frame.size.height / 2 - 16, 50, 22);
    episodeBtn.frame = CGRectMake(channelBtn.frame.origin.x - channelBtn.frame.size.width - 16 , channelBtn.frame.origin.y, 50, 22);
    
    videoTypeBtn.frame = CGRectMake(channelBtn.frame.origin.x + 50 + 16, channelBtn.frame.origin.y, 50, 22);
    subtitleBtn.frame = CGRectMake(videoTypeBtn.frame.origin.x + videoTypeBtn.frame.size.width +  16 , channelBtn.frame.origin.y, 50, 22);
    settingViewCloseBtn.frame = CGRectMake(settingView.frame.size.width - 12 - 44, 12, 44, 22);
    
    subtitleBtnLabel.frame = CGRectMake(subtitleBtn.frame.origin.x, subtitleBtn.frame.origin.y - 15, subtitleBtn.frame.size.width, 15);
    channelBtnLabel.frame = CGRectMake(channelBtn.frame.origin.x, channelBtn.frame.origin.y - 15, channelBtn.frame.size.width, 15);
    videoTypeBtnLabel.frame = CGRectMake(videoTypeBtn.frame.origin.x, videoTypeBtn.frame.origin.y - 15, videoTypeBtn.frame.size.width, 15);
    episodeTypeBtnLabel.frame = CGRectMake(episodeBtn.frame.origin.x, episodeBtn.frame.origin.y - 15, episodeBtn.frame.size.width, 15);
    
    channelValueLabel.frame = CGRectMake(channelBtn.frame.origin.x - 10, channelBtn.frame.origin.y + channelBtn.frame.size.height, channelBtn.frame.size.width + 20, 23);
    subtitleValueLabel.frame = CGRectMake(subtitleBtn.frame.origin.x - 10, subtitleBtn.frame.origin.y + subtitleBtn.frame.size.height, subtitleBtn.frame.size.width + 20, 23);
    videoTypeValueLabel.frame = CGRectMake(videoTypeBtn.frame.origin.x - 10, videoTypeBtn.frame.origin.y + videoTypeBtn.frame.size.height, videoTypeBtn.frame.size.width + 20, 23);
    episodeValueLabel.frame = CGRectMake(episodeBtn.frame.origin.x - 10, episodeBtn.frame.origin.y + episodeBtn.frame.size.height, episodeBtn.frame.size.width + 20, 23);
}

-(void)disappear
{
    [super disappear];
    [super remove];
    [settingView setHidden:YES];
}

- (void)show
{
    [super show];
    [super attach];
    [settingView setHidden:NO];
}

-(void)subtitleBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(subtitleBtnOnClick:)])
            [self.delegate subtitleBtnOnClick:sender];
}

-(void)channelBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(channelBtnOnClick:)])
            [self.delegate channelBtnOnClick:sender];
}

-(void)videoTypeBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(videoTypeBtnOnClick:)])
            [self.delegate videoTypeBtnOnClick:sender];
}

-(void)settingViewCloseBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(settingViewCloseBtnOnClick:)])
            [self.delegate settingViewCloseBtnOnClick:sender];
}

-(void)episodeBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(episodeBtnOnClick:)])
            [self.delegate episodeBtnOnClick:sender];
}


@end
