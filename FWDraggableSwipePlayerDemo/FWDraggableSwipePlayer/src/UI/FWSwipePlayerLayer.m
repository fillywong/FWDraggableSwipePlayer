//
//  FWSwipePlayerLayer.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerLayer.h"

@interface FWSwipePlayerLayer ()
{
    @protected
        UIView *layerView;
        UIView *rootView;
}


@end

@implementation FWSwipePlayerLayer
@synthesize layerView;
@synthesize rootView;

- (id)initLayerAttachTo:(UIView*)view
{
    self = [super init];
    if(self)
    {
        rootView = view;
        layerView = [[UIView alloc]init];
    }
    return self;
}

-(void)attach
{
    [self.rootView addSubview:layerView];
}

-(void)remove
{
    [layerView removeFromSuperview];
}

- (void)updateFrame:(CGRect)frame
{
    layerView.frame = frame;
}

- (CGRect)frame
{
    return layerView.frame;
}

- (void)addSubview:(UIView*)view
{
    [layerView addSubview:view ];
}

- (void)disappear
{
    layerView.alpha = 0;
}

- (void)show
{
    layerView.alpha = 1;
}

@end
