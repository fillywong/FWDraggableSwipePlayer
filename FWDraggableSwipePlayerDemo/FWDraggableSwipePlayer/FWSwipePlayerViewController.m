//
//  FWSwipePlayerViewController.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSwipePlayerViewController.h"

@interface FWSwipePlayerViewController ()
{
    NSDictionary *infoDict;
    FWSWipePlayerConfig *config;
    NSArray *dataList;
}

@end

@implementation FWSwipePlayerViewController

-(id)init
{
    self = [super init];
    if(self)
    {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)updateMoviePlayerWithInfo:(NSDictionary * )dict
{
    [self updateMoviePlayerWithInfo:dict Config:[[FWSWipePlayerConfig alloc]init]];
}

-(void)updateMoviePlayerWithInfo:(NSDictionary * )dict Config:(FWSWipePlayerConfig*)configuration
{
    infoDict = dict;
    config = configuration;
    
    [self configPlayer];
}

- (void)updateMoviePlayerWithVideoList:(NSArray * )list Config:(FWSWipePlayerConfig*)configuration
{
    dataList = list;
    infoDict = list[0];
    config = configuration;
    [self configPlayer];
}

-(void)configPlayer
{
    if(self.moviePlayer != nil)
        self.moviePlayer = nil;
    config.currentVideoTitle = [infoDict objectForKey:@"title"];
    if(dataList)
    {
            //[self playWithSubtitles:subtitles currentSubtitle:currentSubtitle channels:channels currentChannel:currentChannel startAt:time];
            
            self.moviePlayer = [[FWSwiperPlayerController alloc]initWithContentDataList:dataList andConfig:config];
        
    }
    else
        self.moviePlayer = [[FWSwiperPlayerController alloc]initWithContentURL:[NSURL URLWithString: [infoDict objectForKey:@"url"]] andConfig:config];
    [self.moviePlayer updatePlayerFrame:CGRectMake(0, 0, self.view.frame.size.width, config.topPlayerHeight)];
    [self.view addSubview: self.moviePlayer.view];
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}


@end
