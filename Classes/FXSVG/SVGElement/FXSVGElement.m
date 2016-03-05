//
//  FXSVGElement.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import "FXSVGElement.h"

#define colorFromHex(hex, a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

// Setting color from normal RGB way.
#define colorFromRGB(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

@implementation FXSVGElement

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.clickable  = NO;
    self.title      = [attributes objectForKey:@"title"];
    self.identifier = [attributes objectForKey:@"id"];
    self.className  = [attributes objectForKey:@"class"];
    self.tranform   = [attributes objectForKey:@"transform"];
    self.path       = [UIBezierPath bezierPath];
    
    NSString *style = [attributes objectForKey:@"style"];
    NSArray *styleComponents = [style componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":;"]];
    NSMutableArray *components = [NSMutableArray arrayWithArray:styleComponents];
    [components removeLastObject];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (NSInteger i = 0; i < components.count; i += 2) {
        [dic setObject:components[i+1] forKey:components[i]];
    }
    
    if ([dic objectForKey:@"fill"]) {
        self.fillColor = [self colorWithHexString:[dic objectForKey:@"fill"]];
    } else if ([attributes objectForKey:@"fill"]) {
        self.fillColor = [self colorWithHexString:[attributes objectForKey:@"fill"]];
    }
    
    if ([attributes objectForKey:@"stroke"]) {
        self.strokeColor = [self colorWithHexString:[attributes objectForKey:@"stroke"]];
    } else {
        self.strokeColor = [UIColor blackColor];
    }
    
    return self;
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //    0x123455; #FD43672
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
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
