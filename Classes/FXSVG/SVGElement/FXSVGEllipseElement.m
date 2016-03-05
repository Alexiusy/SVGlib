//
//  FXSVGEllipseElement.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGEllipseElement.h"

@implementation FXSVGEllipseElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    self.clickable = YES;
    
    CGFloat cx = ((NSString *)[attributes objectForKey:@"cx"]).doubleValue;
    CGFloat cy = ((NSString *)[attributes objectForKey:@"cy"]).doubleValue;
    CGFloat rx = ((NSString *)[attributes objectForKey:@"rx"]).doubleValue;
    CGFloat ry = ((NSString *)[attributes objectForKey:@"ry"]).doubleValue;
    [self drawEllipseWithCenterX:cx CenterY:cy rx:rx ry:ry];
    
    return self;
}

- (void)drawEllipseWithCenterX:(CGFloat)cx CenterY:(CGFloat)cy rx:(CGFloat)rx ry:(CGFloat)ry {
    
    CGFloat originX = cx - rx;
    CGFloat originY = cy - ry;
    CGFloat width = 2 * rx;
    CGFloat height = 2 * ry;
    
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(originX, originY, width, height)];
}

@end
