//
//  FXSVGPolylineElement.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGPolylineElement.h"

@implementation FXSVGPolylineElement

- (NSMutableArray *)realPoints {
    if (!_realPoints) {
        _realPoints = [NSMutableArray array];
    }
    return _realPoints;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    self.clickable = NO;
    
    NSString *points = [attributes objectForKey:@"points"];
    NSArray *array = [points componentsSeparatedByString:@" "];
    for (NSString *string in array) {
        if (string.length != 0) {
            CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@}", string]);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [self.realPoints addObject:value];
        }
    }
    
    [self drawPolyline];
    
    return self;
}

- (void)drawPolyline {
    NSValue *originValue = self.realPoints[0];
    [self.path moveToPoint:originValue.CGPointValue];
    [self.realPoints removeObjectAtIndex:0];
    
    for (NSValue *value in self.realPoints) {
        [self.path addLineToPoint:value.CGPointValue];
    }
}

@end
