//
//  SVGPolygon.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGPolygon.h"

@implementation SVGPolygon

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super initWithAttribute:attr];
    if (self) {
        [self drawPolygon:attr];
    }
    return self;
}

- (void)drawPolygon:(NSDictionary *)attr {
    
    NSString *points = attr[@"points"];
    
    NSScanner *scanner = [NSScanner scannerWithString:points];
    
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@" ,\n"];
    scanner.charactersToBeSkipped = skipSet;
    
    double number;
    NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
    
    while ([scanner scanDouble:&number]) {
        [numbers addObject:@(number)];
    }
    
    [self buildPath:numbers];
}

- (void)buildPath:(NSArray<NSNumber *> *)nums {
    
    for (NSInteger i = 0; i < nums.count / 2; i++) {
        CGPoint p = CGPointMake(nums[i*2].doubleValue, nums[i*2+1].doubleValue);
        if (i == 0) {
            [self.path moveToPoint:p];
        } else {
            [self.path addLineToPoint:p];
        }
    }
    
    [self.path closePath];
    
    self.shape.path = self.path.CGPath;
}

@end
