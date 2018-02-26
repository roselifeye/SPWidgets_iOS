//
//  SPCircleMenu.m
//
//  Created by Roselifeye on 14-3-4.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "SPCircleMenu.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const SPCircleMenuDefaultNearRadius = 110.0f;
static CGFloat const SPCircleMenuDefaultEndRadius = 120.0f;
static CGFloat const SPCircleMenuDefaultFarRadius = 140.0f;
static CGFloat const SPCircleMenuDefaultStartPointX = 160.0;
static CGFloat const SPCircleMenuDefaultStartPointY = 240.0;
static CGFloat const SPCircleMenuDefaultTimeOffset = 0.036f;
static CGFloat const SPCircleMenuDefaultRotateAngle = 0.0;
static CGFloat const SPCircleMenuDefaultMenuWholeAngle = M_PI * 2;
static CGFloat const SPCircleMenuDefaultExpandRotation = M_PI;
static CGFloat const SPCircleMenuDefaultCloseRotation = M_PI * 2;
static CGFloat const SPCircleMenuDefaultAnimationDuration = 0.5f;
static CGFloat const SPCircleMenuStartMenuDefaultAnimationDuration = 0.3f;

static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, float angle) {
    CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
    return CGPointApplyAffineTransform(point, transformGroup);
}

@interface SPCircleMenu ()
- (void)_expand;
- (void)_close;
- (void)_setMenu;
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p;
@end

@implementation SPCircleMenu {
    NSArray *_menusArray;
    int _flag;
    NSTimer *_timer;
    SPCircleMenuItem *_startButton;
    
    id<SPCircleMenuDelegate> __weak _delegate;
    BOOL _isAnimating;
}

@synthesize nearRadius, endRadius, farRadius, timeOffset, rotateAngle, menuWholeAngle, startPoint, expandRotation, closeRotation, animationDuration;
@synthesize expanding = _expanding;
@synthesize delegate = _delegate;
@synthesize menusArray = _menusArray;

#pragma mark - Initialization & Cleaning up
- (id)initWithFrame:(CGRect)frame startItem:(SPCircleMenuItem *)startItem optionMenus:(NSArray *)aMenusArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		
		self.nearRadius = SPCircleMenuDefaultNearRadius;
		self.endRadius = SPCircleMenuDefaultEndRadius;
		self.farRadius = SPCircleMenuDefaultFarRadius;
		self.timeOffset = SPCircleMenuDefaultTimeOffset;
		self.rotateAngle = SPCircleMenuDefaultRotateAngle;
		self.menuWholeAngle = SPCircleMenuDefaultMenuWholeAngle;
		self.startPoint = CGPointMake(SPCircleMenuDefaultStartPointX, SPCircleMenuDefaultStartPointY);
        self.expandRotation = SPCircleMenuDefaultExpandRotation;
        self.closeRotation = SPCircleMenuDefaultCloseRotation;
        self.animationDuration = SPCircleMenuDefaultAnimationDuration;
        
        self.menusArray = aMenusArray;
        
        // assign startItem to "Add" Button.
        _startButton = startItem;
        _startButton.delegate = self;
        _startButton.center = self.startPoint;
        [self addSubview:_startButton];
    }
    return self;
}


#pragma mark - Getters & Setters

- (void)setStartPoint:(CGPoint)aPoint {
    startPoint = aPoint;
    _startButton.center = aPoint;
}

#pragma mark - images
- (void)setImage:(UIImage *)image {
	_startButton.image = image;
}

- (UIImage*)image {
	return _startButton.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
	_startButton.highlightedImage = highlightedImage;
}

- (UIImage*)highlightedImage {
	return _startButton.highlightedImage;
}

- (void)setContentImage:(UIImage *)contentImage {
	_startButton.contentImageView.image = contentImage;
}

- (UIImage*)contentImage {
	return _startButton.contentImageView.image;
}

- (void)setHighlightedContentImage:(UIImage *)highlightedContentImage {
	_startButton.contentImageView.highlightedImage = highlightedContentImage;
}

- (UIImage*)highlightedContentImage {
	return _startButton.contentImageView.highlightedImage;
}


#pragma mark - UIView's methods
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // if the menu is animating, prevent touches
    if (_isAnimating)
        return NO;
    // if the menu state is expanding, everywhere can be touch
    // otherwise, only the add button are can be touch
    if (YES == _expanding)
        return YES;
    else
        return CGRectContainsPoint(_startButton.frame, point);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.expanding = !self.isExpanding;
}

#pragma mark - SPCirleMenuItem delegates
- (void)SPCircleMenuItemTouchesBegan:(SPCircleMenuItem *)item {
    if (item == _startButton)
        self.expanding = !self.isExpanding;
}
- (void)SPCircleMenuItemTouchesEnd:(SPCircleMenuItem *)item {
    // exclude the "add" button
    if (item == _startButton)
        return;
    // blowup the selected menu button
    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    // shrink other menu buttons
    for (int i = 0; i < [_menusArray count]; i ++) {
        SPCircleMenuItem *otherItem = [_menusArray objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag)
            continue;
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        otherItem.center = otherItem.startPoint;
    }
    _expanding = NO;
    
    // rotate start button
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:animationDuration animations:^{
        _startButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if ([_delegate respondsToSelector:@selector(SPCircleMenu:didSelectIndex:)])
        [_delegate SPCircleMenu:self didSelectIndex:item.tag - 1000];
}

#pragma mark - Instant methods
- (void)setMenusArray:(NSArray *)aMenusArray {
    if (aMenusArray == _menusArray)
        return;
    _menusArray = [aMenusArray copy];
    // clean subviews
    for (UIView *v in self.subviews) {
        if (v.tag >= 1000)
            [v removeFromSuperview];
    }
}

- (void)_setMenu {
	int count = [_menusArray count];
    for (int i = 0; i < count; i ++) {
        SPCircleMenuItem *item = [_menusArray objectAtIndex:i];
        item.tag = 1000 + i;
        item.startPoint = startPoint;
        
        // avoid overlap
        if (menuWholeAngle >= M_PI * 2)
            menuWholeAngle = menuWholeAngle - menuWholeAngle / count;
        CGPoint endPoint = CGPointMake(startPoint.x + endRadius * sinf(i * menuWholeAngle / (count - 1)), startPoint.y - endRadius * cosf(i * menuWholeAngle / (count - 1)));
        item.endPoint = RotateCGPointAroundCenter(endPoint, startPoint, rotateAngle);
        CGPoint nearPoint = CGPointMake(startPoint.x + nearRadius * sinf(i * menuWholeAngle / (count - 1)), startPoint.y - nearRadius * cosf(i * menuWholeAngle / (count - 1)));
        item.nearPoint = RotateCGPointAroundCenter(nearPoint, startPoint, rotateAngle);
        CGPoint farPoint = CGPointMake(startPoint.x + farRadius * sinf(i * menuWholeAngle / (count - 1)), startPoint.y - farRadius * cosf(i * menuWholeAngle / (count - 1)));
        item.farPoint = RotateCGPointAroundCenter(farPoint, startPoint, rotateAngle);
        item.center = item.startPoint;
        item.delegate = self;
		[self insertSubview:item belowSubview:_startButton];
    }
}

- (BOOL)isExpanding {
    return _expanding;
}

- (void)setExpanding:(BOOL)expanding {
	if (expanding)
		[self _setMenu];
	
    _expanding = expanding;
    
    // rotate add button
    float angle = self.isExpanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:SPCircleMenuStartMenuDefaultAnimationDuration animations:^{
        _startButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    // expand or close animation
    if (!_timer) {
        _flag = self.isExpanding ? 0 : ([_menusArray count] - 1);
        SEL selector = self.isExpanding ? @selector(_expand) : @selector(_close);
        
        // Adding timer to runloop to make sure UI event won't block the timer from firing
        _timer = [NSTimer timerWithTimeInterval:timeOffset target:self selector:selector userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        _isAnimating = YES;
    }
}

#pragma mark - Private methods
- (void)_expand {
	
    if (_flag == [_menusArray count]) {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    SPCircleMenuItem *item = (SPCircleMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:expandRotation],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = animationDuration;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3],
                                [NSNumber numberWithFloat:.4], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(_flag == [_menusArray count] - 1)
        [animationgroup setValue:@"firstAnimation" forKey:@"id"];
    
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
}

- (void)_close {
    if (_flag == -1) {
        _isAnimating = NO;
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    int tag = 1000 + _flag;
    SPCircleMenuItem *item = (SPCircleMenuItem *)[self viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:closeRotation],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = animationDuration;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = animationDuration;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    if(_flag == 0)
        [animationgroup setValue:@"lastAnimation" forKey:@"id"];
    
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    
    _flag --;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if([[anim valueForKey:@"id"] isEqual:@"lastAnimation"])
        if(self.delegate && [self.delegate respondsToSelector:@selector(SPCircleMenuDidFinishAnimationClose:)])
            [self.delegate SPCircleMenuDidFinishAnimationClose:self];
    
    if([[anim valueForKey:@"id"] isEqual:@"firstAnimation"])
        if(self.delegate && [self.delegate respondsToSelector:@selector(SPCircleMenuDidFinishAnimationOpen:)])
            [self.delegate SPCircleMenuDidFinishAnimationOpen:self];
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = animationDuration;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}


@end
