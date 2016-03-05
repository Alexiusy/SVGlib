//
//  FXSVGPolygonElement.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGPolygonElement.h"

@implementation FXSVGPolygonElement

- (NSMutableArray *)realpPoints {
    if (!_realpPoints) {
        _realpPoints = [NSMutableArray array];
    }
    return _realpPoints;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    self.clickable = YES;
    
    NSString *points = [attributes objectForKey:@"points"];
    NSArray *array = [points componentsSeparatedByString:@" "];
    for (NSString *string in array) {
        if (string.length != 0) {
            CGPoint point = CGPointFromString([NSString stringWithFormat:@"{%@}", string]);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [self.realpPoints addObject:value];
        }
    }
    
    [self drawPolygonWithPoints:self.realpPoints];
    
    return self;
}

- (void)drawPolygonWithPoints:(NSMutableArray *)array {
    self.path.miterLimit = 10;
    NSValue *originValue = array[0];
    [self.path moveToPoint:originValue.CGPointValue];
    [self.realpPoints removeObjectAtIndex:0];
    
    for (NSValue *value in self.realpPoints) {
        [self.path addLineToPoint:value.CGPointValue];
    }
    [self.path closePath];
}

@end
