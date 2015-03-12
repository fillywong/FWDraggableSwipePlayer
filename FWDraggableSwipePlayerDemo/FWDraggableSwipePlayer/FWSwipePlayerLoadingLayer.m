//
//  FWSwipePlayerLoadingLayer.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerLoadingLayer.h"
@interface FWSwipePlayerLoadingLayer ()
{
    UIImageView *loadingBgImageView;
    UIActivityIndicatorView *loadingActiviy;
    UILabel *loadingLabel;
    
}

@end

@implementation FWSwipePlayerLoadingLayer

- (id)initLayerAttachTo:(UIView *)view
{
    self = [super initLayerAttachTo:view];
    if(self)
    {
        [self configLoadingPage];
    }
    return self;
}

-(void)configLoadingPage
{
    loadingBgImageView = [[UIImageView alloc] init];
    loadingBgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"player_guideImg_p" ofType:@"png"]];
    [self.layerView addSubview:loadingBgImageView];
    
    loadingActiviy = [[UIActivityIndicatorView alloc] init];
    loadingActiviy.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [loadingActiviy startAnimating];
    [self.layerView addSubview:loadingActiviy];
    
    loadingLabel = [[UILabel alloc] init];
    loadingLabel.text = NSLocalizedString(@"loading", @"loading..") ;
    loadingLabel.font = [UIFont systemFontOfSize:12];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [self.layerView addSubview:loadingLabel];
    
}

-(void)attach
{
    [super attach];
    loadingLabel.text = NSLocalizedString(@"loading", @"loading");
}

-(void)remove
{
    [super remove];
    loadingBgImageView.image = [[UIImage alloc]init];
}

- (void)updateFrame:(CGRect)frame
{
    [super updateFrame:frame];
    loadingActiviy.frame = CGRectMake(frame.size.width/2 - 15, frame.size.height/2 - 15, 35, 35);
    loadingLabel.frame = CGRectMake(frame.size.width/2 - 100, frame.size.height/2 + 15, 200, 30);
    loadingBgImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)updateLoadingText:(NSString*)text
{
    loadingLabel.text = text;
}

@end
