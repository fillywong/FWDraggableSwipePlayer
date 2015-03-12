//
//  FWSwipePlayerNavLayer.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 9/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerLayer.h"
#import "FWSwipePlayerConfig.h"

@protocol FWSwipePlayerNavLayerDelegate <NSObject>

-(void)doneBtnOnClick:(id)sender;
-(void)collapseBtnOnClick:(id)sender;
-(void)settingBtnOnClick:(id)sender;
-(void)shareBtnOnClick:(id)sender;
-(void)chapterMarkBtnOnClick:(id)sender;
-(void)lockScreenBtnOnClick:(id)sender;

@end

@interface FWSwipePlayerNavLayer : FWSwipePlayerLayer
@property (nonatomic, assign)id<FWSwipePlayerNavLayerDelegate> delegate;
@property (nonatomic, strong) UIButton *lockScreenBtn;
- (id)initLayerAttachTo:(UIView *)view config:(FWSwipePlayerConfig*)configuration;
- (void)orientationChange:(UIDeviceOrientation)orientation;
@end
