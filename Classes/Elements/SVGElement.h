//
//  SVGElement.h
//  
//  Created by Zeacone on 2017/1/24.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVGElement : NSObject

- (instancetype)initWithAttribute:(NSDictionary *)attr;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *tranform;
@property (nonatomic, copy) NSString *group;

#pragma mark - Public property
@property (nonatomic, strong) CAShapeLayer *shape;
@property (nonatomic, strong) UIBezierPath *path;

/**
 Some CAShapeLayer property
 */
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;


/**
 A boolean value that decide if the CAShapeLayer can be selected. Eg. Circle, Rectangle and Polygon can be selected and open path cannot be selected.
 */
@property (nonatomic, assign) BOOL selectable;

@end
