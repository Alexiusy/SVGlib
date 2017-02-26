//
//  SVGRect.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGRect.h"

@implementation SVGRect

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        
        self.x = ((NSString *)attribute[@"x"]).doubleValue;
        self.y = ((NSString *)attribute[@"y"]).doubleValue;
        self.width = ((NSString *)attribute[@"width"]).doubleValue;
        self.height = ((NSString *)attribute[@"height"]).doubleValue;
        
        [self drawRect];
    }
    return self;
}

- (void)drawRect {
    
    CGRect rect = CGRectMake(_x, _y, _width, _height);
    self.path = [UIBezierPath bezierPathWithRect:rect];
}

@end
