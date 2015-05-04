//
//  MovieDetailView.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "MovieDetailView.h"

@implementation MovieDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initWithInfo:(NSDictionary *)dic
{
    titleLabel = [[UILabel alloc] init];
    [titleLabel setNumberOfLines:0];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:[dic objectForKey:@"title" ]];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel sizeToFit];
    
    descLabel = [[UILabel alloc] init];
    [descLabel setBackgroundColor:[UIColor clearColor]];
    [descLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [descLabel setNumberOfLines:0];
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel sizeToFit];
    [descLabel setText:[dic objectForKey:@"desc"]];
    
    [self.scrollView addSubview:titleLabel] ;
    [self.scrollView addSubview:descLabel] ;
    [self addSubview:self.scrollView];
    
}

-(void)updateFrame:(CGRect)frame
{
    self.frame = frame;
    titleLabel.frame = CGRectMake(10, 10, frame.size.width - 20, 30);
    descLabel.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + CGRectGetHeight(titleLabel.frame), frame.size.width - 20, 100);
    self.scrollView.frame = CGRectMake(0, 0, frame.size.width , frame.size.height);
}

-(void)updateAlpha:(CGFloat)alpha
{
    [self setAlpha:alpha];
}

@end
