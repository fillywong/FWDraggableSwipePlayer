//
//  FWPlayerColorUtil.m
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 21/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import "FWPlayerColorUtil.h"

@implementation FWPlayerColorUtil

-(void)setGradientBlackToWhiteColor:(UIView*)view withFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0 green:0 blue:0 alpha: 0.2].CGColor,
                       (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha: 0.2].CGColor,
                       (id)[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha: 0.2].CGColor,
                       (id)[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha: 0].CGColor,nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

-(void)setGradientBlackToWhiteColor:(UIView*)view
{
    [self setGradientBlackToWhiteColor:view withFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
}

-(void)setGradientWhiteToBlackColor:(UIView*)view withFrame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha: 0].CGColor,
                       (id)[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha: 0.2].CGColor,
                       (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha: 0.2].CGColor,
                       (id)[UIColor colorWithRed:0 green:0 blue:0 alpha: 0.2].CGColor,nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

-(void)setGradientWhiteToBlackColor:(UIView*)view
{
    [self setGradientWhiteToBlackColor:view withFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    return [self colorWithHex:hexString alpha:1.0];
}

- (UIColor *)colorWithHex:(NSString *)hexValue alpha:(float)alpha
{
    unsigned rgb = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];
    if ([hexValue characterAtIndex:0] == '#') {
        [scanner setScanLocation:1];
    }
    [scanner scanHexInt:&rgb];
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16)/255.0
                           green:((rgb & 0xFF00) >> 8)/255.0
                            blue:(rgb & 0xFF)/255.0
                           alpha:alpha];
}

@end
