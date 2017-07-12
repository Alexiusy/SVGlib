//
//  SVGView.m
//  SVGTest
//
//  Created by Zeacone on 2017/2/25.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import "SVGView.h"
#import "SVGParser.h"
#import <objc/runtime.h>

static const void *key;

@implementation CAShapeLayer (selectable)

- (NSNumber *)selectable {
    return objc_getAssociatedObject(self, &key);
}

- (void)setSelectable:(NSNumber *)selectable {
    objc_setAssociatedObject(self, &key, selectable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface SVGView ()

@property (nonatomic, strong) CAShapeLayer *oldLayer;
@property (nonatomic, strong) CAShapeLayer *tempLayer;

@property (nonatomic, assign) CGFloat multiplier;

@end

@implementation SVGView

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        [self parseSVG:filePath];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath
{
    self = [super initWithFrame:frame];
    if (self) {
        [self parseSVG:filePath];
    }
    return self;
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    [self parseSVG:filePath];
}

- (void)parseSVG:(NSString *)filePath {
    
    SVGParser *parser = [[SVGParser alloc] init];
    [parser parseFile:filePath];
    
    self.elements = [parser.elements copy];
    self.size = parser.svgSize;
    
    self.bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    
    [self drawLayers:self.elements];
}

- (CGFloat)calculateMultiple {
    return 0;
}

- (void)drawLayers:(NSArray<SVGElement *> *)layers {
    
    for (SVGElement *element in layers) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = element.path.CGPath;
        layer.lineWidth = .1;
        layer.strokeColor = element.strokeColor.CGColor;
        layer.fillColor = element.fillColor.CGColor;
        
        layer.selectable = [NSNumber numberWithBool:element.selectable];
        
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        layer.shadowPath = layer.path;
        layer.shadowRadius = .1;
        layer.shadowOpacity = .4;
        layer.shadowOffset = CGSizeMake(0, 0);
        
        [self.layer addSublayer:layer];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touch_point = [touches.anyObject locationInView:self];
    
    [self exchangeAttribute:self.oldLayer Layer2:self.tempLayer];
    
    [self.layer.sublayers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *shape = (CAShapeLayer *)obj;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:shape.path];
        
        if ([bezierPath containsPoint:touch_point] && shape.selectable.boolValue) {
            
            self.oldLayer = shape;
            self.tempLayer = [CAShapeLayer layer];
            
            [self exchangeAttribute:self.tempLayer Layer2:self.oldLayer];
            
            shape.fillColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0].CGColor;
            *stop = YES;
        }
    }];
}

- (void)exchangeAttribute:(CAShapeLayer *)layer1 Layer2:(CAShapeLayer *)layer2 {
    layer1.strokeColor = layer2.strokeColor;
    layer1.fillColor = layer2.fillColor;
    layer1.shadowPath = layer2.shadowPath;
    layer1.shadowColor = layer2.shadowColor;
    layer1.shadowOffset = layer2.shadowOffset;
    layer1.shadowRadius = layer2.shadowRadius;
    layer1.shadowOpacity = layer2.shadowOpacity;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
