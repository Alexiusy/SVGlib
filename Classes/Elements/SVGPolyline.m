//
//  SVGPolyline.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGPolyline.h"

@implementation SVGPolyline

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        [self drawPolyline:attribute];
    }
    return self;
}

- (void)drawPolyline:(NSDictionary *)attr {
    
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

- (void)buildPath:(NSArray<NSNumber *> *)numbers {
    
    for (NSInteger i = 0; i < numbers.count / 2; i++) {
        CGPoint p = CGPointMake(numbers[i*2].doubleValue, numbers[i*2+1].doubleValue);
        
        if (i == 0) {
            [self.path moveToPoint:p];
        } else {
            [self.path addLineToPoint:p];
        }
    }
    
    self.shape.path = self.path.CGPath;
}

@end
