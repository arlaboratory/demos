//
//  LineView.m
//  HelloImageMatching
//
//  Copyright (c) 2012 ARLab. All rights reserved.
//

#import "LineView.h"

@implementation LineView

@synthesize frameRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float xOrigin = frameRect.origin.x;
    float yOrigin = frameRect.origin.y;
    float Width = frameRect.size.width;
    float Height = frameRect.size.height;
    float xOriginAUx = xOrigin;
    float yOriginAux = yOrigin;
    float wAux = Width;
    float hAux = Height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {1.0, 0.0, 0.0, 1.0};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context,xOriginAUx, yOriginAux);
    CGContextAddLineToPoint(context,xOriginAUx+ wAux, yOriginAux);
    CGContextAddLineToPoint(context, xOriginAUx+wAux,yOriginAux+ hAux);
    CGContextAddLineToPoint(context, xOriginAUx, yOriginAux+hAux);
    CGContextAddLineToPoint(context, xOriginAUx, yOriginAux);
    
    CGContextStrokePath(context);
}

@end
