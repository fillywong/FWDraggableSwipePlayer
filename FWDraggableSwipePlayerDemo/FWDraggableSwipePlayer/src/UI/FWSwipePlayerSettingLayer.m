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
    UIButton *settingViewCloseBtn;
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
    
    settingViewCloseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    [settingViewCloseBtn addTarget:self action:@selector(settingViewCloseBtnOnClick:)forControlEvents:UIControlEventTouchUpInside];
    [settingViewCloseBtn setTitle:NSLocalizedString(@"done", @"done")  forState:UIControlStateNormal];
    [settingViewCloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settingViewCloseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    settingViewCloseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    settingViewCloseBtn.layer.borderWidth = 1;
    settingViewCloseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [settingView addSubview:settingViewCloseBtn];
    
    
    [self.layerView addSubview:settingView];
}

- (void)updateFrame:(CGRect)frame
{
    [super updateFrame:frame];
    settingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    settingViewCloseBtn.frame = CGRectMake(settingView.frame.size.width - 12 - 44, 12, 44, 22);
    
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


-(void)settingViewCloseBtnOnClick:(id)sender
{
    if(self.delegate)
        if([self.delegate respondsToSelector:@selector(settingViewCloseBtnOnClick:)])
            [self.delegate settingViewCloseBtnOnClick:sender];
}


@end
