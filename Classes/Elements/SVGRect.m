//
//  SVGRect.m
//  
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGRect.h"

@implementation SVGRect

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super initWithAttribute:attr];
    if (self) {
        [self drawRect:attr];
    }
    return self;
}

- (void)drawRect:(NSDictionary *)attr {
    
    NSString *x = attr[@"x"];
    NSString *y = attr[@"y"];
    NSString *width = attr[@"width"];
    NSString *height = attr[@"height"];
    
    CGRect rect = CGRectMake(x.doubleValue, y.doubleValue, width.doubleValue, height.doubleValue);
    self.path = [UIBezierPath bezierPathWithRect:rect];

    self.shape.path = self.path.CGPath;
}

@end
