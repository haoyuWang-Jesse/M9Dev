//
//  UIColor+M9.h
//  M9Dev
//
//  Created by MingLQ on 2011-03-09.
//  Copyright 2011 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (M9Category)

- (UIColor *)inverseColor;

+ (UIColor *)colorWithName:(NSString *)name;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithName:(NSString *)name alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
