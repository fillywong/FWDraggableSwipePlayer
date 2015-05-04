//
//  FWPlayerColorUtil.h
//  FWDraggableSwipePlayer
//
//  Created by Filly Wang on 21/1/15.
//  Copyright (c) 2015 Filly Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FWPlayerColorUtil : NSObject

- (void)setGradientBlackToWhiteColor:(UIView*)view;
- (void)setGradientBlackToWhiteColor:(UIView*)view withFrame:(CGRect)frame;
- (void)setGradientWhiteToBlackColor:(UIView*)view;
- (void)setGradientWhiteToBlackColor:(UIView*)view withFrame:(CGRect)frame;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (UIColor *)colorWithHex:(NSString *)hexValue alpha:(float)alpha;
@end
