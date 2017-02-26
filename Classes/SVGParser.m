//
//  SVGParser.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGParser.h"
#import "SVG.h"

@implementation SVGParser

- (void)parseFile:(NSString *)fileName {
    
    NSString *fileNameString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:fileName];
    NSData *data = [NSData dataWithContentsOfFile:fileNameString];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if (!self.layers) {
        self.layers = [NSMutableArray array];
    }
    
    if ([elementName isEqualToString:@"svg"])
    {
        NSLog(@"321");
    } else if ([elementName isEqualToString:@"g"])
    {
        // group
    } else if ([elementName isEqualToString:@"path"])
    {
        SVGPath *path = [[SVGPath alloc] initWithAttribute:attributeDict];
        [self.layers addObject:path.path];
        
    } else if ([elementName isEqualToString:@"line"])
    {
        SVGLine *line = [[SVGLine alloc] initWithAttribute:attributeDict];
        [self.layers addObject:line.path];
        
    }else if ([elementName isEqualToString:@"rect"])
    {
        SVGRect *rect = [[SVGRect alloc] initWithAttribute:attributeDict];
        [self.layers addObject:rect.path];
        
    } else if ([elementName isEqualToString:@"circle"])
    {
        SVGCircle *circle = [[SVGCircle alloc] initWithAttribute:attributeDict];
        [self.layers addObject:circle.path];
        
    } else if ([elementName isEqualToString:@"ellipse"])
    {
        SVGEllipse *ellipse = [[SVGEllipse alloc] initWithAttribute:attributeDict];
        [self.layers addObject:ellipse.path];
        
    } else if ([elementName isEqualToString:@"polyline"])
    {
        SVGPolyline *polyline = [[SVGPolyline alloc] initWithAttribute:attributeDict];
        [self.layers addObject:polyline.path];
        
    } else if ([elementName isEqualToString:@"polygon"])
    {
        SVGPolygon *polygon = [[SVGPolygon alloc] initWithAttribute:attributeDict];
        [self.layers addObject:polygon.path];
    }
}

- (CAShapeLayer *)generateLayer:(UIBezierPath *)path {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 1.0;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    return shapeLayer;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"123");
}

@end
