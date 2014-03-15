//
//  CGLayerRefTest.m
//  CGLayerRefTesting
//
//  Created by Administrator on 14.03.14.
//  Copyright (c) 2014 tickino. All rights reserved.
//

#import "CGLayerRefTest.h"

@implementation CGLayerRefTest

static int radius = 40;
static int stroke = 10;

CGLayerRef circleLayer;
CGLayerRef bezierLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // [self prepareCircleCGLayerWithContext:ctx];
    // [self prepareBezierCGLayerWithContext:ctx];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self prepareCircleCGLayerWithContext:ctx];
    [self prepareBezierCGLayerWithContext:ctx];

    CGContextTranslateCTM(ctx, self.center.x - (radius + stroke), 50);
    [self drawCircleCGLayerToContext:ctx];
    
    CGContextTranslateCTM(ctx, 0, 3 * radius);
    [self drawBezierCGLayerToContext:ctx];
    
    CGContextTranslateCTM(ctx, 0, 3 * radius);
    [self drawCircleToContext:ctx];
}

- (void)prepareBezierCGLayerWithContext:(CGContextRef)ctx
{
    CGFloat s = stroke;
    CGFloat r = radius;
    
    CGLayerRef tmpLayer = CGLayerCreateWithContext(ctx, CGSizeMake(2 * (r + s), 2 * (r + s)), NULL);
    CGContextRef bezierContext = CGLayerGetContext(tmpLayer);
    
    CGLayerRelease(bezierLayer);
    bezierLayer = tmpLayer;
    
    CGContextSetLineWidth(bezierContext, s);
    CGContextSetLineDash(bezierContext, 0, NULL, 0);
    CGContextSetRGBFillColor(bezierContext, 0, 0, 0, 0);
    
    CGContextSetStrokeColorWithColor(bezierContext, [[UIColor grayColor] CGColor]);
    CGContextSetFillColorWithColor(bezierContext, [[UIColor whiteColor] CGColor]);
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPath];
    [roundedPath addArcWithCenter:CGPointMake((r + s), (r + s)) radius:r startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    
    CGContextAddPath(bezierContext, [roundedPath CGPath]);
    CGContextDrawPath(bezierContext, kCGPathFillStroke);
}

- (void)prepareCircleCGLayerWithContext:(CGContextRef)ctx
{
    CGFloat s = stroke;
    CGFloat r = radius;
    
    CGLayerRef tmpLayer = CGLayerCreateWithContext(ctx, CGSizeMake(2 * (r + s), 2 * (r + s)), NULL);
    CGContextRef circleContext = CGLayerGetContext(tmpLayer);
    
    CGLayerRelease(circleLayer);
    circleLayer = tmpLayer;
    
    CGContextSetLineWidth(circleContext, s);
    CGContextSetLineDash(circleContext, 0, NULL, 0);
    CGContextSetRGBFillColor(circleContext, 0, 0, 0, 0);
    
    CGContextSetStrokeColorWithColor(circleContext, [[UIColor grayColor] CGColor]);
    CGContextSetFillColorWithColor(circleContext, [[UIColor whiteColor] CGColor]);
    
    CGContextAddArc(circleContext, r + s, r + s, r, 0.0, M_PI*2, YES);
    CGContextDrawPath(circleContext, kCGPathFillStroke);
}

- (void)drawCircleCGLayerToContext:(CGContextRef)ctx
{
    CGContextDrawLayerAtPoint(ctx, CGPointMake(0, 0), circleLayer);
}

- (void)drawBezierCGLayerToContext:(CGContextRef)ctx
{
    CGContextDrawLayerAtPoint(ctx, CGPointMake(0, 0), bezierLayer);
}

- (void)drawCircleToContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGFloat s = stroke;
    CGFloat rxy = radius + stroke;
    CGFloat r = radius;
    
    CGContextSetLineWidth(ctx, s);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0);
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor grayColor] CGColor]);
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    
    CGContextAddArc(ctx, rxy, rxy, r, 0.0, M_PI*2, YES);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextRestoreGState(ctx);
}


@end
