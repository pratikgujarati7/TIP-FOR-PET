//
//  CustomLabel.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 25/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "CustomLabel.h"
#import "MySingleton.h"

@implementation CustomLabel

- (void)drawTextInRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.floatBorderWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    //========== BORDER COLOR OF TEXT ==========//
    self.textColor = self.textBorderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
    
}

@end
