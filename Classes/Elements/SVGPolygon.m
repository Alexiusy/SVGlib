//
//  SVGPolygon.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGPolygon.h"

@implementation SVGPolygon

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        [self parseAttribute:attribute];
    }
    return self;
}

- (void)parseAttribute:(NSDictionary *)attribute {
    
    NSString *points = attribute[@"points"];
    NSArray<NSString *> *strArray = [points componentsSeparatedByString:@" "];
    
    [strArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *point_string = [NSString stringWithFormat:@"{%@}", obj];
        CGPoint point = CGPointFromString(point_string);
        
        if (idx == 0) {
            [self.path moveToPoint:point];
        } else {
            [self.path addLineToPoint:point];
        }
    }];
    [self.path closePath];
}

@end
