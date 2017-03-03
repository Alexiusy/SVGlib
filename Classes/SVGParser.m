//
//  SVGParser.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
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
        // 获取公有属性 like viewbox
        
    } else if ([elementName isEqualToString:@"g"])
    {
        // group
    } else if ([elementName isEqualToString:@"path"])
    {
        SVGPath *path = [[SVGPath alloc] initWithAttribute:attributeDict];
        path.shape.path = path.path.CGPath;
        [self.layers addObject:path.shape];
        
    } else if ([elementName isEqualToString:@"line"])
    {
        SVGLine *line = [[SVGLine alloc] initWithAttribute:attributeDict];
        [self.layers addObject:line.shape];
        
    }else if ([elementName isEqualToString:@"rect"])
    {
        SVGRect *rect = [[SVGRect alloc] initWithAttribute:attributeDict];
        [self.layers addObject:rect.shape];
        
    } else if ([elementName isEqualToString:@"circle"])
    {
        SVGCircle *circle = [[SVGCircle alloc] initWithAttribute:attributeDict];
        [self.layers addObject:circle.shape];
        
    } else if ([elementName isEqualToString:@"ellipse"])
    {
        SVGEllipse *ellipse = [[SVGEllipse alloc] initWithAttribute:attributeDict];
        [self.layers addObject:ellipse.shape];
        
    } else if ([elementName isEqualToString:@"polyline"])
    {
        SVGPolyline *polyline = [[SVGPolyline alloc] initWithAttribute:attributeDict];
        [self.layers addObject:polyline.shape];
        
    } else if ([elementName isEqualToString:@"polygon"])
    {
        SVGPolygon *polygon = [[SVGPolygon alloc] initWithAttribute:attributeDict];
        [self.layers addObject:polygon.shape];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
