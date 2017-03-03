//
//  SVGParser.h
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *layers;

- (void)parseFile:(NSString *)fileName;

@end
