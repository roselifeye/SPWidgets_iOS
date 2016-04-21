//
//  SPCircleMenuItem.m
//
//  Created by Roselifeye on 14-3-4.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "SPCircleMenuItem.h"

static inline CGRect ScaleRect(CGRect rect, float n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}
@implementation SPCircleMenuItem

@synthesize contentImageView = _contentImageView;

@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize nearPoint = _nearPoint;
@synthesize farPoint = _farPoint;
@synthesize delegate  = _delegate;


#pragma mark - initialization & cleaning up
- (id)initWithImage:(UIImage *)img
   highlightedImage:(UIImage *)himg
       ContentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg; {
    if (self = [super init]) {
        self.image = img;
        self.highlightedImage = himg;
        self.userInteractionEnabled = YES;
        _contentImageView = [[UIImageView alloc] initWithImage:cimg];
        _contentImageView.highlightedImage = hcimg;
        [self addSubview:_contentImageView];
    }
    return self;
}

#pragma mark - UIView's methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    
    float width = _contentImageView.image.size.width;
    float height = _contentImageView.image.size.height;
    _contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
    if ([_delegate respondsToSelector:@selector(SPCircleMenuItemTouchesBegan:)])
        [_delegate SPCircleMenuItemTouchesBegan:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // if move out of 2x rect, cancel highlighted.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
        self.highlighted = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
    // if stop in the area of 2x rect, response to the touches event.
    CGPoint location = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
        if ([_delegate respondsToSelector:@selector(SPCircleMenuItemTouchesEnd:)])
            [_delegate SPCircleMenuItemTouchesEnd:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}

#pragma mark - instant methods
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [_contentImageView setHighlighted:highlighted];
}

@end
