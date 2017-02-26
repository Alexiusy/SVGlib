//
//  SVGPath.m
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import "SVGPath.h"

@interface SVGPath ()

@property (nonatomic, strong) NSMutableArray<NSValue *> *points;

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
    
    NSArray *charaters = @[@"M", @"m", @"L", @"l", @"A", @"a", @"C", @"c", @"Q", @"q", @"S", @"s", @"T", @"t", @"H", @"h", @"V", @"v", @"Z", @"z"];
    
    NSArray *cmdArray = [actionString componentsSeparatedByString:@" "];
    
    self.points = [NSMutableArray array];
    NSString *currentCMD = nil;
    
    for (NSString *cmd in cmdArray) {
        if ([charaters containsObject:cmd]) {
            if (currentCMD) {
                [self executeCommand:[currentCMD UTF8String]];
            }
            
            [self.points removeAllObjects];
            
            currentCMD = cmd;
        } else {
            
            NSString *pointStr = [NSString stringWithFormat:@"{%@}", cmd];
            CGPoint point = CGPointFromString(pointStr);
            [self.points addObject:[NSValue valueWithCGPoint:point]];
        }
    }
}

- (void)executeCommand:(const char *)command {
    
    switch (command[0]) {
        case 'M':
            [self moveRelative:NO];
            break;
        case 'm':
            [self moveRelative:YES];
            break;
        case 'L':
            [self addLineRelative:NO];
            break;
        case 'l':
            [self addLineRelative:YES];
            break;
        case 'A':
            [self addArcRelative:NO];
            break;
        case 'a':
            [self addArcRelative:YES];
            break;
        case 'C':
            [self addCurveRelative:NO];
            break;
        case 'c':
            [self addCurveRelative:YES];
            break;
        case 'Q':
            [self addQuadRelative:NO];
            break;
        case 'q':
            [self addQuadRelative:YES];
            break;
        case 'S':
            [self addSmoothRelative:NO];
            break;
        case 's':
            [self addSmoothRelative:YES];
            break;
        case 'T':
            [self addCubicRelative:NO];
            break;
        case 't':
            [self addCubicRelative:YES];
            break;
        case 'H':
            [self addHorizonRelative:NO];
            break;
        case 'h':
            [self addHorizonRelative:YES];
            break;
        case 'V':
            [self addVerticalRelative:NO];
            break;
        case 'v':
            [self addVerticalRelative:YES];
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

- (void)moveRelative:(BOOL)relative {
    
    for (NSValue *value in self.points) {
        
        CGPoint p = value.CGPointValue;
        
        if (relative) {
            self.end = CGPointMake(_end.x + p.x, _end.y + p.y);
        } else {
            _end = p;
        }
        [self.path moveToPoint:_end];
    }
}

- (void)addLineRelative:(BOOL)relative {
    
    for (NSValue *value in self.points) {
        
        CGPoint p = value.CGPointValue;
        
        if (relative) {
            _end = CGPointMake(_end.x + p.x, _end.y + p.y);
        } else {
            _end = p;
        }
        
        [self.path addLineToPoint:_end];
    }
}

// 暂无头绪
- (void)addArcRelative:(BOOL)relative {
    
}

- (void)addCurveRelative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [self.points count] / 3; i++) {
        
        CGPoint c1 = [self.points objectAtIndex:i*3+0].CGPointValue;
        CGPoint c2 = [self.points objectAtIndex:i*3+1].CGPointValue;
        CGPoint p  = [self.points objectAtIndex:i*3+2].CGPointValue;
        
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

- (void)addQuadRelative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [self.points count] / 2; i++) {
        
        CGPoint controlPoint = [self.points objectAtIndex:i*2+0].CGPointValue;
        CGPoint finalPoint =   [self.points objectAtIndex:i*2+1].CGPointValue;
        
        if (relative) {
            [self.path addQuadCurveToPoint:CGPointMake(_end.x + finalPoint.x, _end.y + finalPoint.y)
                              controlPoint:CGPointMake(_end.x + controlPoint.x, _end.y + controlPoint.y)];
            _end = CGPointMake(_end.x + finalPoint.x, _end.y + finalPoint.y);
        } else {
            [self.path addQuadCurveToPoint:finalPoint controlPoint:controlPoint];
            _end = finalPoint;
        }
    }
}

// S 命令用来创建与之前曲线相同的曲线，三次贝塞尔曲线
- (void)addSmoothRelative:(BOOL)relative {
    
}

// T 命令用来创建与之前曲线相同的曲线，二次贝塞尔曲线
- (void)addCubicRelative:(BOOL)relative {
    
}

- (void)addHorizonRelative:(BOOL)relative {
    
}

- (void)addVerticalRelative:(BOOL)relative {
    
}

- (void)close {
    [self.path closePath];
}

@end
