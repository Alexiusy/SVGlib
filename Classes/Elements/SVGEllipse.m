//
//  SVGEllipse.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGEllipse.h"

@implementation SVGEllipse

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super initWithAttribute:attr];
    if (self) {
        [self drawEllipse:attr];
    }
    return self;
}

- (void)drawEllipse:(NSDictionary *)attr {
    
    NSString *cx = attr[@"cx"];
    NSString *cy = attr[@"cy"];
    NSString *rx = attr[@"rx"];
    NSString *ry = attr[@"ry"];
    
    CGRect rect = CGRectMake(cx.doubleValue-rx.doubleValue, cy.doubleValue-ry.doubleValue, rx.doubleValue*2, ry.doubleValue*2);
    
    self.path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    self.shape.path = self.path.CGPath;
}

@end
