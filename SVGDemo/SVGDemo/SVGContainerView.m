//
//  SVGContainerView.m
//  SVGDemo
//
//  Created by Zeacone on 2017/7/12.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import "SVGContainerView.h"

@implementation SVGContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"subway.svg"];
    self.svg = [[SVGView alloc] initWithFilePath:filePath];
    [self addSubview:self.svg];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    
    pan.delegate = self;
    pinch.delegate = self;
    rotate.delegate = self;
    
    self.gestureRecognizers = @[pan, pinch, rotate];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:pan.view];
    
    CGAffineTransform _trans = self.svg.transform;
    CGFloat currentDegree = atan2(_trans.b, _trans.a);
    CGFloat currentScale = sqrt(pow(_trans.a, 2) + pow(_trans.c, 2));
    
    //三角函数坐标转换
    CGFloat x;
    CGFloat y;
    if (currentDegree < 0) {
        x = translation.x * cos(-currentDegree) - translation.y * sin(-currentDegree);
        y = translation.x * sin(-currentDegree) + translation.y * cos(-currentDegree);
    } else {
        x = translation.x * cos(currentDegree) + translation.y * sin(currentDegree);
        y = - translation.x * sin(currentDegree) + translation.y * cos(currentDegree);
    }
    
    self.svg.transform = CGAffineTransformTranslate(self.svg.transform, x/currentScale, y/currentScale);
    
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [pinch locationInView:self.svg];
            CGPoint anchorPoint = [self getAnchorPoint:location forView:self.svg];
            [self setAnchorPoint:anchorPoint forView:self.svg];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            self.svg.transform = CGAffineTransformScale(self.svg.transform, pinch.scale, pinch.scale);
            pinch.scale = 1;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
//            [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self.svg];
            break;
            
        default:
            break;
    }
}

- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    switch (rotate.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint location = [rotate locationInView:self.svg];
            CGPoint anchorPoint = [self getAnchorPoint:location forView:self.svg];
            [self setAnchorPoint:anchorPoint forView:self.svg];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            self.svg.transform = CGAffineTransformRotate(self.svg.transform, rotate.rotation);
            rotate.rotation = 0;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
//            [self setAnchorPoint:CGPointMake(0.5, 0.5) forView:self.svg];
            break;
            
        default:
            break;
    }
}

- (CGPoint)getAnchorPoint:(CGPoint)point forView:(UIView *)view {
    return CGPointMake(point.x / view.bounds.size.width, point.y / view.bounds.size.height);
}

- (void)setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorpoint;
    view.frame = oldFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
