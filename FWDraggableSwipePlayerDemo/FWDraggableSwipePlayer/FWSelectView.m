//
//  FWSelectView.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 23/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWSelectView.h"

NSString *FWSelectViewOnClick  = @"FWSelectViewOnClick";

@interface FWSelectView()
{
    FWPlayerColorUtil *colorUtil;
    NSString *sectionTitle;
}

@end

@implementation FWSelectView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self configValue];
        [self configListView];
    }
    return self;
}

-(void)configValue
{
    colorUtil = [[FWPlayerColorUtil alloc]init];
    sectionTitle = @"";
}

-(void)configListView
{
    self.listView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.listView setBackgroundColor:[colorUtil colorWithHex:@"#000000" alpha:0.2]];
    [self.listView setSeparatorColor:[colorUtil colorWithHex:@"#F0F0F0" alpha:0.3]];
    [self addSubview:self.listView];
    self.datalist = nil;
}

-(void)reloadSelectViewWithArray:(NSArray*)list
{
    [self reloadSelectViewWithArray:list withSectionTitle:@""];
}

-(void)reloadSelectViewWithArray:(NSArray*)list withSectionTitle:(NSString*)title
{
    self.datalist = list;
    sectionTitle = title;
    [self.listView reloadData];
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.datalist)
        return [self.datalist count];
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([sectionTitle isEqualToString: @""])
        return 0;
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    view.backgroundColor = self.backgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
    label.text = sectionTitle;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    return view;
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    if([sectionTitle isEqualToString:@""])
        return nil;
    
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc]init];
    view.textLabel.text = sectionTitle;
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tablecell"];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tablecell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = self.listView.backgroundColor;
    if(self.datalist[[indexPath row]][@"title"])
        cell.textLabel.text = self.datalist[[indexPath row]][@"title"];
    else if(self.datalist[[indexPath row]][@"lang"])
        cell.textLabel.text = self.datalist[[indexPath row]][@"lang"];
    else
        cell.textLabel.text = @"";
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor whiteColor];
    if([indexPath row] == 0)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:FWSelectViewOnClick object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath",tableView,@"tableView",nil] ] ;
}

- (void)updateFrame:(CGRect)frame
{
    self.frame = frame;
    self.listView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

@end
