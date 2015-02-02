//
//  MovieDetailView.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailView : UIView
{
    UILabel *titleLabel ;
    UILabel *descLabel ;
}
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)initWithInfo:(NSDictionary *)dic;
- (void)updateFrame:(CGRect)frame;
- (void)updateAlpha:(CGFloat)alpha;
@end
