# SVGlib
A repository for displaying SVG with CAShapeLayer.



![screenshot](http://7xlzdc.com1.z0.glb.clouddn.com/screenshot.gif)

## Feature
Parse basic element like path, line, rect, circle, ellipse, polygon and polyline.

- Display a svg on the iPhone screen with CAShapeLayer.
- Support select single layer.
- Support svg original transform.

## Usage
```objective-c
// filePath is the svg file path.
let svgView = SVGView().parse(filePath)
svgView.center = CGPoint(x: 200, y: 300)
svgView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)

self.view.addSubview(svgView);
```
Then, that's done.

## TODO

- Add gradient effect and filter effect support.