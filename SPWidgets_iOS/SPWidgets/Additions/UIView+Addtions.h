//
//  UIView+Addtions.h
//
//  Created by Roselifeye on 14-5-6.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addtions)

//  Get the screen shot.
- (UIImage *)getViewShot;

- (void)setBackgroundImage:(UIImage *)image;


@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGFloat frameTrailing;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@end
