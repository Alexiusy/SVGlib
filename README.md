# SVGlib
A repository to parse SVG and draw it on the screen with CAShapeLayer.

## Feature
Parse basic element like path, line, rect, circle, ellipse, polygon and polyline.

## Usage
```objective-c
SVGView *svgView = [[FXSVGView alloc] initWithFrame:frame];
[svgView loadSVGFile:@"filename"];
[self.view addSubview:svgView];
```
Then, that's done.

## TODO

1. Add scale, rotate and select single layer.
2. Filter and gradient effect etc.
3. Parse global style.

