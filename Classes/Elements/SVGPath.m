//
//  SVGPath.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGPath.h"

@interface SVGPath ()

@property (nonatomic, assign) CGPoint preControlPoint;
@property (nonatomic, assign) CGPoint preDestination;
@property (nonatomic, assign) CGPoint end;

@end

@implementation SVGPath

- (instancetype)initWithAttribute:(NSDictionary *)attribute
{
    self = [super initWithAttribute:attribute];
    if (self) {
        [self setupAttribute:attribute];
    }
    return self;
}

- (void)setupAttribute:(NSDictionary *)attribute {
    
    self.end = CGPointZero;
    
    NSString *cmdString = [attribute objectForKey:@"d"];
    
    [self parseAction:cmdString];
}

- (void)parseAction:(NSString *)actionString {
    
    NSScanner *scanner = [NSScanner scannerWithString:actionString];
    
    
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@" ,\n"];
    scanner.charactersToBeSkipped = skipSet;
    
    NSCharacterSet *commandSet = [NSCharacterSet characterSetWithCharactersInString:@"MLACQSTHVZmlacqsthvz"];
    NSString *commandStr = nil;
    
    while ([scanner scanCharactersFromSet:commandSet intoString:&commandStr]) {
        
        NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
        double number = 0;
        
        while ([scanner scanDouble:&number]) {
            [numbers addObject:@(number)];
        }
        [self executeCommand:[commandStr UTF8String] Numbers:[numbers copy]];
    }
}

- (void)executeCommand:(const char *)command Numbers:(NSArray<NSNumber *> *)numbers {
    
    switch (command[0]) {
        case 'M':
            [self move:numbers Relative:NO];
            break;
        case 'm':
            [self move:numbers Relative:YES];
            break;
        case 'L':
            [self addLine:numbers Relative:NO];
            break;
        case 'l':
            [self addLine:numbers Relative:YES];
            break;
        case 'A':
            [self addArc:numbers Relative:NO];
            break;
        case 'a':
            [self addArc:numbers Relative:YES];
            break;
        case 'C':
            [self addCurve:numbers Relative:NO];
            break;
        case 'c':
            [self addCurve:numbers Relative:YES];
            break;
        case 'Q':
            [self addQuad:numbers Relative:NO];
            break;
        case 'q':
            [self addQuad:numbers Relative:YES];
            break;
        case 'S':
            [self addSmooth:numbers Relative:NO];
            break;
        case 's':
            [self addSmooth:numbers Relative:YES];
            break;
        case 'T':
            [self addCubic:numbers Relative:NO];
            break;
        case 't':
            [self addCubic:numbers Relative:YES];
            break;
        case 'H':
            [self addHorizon:numbers Relative:NO];
            break;
        case 'h':
            [self addHorizon:numbers Relative:YES];
            break;
        case 'V':
            [self addVertical:numbers Relative:NO];
            break;
        case 'v':
            [self addVertical:numbers Relative:YES];
            break;
        case 'Z':
        case 'z':
            [self close];
            break;
            
        default:
            NSLog(@"cannot resolve command.");
            break;
    }
}

- (void)move:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < numbers.count / 2; i++) {
        
        CGPoint p = CGPointMake(numbers[i*2].doubleValue, numbers[i*2+1].doubleValue);
        
        if (relative) {
            self.end = CGPointMake(_end.x + p.x, _end.y + p.y);
        } else {
            _end = p;
        }
        [self.path moveToPoint:_end];
    }
    self.preControlPoint = CGPointZero;
}

- (void)addLine:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < numbers.count / 2; i++) {
        
        CGPoint p = CGPointMake(numbers[i*2].doubleValue, numbers[i*2+1].doubleValue);
        
        if (relative) {
            _end = CGPointMake(_end.x + p.x, _end.y + p.y);
        } else {
            _end = p;
        }
        [self.path addLineToPoint:_end];
    }
    self.preControlPoint = CGPointZero;
}

// 暂无头绪
- (void)addArc:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    NSLog(@"No arc solution.");
    self.preControlPoint = CGPointZero;
}

- (void)addCurve:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [numbers count] / 6; i++) {
        
        CGPoint c1 = CGPointMake(numbers[i*6].doubleValue, numbers[i*6+1].doubleValue);
        CGPoint c2 = CGPointMake(numbers[i*6+2].doubleValue, numbers[i*6+3].doubleValue);
        CGPoint p  = CGPointMake(numbers[i*6+4].doubleValue, numbers[i*6+5].doubleValue);
        
        self.preControlPoint = CGPointMake(_end.x + c2.x, _end.y + c2.y);
        
        if (relative) {
            [self.path addCurveToPoint:CGPointMake(_end.x + p.x, _end.y + p.y)
                         controlPoint1:CGPointMake(_end.x + c1.x, _end.y + c1.y)
                         controlPoint2:CGPointMake(_end.x + c2.x, _end.y + c2.y)];
            _end = CGPointMake(_end.x + p.x, _end.y + p.y);
        } else {
            [self.path addCurveToPoint:p controlPoint1:c1 controlPoint2:c2];
            _end = p;
        }
    }
}

- (void)addQuad:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [numbers count] / 4; i++) {
        
        CGPoint controlPoint = CGPointMake(numbers[i*4].doubleValue, numbers[i*4+1].doubleValue);
        CGPoint finalPoint = CGPointMake(numbers[i*4+2].doubleValue, numbers[i*4+3].doubleValue);
        
        if (relative) {
            [self.path addQuadCurveToPoint:CGPointMake(_end.x + finalPoint.x, _end.y + finalPoint.y)
                              controlPoint:CGPointMake(_end.x + controlPoint.x, _end.y + controlPoint.y)];
            _end = CGPointMake(_end.x + finalPoint.x, _end.y + finalPoint.y);
        } else {
            [self.path addQuadCurveToPoint:finalPoint controlPoint:controlPoint];
            _end = finalPoint;
        }
    }
    self.preControlPoint = CGPointZero;
}

// S 命令用来创建与之前曲线相同的曲线，三次贝塞尔曲线
- (void)addSmooth:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    NSLog(@"No smooth solution.");
    
    for (NSInteger i = 0; i < numbers.count / 4; i++) {
        CGPoint c1 = CGPointMake(_end.x + (_end.x - _preControlPoint.x), _end.y + (_end.y - _preControlPoint.y));
        CGPoint c2 = CGPointMake(numbers[i*2].doubleValue, numbers[i*2+1].doubleValue);
        CGPoint p = CGPointMake(numbers[i*2+2].doubleValue, numbers[i*2+3].doubleValue);
        
        if (relative) {
            [self.path addCurveToPoint:CGPointMake(_end.x+p.x, _end.y+p.y)
                         controlPoint1:c1
                         controlPoint2:CGPointMake(_end.x+c2.x, _end.y+c2.y)];
            _end = CGPointMake(_end.x+p.x, _end.y+p.y);
        } else {
            [self.path addCurveToPoint:p controlPoint1:c1 controlPoint2:c2];
            _end = p;
        }
        
        self.preControlPoint = CGPointMake(_end.x+c2.x, _end.y+c2.y);
    }
    
}

// T 命令用来创建与之前曲线相同的曲线，二次贝塞尔曲线
- (void)addCubic:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    NSLog(@"No cubic solution.");
}

- (void)addHorizon:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSNumber *number in numbers) {
        
        CGPoint p = CGPointZero;
        
        if (relative) {
            p = CGPointMake(_end.x + number.doubleValue, _end.y);
        } else {
            p = CGPointMake(number.doubleValue, _end.y);
        }
        _end = p;
        [self.path addLineToPoint:p];
    }
}

- (void)addVertical:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSNumber *number in numbers) {
        
        CGPoint p = CGPointZero;
        
        if (relative) {
            p = CGPointMake(_end.x, _end.y + number.doubleValue);
        } else {
            p = CGPointMake(_end.x, number.doubleValue);
        }
        _end = p;
        [self.path addLineToPoint:p];
    }
}

- (void)close {
    [self.path closePath];
}

@end
