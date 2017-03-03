//
//  SVGPath.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGPath.h"

@interface SVGPath ()

/**
 前一个Curve控制点，只对C命令和S命令有效，其余命令设置为CGPointZero
 */
@property (nonatomic, assign) CGPoint c_pre;

/**
 前一个Quad Curve控制点，只对Q命令和T命令有效，其余命令设置为CGPointZero
 */
@property (nonatomic, assign) CGPoint q_pre;

/**
 前一次命令的终点位置，用于采用相对位置的命令，即小写命令
 */
@property (nonatomic, assign) CGPoint end;

@end

@implementation SVGPath

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super initWithAttribute:attr];
    if (self) {
        
        self.end = CGPointZero;
        
        [self parseCommand:attr];
    }
    return self;
}

- (void)parseCommand:(NSDictionary *)attr {
    
    NSString *commandStr = attr[@"d"];
    
    NSScanner *scanner = [NSScanner scannerWithString:commandStr];
    NSCharacterSet *skipSet = [NSCharacterSet characterSetWithCharactersInString:@" ,\n"];
    scanner.charactersToBeSkipped = skipSet;
    
    NSCharacterSet *commandSet = [NSCharacterSet characterSetWithCharactersInString:@"MLACQSTHVZmlacqsthvz"];
    NSString *command = nil;
    
    while ([scanner scanCharactersFromSet:commandSet intoString:&command]) {
        
        NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
        double number = 0;
        
        while ([scanner scanDouble:&number]) {
            [numbers addObject:@(number)];
        }
        [self executeCommand:[command UTF8String] Numbers:[numbers copy]];
    }
}

- (void)executeCommand:(const char *)command Numbers:(NSArray<NSNumber *> *)nums {
    
    NSString *c_excluded = @"MmLlAaQqTtHhVvZz";
    if ([c_excluded containsString:[NSString stringWithUTF8String:command]]) {
        _c_pre = CGPointZero;
    }
    
    NSString *q_excluded = @"MmLlAaCcSsHhVvZz";
    if ([q_excluded containsString:[NSString stringWithUTF8String:command]]) {
        _q_pre = CGPointZero;
    }
    
    switch (command[0]) {
        case 'M':
            [self move:nums Relative:NO];
            break;
        case 'm':
            [self move:nums Relative:YES];
            break;
        case 'L':
            [self addLine:nums Relative:NO];
            break;
        case 'l':
            [self addLine:nums Relative:YES];
            break;
        case 'A':
            [self addArc:nums Relative:NO];
            break;
        case 'a':
            [self addArc:nums Relative:YES];
            break;
        case 'C':
            [self addCurve:nums Relative:NO];
            break;
        case 'c':
            [self addCurve:nums Relative:YES];
            break;
        case 'Q':
            [self addQuad:nums Relative:NO];
            break;
        case 'q':
            [self addQuad:nums Relative:YES];
            break;
        case 'S':
            [self addSmoothCurve:nums Relative:NO];
            break;
        case 's':
            [self addSmoothCurve:nums Relative:YES];
            break;
        case 'T':
            [self addSmoothQuad:nums Relative:NO];
            break;
        case 't':
            [self addSmoothQuad:nums Relative:YES];
            break;
        case 'H':
            [self addHorizon:nums Relative:NO];
            break;
        case 'h':
            [self addHorizon:nums Relative:YES];
            break;
        case 'V':
            [self addVertical:nums Relative:NO];
            break;
        case 'v':
            [self addVertical:nums Relative:YES];
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


/**
 移动path，将path移动到某一个点

 @param nums 需要移动到的点，数组包含2n个浮点数，分别为x和y坐标
 @param relative 是否是相对位置，如果相对，需要以前一个命令的终点为起点
 */
- (void)move:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < nums.count / 2; i++) {
        
        CGPoint p = CGPointMake(nums[i*2].doubleValue, nums[i*2+1].doubleValue);
        
        if (relative) {
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        [self.path moveToPoint:p];
        
        _end = p;
    }
}


/**
 添加直线

 @param nums 直线上的点
 @param relative 坐标是否是相对位置
 */
- (void)addLine:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < nums.count / 2; i++) {
        
        CGPoint p = CGPointMake(nums[i*2].doubleValue, nums[i*2+1].doubleValue);
        
        if (relative) {
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        
        [self.path addLineToPoint:p];
        
        _end = p;
    }
}

#pragma mark - TODO:
- (void)addArc:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
}

#pragma mark - 三次贝塞尔曲线和重复三次贝塞尔曲线
/**
 创建三次贝塞尔曲线

 @param nums 控制点1、控制点2和终点
 @param relative 坐标是否是相对位置
 */
- (void)addCurve:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [nums count] / 6; i++) {
        
        CGPoint c1 = CGPointMake(nums[i*6].doubleValue, nums[i*6+1].doubleValue);
        CGPoint c2 = CGPointMake(nums[i*6+2].doubleValue, nums[i*6+3].doubleValue);
        CGPoint p  = CGPointMake(nums[i*6+4].doubleValue, nums[i*6+5].doubleValue);
        
        if (relative) {
            c1 = CGPointMake(_end.x + c1.x, _end.y + c1.y);
            c2 = CGPointMake(_end.x + c2.x, _end.y + c2.y);
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        
        [self.path addCurveToPoint:p controlPoint1:c1 controlPoint2:c2];
        
        _end = p;
        _c_pre = c2;
    }
}


/**
 创建三次贝塞尔曲线，其中第一个控制点由前一条曲线决定，如果前一命令不是三次贝塞尔曲线，则第一个控制点与第二个控制点相同

 @param nums 第二个控制点和终点
 @param relative 坐标是否是相对位置
 */
- (void)addSmoothCurve:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < nums.count / 4; i++) {
        
        CGPoint c1;
        CGPoint c2 = CGPointMake(nums[i*2].doubleValue, nums[i*2+1].doubleValue);
        CGPoint p = CGPointMake(nums[i*2+2].doubleValue, nums[i*2+3].doubleValue);
        
        if (relative) {
            c2 = CGPointMake(_end.x + c2.x, _end.y + c2.y);
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        
        // 如果前一个命令不是C命令或者S命令，则第一个控制点与第二个控制点相同
        if (CGPointEqualToPoint(_c_pre, CGPointZero)) {
            c1 = c2;
        } else {
            c1 = CGPointMake(_end.x + (_end.x - _c_pre.x), _end.y + (_end.y - _c_pre.y));
        }
        
        [self.path addCurveToPoint:p controlPoint1:c1 controlPoint2:c2];
        
        _end = p;
        _c_pre = c2;
    }
}

#pragma mark - 二次贝塞尔曲线和重复二次贝塞尔曲线

/**
 创建二次贝塞尔曲线

 @param nums 控制点和终点
 @param relative 坐标是否是相对位置
 */
- (void)addQuad:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < [nums count] / 4; i++) {
        
        CGPoint c = CGPointMake(nums[i*4].doubleValue, nums[i*4+1].doubleValue);
        CGPoint p = CGPointMake(nums[i*4+2].doubleValue, nums[i*4+3].doubleValue);
        
        if (relative) {
            c = CGPointMake(_end.x + c.x, _end.y + c.y);
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        
        [self.path addQuadCurveToPoint:p controlPoint:c];
        
        _end = p;
        _q_pre = c;
    }
}


/**
 创建二次贝塞尔曲线，其中控制点由前一条曲线决定，如果前一命令不是二次贝塞尔曲线，则控制点与终点相同

 @param nums 终点
 @param relative 坐标是否是相对位置
 */
- (void)addSmoothQuad:(NSArray<NSNumber *> *)nums Relative:(BOOL)relative {
    
    for (NSInteger i = 0; i < nums.count / 2; i++) {
        
        CGPoint p = CGPointMake(nums[i*2].doubleValue, nums[i*2+1].doubleValue);
        CGPoint c;
        
        if (relative) {
            p = CGPointMake(_end.x + p.x, _end.y + p.y);
        }
        
        if (CGPointEqualToPoint(_q_pre, CGPointZero)) {
            c = p;
        } else {
            c = CGPointMake(_end.x + (_end.x - _q_pre.x), _end.y + (_end.y - _q_pre.y));
        }
        
        [self.path addQuadCurveToPoint:p controlPoint:c];
        
        _end = p;
        _q_pre = c;
    }
}

#pragma mark - 平行直线和垂直直线

/**
 根据前一个坐标创建水平直线

 @param numbers x坐标
 @param relative 坐标是否是相对位置
 */
- (void)addHorizon:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSNumber *number in numbers) {
        
        CGPoint p = CGPointMake(number.doubleValue, _end.y);
        
        if (relative) {
            p = CGPointMake(_end.x + p.x, _end.y);
        }
        [self.path addLineToPoint:p];
        
        _end = p;
    }
}

/**
 根据前一个坐标创建垂直直线
 
 @param numbers y坐标
 @param relative 坐标是否是相对位置
 */
- (void)addVertical:(NSArray<NSNumber *> *)numbers Relative:(BOOL)relative {
    
    for (NSNumber *number in numbers) {
        
        CGPoint p = CGPointMake(_end.x, number.doubleValue);
        
        if (relative) {
            p = CGPointMake(_end.x, _end.y + p.y);
        }
        [self.path addLineToPoint:p];
        
        _end = p;
    }
}

#pragma mark - 关闭贝塞尔曲线
- (void)close {
    [self.path closePath];
}

@end
