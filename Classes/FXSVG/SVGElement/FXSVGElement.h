//
//  FXSVGElement.h
//  FXSVG
//
//  Created by Zeacone on 16/3/5.
//  Copyright © 2016年 Zeacone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FXSVGElement : NSObject

@property (nonatomic, strong) NSString     *title;
@property (nonatomic, strong) NSString     *identifier;
@property (nonatomic, strong) NSString     *className;
@property (nonatomic, strong) NSString     *tranform;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) BOOL         clickable;
@property (nonatomic, strong) UIColor      *fillColor;
@property (nonatomic, strong) UIColor      *strokeColor;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
