//
//  FWS2ipePlayerConfig.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FWSwipePlayerConfig : NSObject

@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, assign) BOOL rotatable;
@property (nonatomic, assign) BOOL autoplay;
@property (nonatomic, assign) int miniPlayerHeight;
@property (nonatomic, assign) int miniPlayerWidth;
@property (nonatomic, assign) int topPlayerHeight;
@property (nonatomic, assign) int maxVerticalMovingHeight;
@property (nonatomic, assign) int maxHorizontalMovingWidth;
@property (nonatomic, assign) int autoPlayLabelShowTime;
@property (nonatomic, strong) NSString *currentVideoTitle;
@property (nonatomic, strong) NSString *defaultSubtitle;
@property (nonatomic, strong) NSString *defaultQuality;
@property (nonatomic, strong) NSString *defaultChannel;

@end
