//
//  FWSWipePlayerConfig.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerConfig.h"
@implementation FWSwipePlayerConfig

@synthesize draggable, rotatable, autoplay, miniPlayerHeight, miniPlayerWidth, maxVerticalMovingHeight, maxHorizontalMovingWidth;

-(id)init
{
    self = [super init];
    if(self)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        self.draggable = YES;
        self.rotatable = YES;
        self.autoplay = YES;
        self.topPlayerHeight = screenWidth / 16 * 9 ;
        self.miniPlayerHeight = self.topPlayerHeight / 2;
        self.miniPlayerWidth = screenWidth / 2;
        self.maxVerticalMovingHeight = screenHeight;
        self.maxHorizontalMovingWidth = screenWidth;
        self.autoPlayLabelShowTime = 3;
        self.currentVideoTitle = @"";
        self.defaultSubtitle = @"tc";
        self.defaultQuality = @"hd";
        self.defaultChannel = @"Cantonese";
    }
    return self;
}

@end
