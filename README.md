# SVGlib
A repository for displaying SVG with CAShapeLayer.

## Feature
Parse basic element like path, line, rect, circle, ellipse, polygon and polyline.

- Display a svg on the iPhone screen with CAShapeLayer.
- Support select single layer.
- Support svg original transform.

## Usage
```objective-c
// svgView is a instance of SVGView.
self.svgView.filePath = @"filename.svg";
[self.view addSubview:self.svgView];
```
Then, that's done.

## TODO

- Add gradient effect and filter effect support.