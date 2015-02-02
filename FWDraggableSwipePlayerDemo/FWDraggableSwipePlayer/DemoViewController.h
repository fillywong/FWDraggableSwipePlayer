//
//  DemoViewController.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 20/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWDraggablePlayerManager.h"
#import "FWSwipePlayerViewController.h"

extern NSString *FWSwipePlayerViewStateChange;

@interface DemoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listView;
@property (nonatomic, strong) FWDraggablePlayerManager *playerManager;

@end
