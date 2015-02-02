//
//  FWSelectView.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 23/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWPlayerColorUtil.h"
extern NSString *FWSelectViewOnClick ;

@interface FWSelectView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *listView;
@property (nonatomic, strong)NSArray *datalist;

- (void)reloadSelectViewWithArray:(NSArray*)list;
- (void)reloadSelectViewWithArray:(NSArray*)list withSectionTitle:(NSString*)title;
- (void)updateFrame:(CGRect)frame;

@end
