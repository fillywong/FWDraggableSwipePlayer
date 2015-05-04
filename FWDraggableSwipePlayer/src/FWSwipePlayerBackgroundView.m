//
//  FWSwipePlayerBackgroundView.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerBackgroundView.h"

@implementation FWSwipePlayerBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        CGFloat screenWidth = screenRect.size.width;
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


@end
