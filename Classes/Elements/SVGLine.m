//
//  SVGLine.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGLine.h"

@implementation SVGLine

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        [self drawLineWithAttr:attribute];
    }
    return self;
}

- (void)drawLineWithAttr:(NSDictionary *)attr {
    
    NSString *x1 = attr[@"x1"];
    NSString *y1 = attr[@"y1"];
    NSString *x2 = attr[@"x2"];
    NSString *y2 = attr[@"y2"];
    
    CGPoint p1 = CGPointMake(x1.doubleValue, y1.doubleValue);
    CGPoint p2 = CGPointMake(x2.doubleValue, y2.doubleValue);
    
    [self.path moveToPoint:p1];
    [self.path addLineToPoint:p2];
    
    self.shape.path = self.path.CGPath;
}

@end
