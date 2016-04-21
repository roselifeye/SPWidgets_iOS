//
//  SPCircleMenuItem.h
//
//  Created by Roselifeye on 14-3-4.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPCircleMenuItemDelegate;

@interface SPCircleMenuItem : UIImageView {
    UIImageView *_contentImageView;
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _nearPoint; // near
    CGPoint _farPoint; // far
    
    id<SPCircleMenuItemDelegate> __weak _delegate;
}

@property (nonatomic, strong, readonly) UIImageView *contentImageView;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, weak) id<SPCircleMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg;


@end

@protocol SPCircleMenuItemDelegate <NSObject>
- (void)SPCircleMenuItemTouchesBegan:(SPCircleMenuItem *)item;
- (void)SPCircleMenuItemTouchesEnd:(SPCircleMenuItem *)item;

@end
