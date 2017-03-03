//
//  SVGElement.m
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import "SVGElement.h"

@implementation SVGElement

- (instancetype)initWithAttribute:(NSDictionary *)attr
{
    self = [super init];
    if (self) {
        [self readAttribute:attr];
    }
    return self;
}

- (void)readAttribute:(NSDictionary *)attr {
    
    self.selectable = NO;
    self.title      = attr[@"title"];
    self.identifier = attr[@"id"];
    self.className  = attr[@"class"];
    self.tranform   = attr[@"transform"];
    
    
    NSMutableDictionary *property = [NSMutableDictionary dictionary];
    
    NSString *style = attr[@"style"];
    NSCharacterSet *separateSet = [NSCharacterSet characterSetWithCharactersInString:@":;"];
    NSArray *components = [style componentsSeparatedByCharactersInSet:separateSet];
    
    for (NSInteger i = 0; i < components.count / 2; i++) {
        [property setObject:components[i*2] forKey:components[i*2+1]];
    }
    
    self.strokeColor = [self colorWithHexString:attr[@"stroke"]];
    NSString *fillColorStr = property[@"fill"] ? property[@"fill"] : attr[@"fill"];
    self.fillColor = [self colorWithHexString:fillColorStr];
    
    [self initialize];
}

- (void)initialize {
    self.path  = [UIBezierPath bezierPath];
    self.shape = [CAShapeLayer layer];
    self.shape.fillColor = self.fillColor.CGColor;
    self.shape.strokeColor = self.strokeColor.CGColor;
    self.shape.lineWidth = 1.0;
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //    0x123455; #FD43672
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
