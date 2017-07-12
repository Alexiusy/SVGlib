//
//  SVGCircle.m
//  
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGCircle.h"

@implementation SVGCircle

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super initWithAttribute:attr];
    if (self) {
        [self drawCircle:attr];
    }
    return self;
}

- (void)drawCircle:(NSDictionary *)attr {
    
    NSString *cx = attr[@"cx"];
    NSString *cy = attr[@"cy"];
    NSString *r = attr[@"r"];
    
    [self.path addArcWithCenter:CGPointMake(cx.doubleValue, cy.doubleValue)
                         radius:r.doubleValue
                     startAngle:0
                       endAngle:M_PI * 2
                      clockwise:YES];
    self.selectable = YES;
}

@end
