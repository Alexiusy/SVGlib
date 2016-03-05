//
//  FXSVGUtils.m
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXSVGUtils.h"

@implementation FXSVGUtils

+ (NSArray*)parsePoints:(const char *)str {
    NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:str]];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    NSMutableArray* array = [NSMutableArray array];
    
    float value = 0;
    while([scanner scanFloat:&value]) {
        NSNumber* number = [NSNumber numberWithFloat:value];
        [array addObject:number];
    }
    return array;
}

+ (CGAffineTransform)parseTransform:(NSString*)str {
    CGAffineTransform tranform = CGAffineTransformIdentity;
    
    if([str length] > 0) {
        tranform = CGAffineTransformConcat(tranform, [self parseMatrix:str]);
        tranform = CGAffineTransformConcat(tranform, [self parseTranslate:str]);
    }
    return tranform;
}

+ (CGAffineTransform)parseMatrix:(NSString*)str {
    CGAffineTransform tranform = CGAffineTransformIdentity;
    NSRange range = NSMakeRange(0, [str length]);
    NSString* patternMatrix = @"matrix\\((.*)\\)";
    NSError* regexError = nil;
    
    NSRegularExpression* regexMatrix = [NSRegularExpression regularExpressionWithPattern:patternMatrix
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&regexError];
    
    if(!regexError) {
        NSArray* matches = [regexMatrix matchesInString:str
                                                options:NSMatchingWithoutAnchoringBounds
                                                  range:range];
        if(matches.count > 0) {
            NSTextCheckingResult *entry = matches[0];
            NSString *parameters = [str substringWithRange:[entry rangeAtIndex:1]];
            NSArray* coordinates = [FXSVGUtils parsePoints:[parameters UTF8String]];
            
            if([coordinates count] == 6) {
                // We need a 3x3 matrix
                tranform = CGAffineTransformMake([coordinates[0] floatValue], [coordinates[1] floatValue], [coordinates[2] floatValue], [coordinates[3] floatValue], [coordinates[4] floatValue], [coordinates[5] floatValue]);
            }
        }
    }
    return tranform;
}

+ (CGAffineTransform)parseTranslate:(NSString*)str {
    CGAffineTransform tranform = CGAffineTransformIdentity;
    NSRange range = NSMakeRange(0, [str length]);
    NSString* patternTranslate = @"translate\\((.*)\\)";
    NSError* regexError = nil;
    
    NSRegularExpression* regexTranslate = [NSRegularExpression regularExpressionWithPattern:patternTranslate
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:&regexError];
    
    if(!regexError) {
        NSArray* matches = [regexTranslate matchesInString:str
                                                   options:NSMatchingWithoutAnchoringBounds
                                                     range:range];
        if([matches count] > 0) {
            // We have a match, lets parse the points
            NSTextCheckingResult *entry = matches[0];
            NSString *parameters = [str substringWithRange:[entry rangeAtIndex:1]];
            NSArray* coordinates = [FXSVGUtils parsePoints:[parameters UTF8String]];
            
            if([coordinates count] == 2) {
                tranform = CGAffineTransformMakeTranslation([coordinates[0] floatValue], [coordinates[1] floatValue]);
            }
        }
    }
    return tranform;
}

@end
