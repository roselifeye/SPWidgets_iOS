//
//  UIImage+Addtions.h
//
//  Created by Roselifeye on 14-5-6.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addtions)

//  Blur the Image with desired percentage
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

//  Scale the image into desired size.
- (UIImage *)scaletoSize:(CGSize)size;

//  Intercept the image by desired size and position.
- (UIImage*)getSubImage:(CGRect)rect;

//  Rotate image.
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
