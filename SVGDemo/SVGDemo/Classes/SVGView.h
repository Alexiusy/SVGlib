//
//  SVGView.h
//  SVGTest
//
//  Created by Zeacone on 2017/2/25.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVG.h"

@interface CAShapeLayer (selectable)

- (NSNumber *)selectable;
- (void)setSelectable:(NSNumber *)selectable;

@end

@interface SVGView : UIView

- (instancetype)initWithFilePath:(NSString *)filePath;
- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath;


@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) NSArray<SVGElement *> *elements;

@property (nonatomic, assign) CGSize size;

@end
