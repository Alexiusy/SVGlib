//
//  FXSVGView.h
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXSVG.h"

@interface FXSVGView : UIView

@property (nonatomic, strong) FXSVGParser    *svgParser;
@property (nonatomic, strong) NSMutableArray *scaledPath;
// Graphical properties
@property (nonatomic, strong) UIColor        *fillColor;
@property (nonatomic, strong) UIColor        *strokeColor;

// Click handler
@property (nonatomic, copy) void (^clickHandler)(NSString *identifier, CAShapeLayer *layer);

// Loading functions
- (void)loadSVGFile:(NSString *)filename;

@end
