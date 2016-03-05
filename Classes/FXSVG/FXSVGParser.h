//
//  FXSVGParser.h
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXSVGParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic) CGRect bounds;

+ (instancetype)svgWithFile:(NSString*)filePath;

@end
