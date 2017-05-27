//
//  SVGParser.h
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGElement.h"

@interface SVGParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray<SVGElement *> *elements;

@property (nonatomic, assign) CGSize svgSize;

- (void)parseFile:(NSString *)fileName;

@end
