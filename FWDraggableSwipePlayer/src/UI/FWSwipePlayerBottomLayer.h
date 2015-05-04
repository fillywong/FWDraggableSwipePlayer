//
//  FWSwipePlayerBottomLayer.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerLayer.h"
#import "FWPlayerProgressSlider.h"

@protocol FWSwipePlayerBottomLayerDelegate <NSObject>

-(void)fullScreenOnClick:(id)sender;
-(void)changePlayerProgress:(id)sender;
-(void)progressTouchUp:(id)sender;
-(void)progressTouchDown:(id)sender;

@end

@interface FWSwipePlayerBottomLayer : FWSwipePlayerLayer

@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) FWPlayerProgressSlider *sliderProgress;
@property (nonatomic, strong) FWPlayerProgressSlider *cacheProgress;
@property (nonatomic, strong) UILabel *currentPlayTimeLabel;
@property (nonatomic, strong) UILabel *remainPlayTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, assign)id<FWSwipePlayerBottomLayerDelegate> delegate;



@end
