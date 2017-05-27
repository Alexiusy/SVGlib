//
//  SVGParser.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGParser.h"
#import "SVG.h"

@interface SVGParser ()

@property (nonatomic, copy) NSString *transform;

@end

@implementation SVGParser

- (void)parseFile:(NSString *)fileName {
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"g"]) {
        self.transform = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if (!self.elements) {
        self.elements = [NSMutableArray array];
    }
    
    if ([elementName isEqualToString:@"svg"]) {
        // 获取公有属性 like viewbox
        CGFloat width = attributeDict[@"width"].doubleValue;
        CGFloat height = attributeDict[@"height"].doubleValue;
        self.svgSize = CGSizeMake(width, height);
        
    } else if ([elementName isEqualToString:@"g"]) {
        // group
        self.transform = [attributeDict objectForKey:@"transform"];
    } else if ([@[@"path", @"rect", @"circle", @"ellipse", @"line", @"polyline", @"polygon"] containsObject:elementName]) {
    
        NSString *className = [@"SVG" stringByAppendingString:[elementName capitalizedString]];
        
        Class myClass = NSClassFromString(className);
        
        SVGElement *element = [((SVGElement *)[myClass alloc]) initWithAttribute:attributeDict];
        
        if (element) {
            if (!element.tranform && self.transform) {
                element.tranform = self.transform;
            }
            [self.elements addObject:element];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}

@end
