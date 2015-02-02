//
//  FWVideoTypeSelectView.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 26/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWVideoTypeSelectView.h"

@implementation FWVideoTypeSelectView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.listView setSeparatorColor:[UIColor clearColor]];
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell"];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = self.listView.backgroundColor;
    cell.textLabel.text = self.datalist[[indexPath row]][@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:9];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

@end
