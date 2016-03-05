//
//  FXSVGView.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGView.h"

@implementation FXSVGView

- (void)setDefaultParameters {
    self.fillColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.strokeColor = [UIColor colorWithWhite:0.6 alpha:1];
    self.scaledPath = [NSMutableArray array];
}

#pragma mark - SVG file loading

- (void)loadSVGFile:(NSString*)filename {
    [self setDefaultParameters];
    self.svgParser = [FXSVGParser svgWithFile:filename];
    
    // Clear all data to forbid duplicate adding.
    [self.scaledPath removeAllObjects];
    
    for (FXSVGElement *element in self.svgParser.paths) {
        UIBezierPath *layerPath = [element.path copy];
        
        // Make the svg view fits inside the frame
        float scaleHorizontal = self.frame.size.width / self.svgParser.bounds.size.width;
        float scaleVertical = self.frame.size.height / self.svgParser.bounds.size.height;
        float scale = MIN(scaleHorizontal, scaleVertical);
        
        CGAffineTransform scaleTransform = CGAffineTransformIdentity;
        scaleTransform = CGAffineTransformMakeScale(scale, scale);
        scaleTransform = CGAffineTransformTranslate(scaleTransform, -self.svgParser.bounds.origin.x, -self.svgParser.bounds.origin.y);
        [layerPath applyTransform:scaleTransform];
        
        CAShapeLayer  *shapeLayer = [CAShapeLayer layer];
        // Setting CAShapeLayer properties
        shapeLayer.path = layerPath.CGPath;
        shapeLayer.strokeColor = element.strokeColor.CGColor;
//        shapeLayer.fillColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.7 alpha:1.0].CGColor;
        shapeLayer.fillColor = element.fillColor.CGColor;
        shapeLayer.lineWidth = 0.5;
        
        [self.layer addSublayer:shapeLayer];
        
        [self.scaledPath addObject:layerPath];
    }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (NSInteger i = 0; i < self.scaledPath.count; i++) {
        UIBezierPath *path = self.scaledPath[i];
        if (![path containsPoint:touchPoint]) continue;
        
        FXSVGElement *element = self.svgParser.paths[i];
        
        if(!element.clickable) continue;
        
        CAShapeLayer *layer = (CAShapeLayer *)self.layer.sublayers[i];
        
        if(self.clickHandler) {
            self.clickHandler(element.identifier, layer);
        }
    }
}

@end
