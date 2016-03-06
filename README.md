# FXSVG
A repository to parse SVG and draw it on the screen with CAShapeLayer.

## Done
Parse basic element like path, line, rect, circle, ellipse, polygon and polyline.

## Usage
```
FXSVGView *svgView = [[FXSVGView alloc] initWithFrame:frame];
[svgView loadSVGFile:@"filename"];
[self.view addSubview:svgView];
```
Then, that's done.

## TODO
1. Fill color is not display as I expected.
2. Some path and polyline is showing too much.
3. Filter and gradient effect etc.


