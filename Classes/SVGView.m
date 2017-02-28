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
        
        [self drawLayers:[parser.layers copy]];
    }
    return self;
}

- (void)drawLayers:(NSArray<CAShapeLayer *> *)layers {
    
    for (CAShapeLayer *layer in layers) {
        layer.affineTransform = CGAffineTransformScale(layer.affineTransform, 0.1, 0.1);
        [self.layer addSublayer:layer];
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
