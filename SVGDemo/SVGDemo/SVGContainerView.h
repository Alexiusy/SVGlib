//
//  SVGContainerView.h
//  SVGDemo
//
//  Created by Zeacone on 2017/7/12.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGView.h"

@interface SVGContainerView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) SVGView *svg;

@end
