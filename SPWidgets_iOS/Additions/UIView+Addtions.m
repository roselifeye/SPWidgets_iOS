//
//  UIView+Addtions.m
//
//  Created by Roselifeye on 14-5-6.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "UIView+Addtions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Addtions)

- (UIImage *)getViewShot {
    
    CGRect rect = [self bounds];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
	[[self layer] renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return image;
}

- (void)setBackgroundImage:(UIImage *)image {
    self.layer.contents = (id) image.CGImage;
    //  If u want the background to be transparent, please add this line.
    self.backgroundColor = [UIColor clearColor];
}


@end
