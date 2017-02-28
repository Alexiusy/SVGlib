//
//  SVGCircle.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGCircle.h"

@implementation SVGCircle

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        [self drawCircle:attribute];
    }
    return self;
}

- (void)drawCircle:(NSDictionary *)attribute {
    
}

@end
