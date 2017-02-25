//
//  SVGParser.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGParser.h"
#import <objc/runtime.h>
#import "SVG.h"

@implementation SVGParser

- (void)parseFile:(NSString *)fileName {
    
    self.elementNames = @[@"path", @"line", @"rect", @"circle", @"ellipse", @"polyline", @"polygon"];
    
    NSString *fileNameString = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"svg"];
    NSData *data = [NSData dataWithContentsOfFile:fileNameString];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
//    
//    GDataXMLElement *element = [doc rootElement];
//    
//    NSLog(@"start");
//    
//    for (GDataXMLNode *node in [element children]) {
//        NSLog(@"%@", [GDataXMLNode elementWithName:node.name]);
//    }
//    NSLog(@"finish");
//    dispatch_apply([element childCount], <#dispatch_queue_t  _Nonnull queue#>, <#^(size_t)block#>)
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([self.elementNames containsObject:elementName]) {
        NSString *className = [@"SVG" stringByAppendingString:[elementName capitalizedString]];
        Class class = NSClassFromString(className);
        
        NSLog(@"123 = %@", elementName);
        
//        class *element = [[class alloc] init];
    }
    
    
    if ([elementName isEqualToString:@"svg"])
    {
        
    } else if ([elementName isEqualToString:@"g"])
    {
        // group
    } else if ([elementName isEqualToString:@"path"])
    {
        SVGPath *path = [[SVGPath alloc] initWithAttribute:attributeDict];
        
    } else if ([elementName isEqualToString:@"line"])
    {
        SVGLine *line = [[SVGLine alloc] initWithAttribute:attributeDict];
        
    }else if ([elementName isEqualToString:@"rect"])
    {
        SVGRect *rect = [[SVGRect alloc] initWithAttribute:attributeDict];
        
    } else if ([elementName isEqualToString:@"circle"])
    {
        SVGCircle *circle = [[SVGCircle alloc] initWithAttribute:attributeDict];
        
    } else if ([elementName isEqualToString:@"ellipse"])
    {
        SVGEllipse *ellipse = [[SVGEllipse alloc] initWithAttribute:attributeDict];
        
    } else if ([elementName isEqualToString:@"polyline"])
    {
        SVGPolyline *polyline = [[SVGPolyline alloc] initWithAttribute:attributeDict];
        
    } else if ([elementName isEqualToString:@"polygon"])
    {
        SVGPolygon *polygon = [[SVGPolygon alloc] initWithAttribute:attributeDict];
    }
}

- (void)parserWithNode:(GDataXMLNode *)node {
}

@end
