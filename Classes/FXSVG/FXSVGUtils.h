//
//  FXSVGUtils.h
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXSVGUtils : NSObject

+ (NSArray *)parsePoints:(const char *)str;
+ (CGAffineTransform)parseTransform:(NSString*)str;

@end
