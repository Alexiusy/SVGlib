# FXSVG
A repository to parse SVG and draw it on the screen as UIShapeLayer.

## Done
Parse basic element like path, line, rect, circle, ellipse, polygon and polyline.

## Usage
```
FXSVGView *svgView = [[FXSVGView alloc] initWithFrame:frame];
[svgView loadMap:svgname withColors:nil];
[self.view addSubview:svgView];
```
Then, that's done.

## TODO
Filter and gradient effect etc.


