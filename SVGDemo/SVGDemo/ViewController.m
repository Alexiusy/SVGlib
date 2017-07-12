//
//  ViewController.m
//  SVGDemo
//
//  Created by Zeacone on 2017/7/12.
//  Copyright © 2017年 zeacone. All rights reserved.
//

#import "ViewController.h"
#import "SVGContainerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SVGContainerView *container = [[SVGContainerView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:container];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
