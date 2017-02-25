//
//  SVGElement.h
//  Inspiration
//
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 ics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGElement : NSObject

- (instancetype)initWithAttribute:(NSDictionary *)attribute;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *tranform;
@property (nonatomic, copy) NSString *group;
@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) BOOL selectable;

@end
