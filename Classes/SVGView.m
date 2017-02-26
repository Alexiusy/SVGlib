//
//  SVGView.m
//  SVGTest
//
//  Created by Zeacone on 2017/2/25.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import "SVGView.h"
#import "SVGParser.h"

@implementation SVGView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SVGParser *parser = [[SVGParser alloc] init];
        [parser parseFile:@"bazhan.svg"];
        
        [self drawLayers:[parser.paths copy]];
    }
    return self;
}

- (void)drawLayers:(NSArray<UIBezierPath *> *)paths {
    
    for (UIBezierPath *path in paths) {
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.path = path.CGPath;
        shape.strokeColor = [UIColor greenColor].CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.lineWidth = 2.0;
        [self.layer addSublayer:shape];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
