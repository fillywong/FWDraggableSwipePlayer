//
//  FWSwipePlayerLayer.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 6/3/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FWSwipePlayerLayer : NSObject

@property (nonatomic, strong)  UIView *rootView;
@property (nonatomic , strong) UIView* layerView;

- (id)initLayerAttachTo:(UIView*)view;
- (void)attach;
- (void)remove;
- (void)updateFrame:(CGRect)frame;
- (CGRect)frame;
- (void)addSubview:(UIView*)view;
- (void)disappear;
- (void)show;
@end
