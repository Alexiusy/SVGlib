//
//  SVGTransformParser.h
//  Personality
//
//  Created by Zeacone on 2017/5/27.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGTransformParser : NSObject

+ (CGAffineTransform)transformFromString:(NSString *)transformString;

@end
