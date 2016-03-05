//
//  FXSVGParser.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGParser.h"
#import "FXSVG.h"

@interface FXSVGParser()

@property (nonatomic, strong) NSMutableArray* transforms;
@property (nonatomic) CGAffineTransform currentTransform;

@end

@implementation FXSVGParser

+ (instancetype)svgWithFile:(NSString*)filePath {
    return [[FXSVGParser alloc] initWithFile:filePath];
}

- (id)initWithFile:(NSString*)filename {
    self = [super init];
    
    if(self) {
        _paths = [NSMutableArray array];
        _transforms = [NSMutableArray array];
        _currentTransform = CGAffineTransformIdentity;
        
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"svg"]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        [parser parse];
        [self computeBounds];
    }
    
    return self;
}

#pragma mark - XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"g"]) {
        // Push
        CGAffineTransform t = CGAffineTransformIdentity;
        
        if([attributeDict objectForKey:@"transform"]) {
            t = [FXSVGUtils parseTransform:[attributeDict objectForKey:@"transform"]];
        }
        
        _currentTransform = CGAffineTransformConcat(t, _currentTransform);
        [_transforms addObject:NSStringFromCGAffineTransform(_currentTransform)];
    } else if ([elementName isEqualToString:@"svg"]) {
        NSLog(@"svg element name and attribute: %@%@", elementName, attributeDict);
    } else {
        
        // Get transform property
        CGAffineTransform t = _currentTransform;
        
        if([attributeDict objectForKey:@"transform"]) {
            CGAffineTransform pathTransform = [FXSVGUtils parseTransform:[attributeDict objectForKey:@"transform"]];
            t = CGAffineTransformConcat(pathTransform, _currentTransform);
        }
        
        /**
         *  This is for seven svg elements, like Path, Line, Rect, Circle, Ellipse, Polyline and Polygon.
         */
        if([elementName isEqualToString:@"path"]) {
            FXSVGPathElement *element = [[FXSVGPathElement alloc] initWithAttributes:attributeDict];
            if(element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if ([elementName isEqualToString:@"rect"]) {
            FXSVGRectElement *element = [[FXSVGRectElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
            
        } else if([elementName isEqualToString:@"polygon"]) {
            FXSVGPolygonElement *element = [[FXSVGPolygonElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"polyline"]) {
            FXSVGPolylineElement *element = [[FXSVGPolylineElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"line"]) {
            FXSVGLineElement *element = [[FXSVGLineElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"circle"]) {
            FXSVGCircleElement *element = [[FXSVGCircleElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else if([elementName isEqualToString:@"ellipse"]) {
            FXSVGEllipseElement *element = [[FXSVGEllipseElement alloc] initWithAttributes:attributeDict];
            if (element.path) {
                [_paths addObject:element];
            }
            [element.path applyTransform:t];
        } else {
            NSLog(@"%@\n%@", elementName, attributeDict);
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"g"])
    {
        // Pop
        [_transforms removeLastObject];
        
        if([_transforms count] > 0 ) {
            _currentTransform = CGAffineTransformFromString([_transforms lastObject]);
        } else {
            _currentTransform = CGAffineTransformIdentity;
        }
    }
}

#pragma mark - Bounds

- (void)computeBounds
{
    _bounds.origin.x = MAXFLOAT;
    _bounds.origin.y = MAXFLOAT;
    float maxx = -MAXFLOAT;
    float maxy = -MAXFLOAT;
    
    for (FXSVGElement* path in _paths) {
        CGRect b =  CGPathGetPathBoundingBox(path.path.CGPath);
        if (CGRectIsInfinite(b) || CGRectIsNull(b) || CGRectIsEmpty(b)) continue;
        
        if(b.origin.x < _bounds.origin.x)
            _bounds.origin.x = b.origin.x;
        
        if(b.origin.y < _bounds.origin.y)
            _bounds.origin.y = b.origin.y;
        
        if(b.origin.x + b.size.width > maxx) {
            maxx = b.origin.x + b.size.width;
        }
        
        
        if(b.origin.y + b.size.height > maxy)
            maxy = b.origin.y + b.size.height;
    }
    
    _bounds.size.width = maxx - _bounds.origin.x;
    _bounds.size.height = maxy - _bounds.origin.y;
}

@end
