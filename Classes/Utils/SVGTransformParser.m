//
//  SVGTransformParser.m
//  Personality
//
//  Created by Zeacone on 2017/5/27.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import "SVGTransformParser.h"

@implementation SVGTransformParser

+ (CGAffineTransform)transformFromString:(NSString *)transformString {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"translate|scale|rotate" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray<NSTextCheckingResult *> *checkResults = [regex matchesInString:transformString options:0 range:NSMakeRange(0, [transformString length])];
    
    NSScanner *scanner = [NSScanner scannerWithString:transformString];
    
    NSMutableCharacterSet *skippedCharacterSet = [[NSMutableCharacterSet alloc] init];
    [skippedCharacterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    [skippedCharacterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@",() "]];
    
    scanner.charactersToBeSkipped = skippedCharacterSet;
    
    for (NSTextCheckingResult *result in checkResults) {
        
        if ([[transformString substringWithRange:result.range] isEqualToString:@"translate"]) {
            CGFloat valueX;
            CGFloat valueY;
            [scanner scanDouble:&valueX];
            [scanner scanDouble:&valueY];
            transform = CGAffineTransformTranslate(transform, valueX, valueY);
        } else if ([[transformString substringWithRange:result.range] isEqualToString:@"rotate"]) {
            CGFloat angle;
            [scanner scanDouble:&angle];
            
            transform = CGAffineTransformRotate(transform, [self.class radianFromAngle:angle]);
            
        } else if ([[transformString substringWithRange:result.range] isEqualToString:@"scale"]) {
            
            CGFloat scale;
            [scanner scanDouble:&scale];
            transform = CGAffineTransformScale(transform, scale, scale);
        }
    }
    
    return transform;
}

+ (CGFloat)radianFromAngle:(CGFloat)angle {
    return angle / 180.0 * M_PI;
}

@end
