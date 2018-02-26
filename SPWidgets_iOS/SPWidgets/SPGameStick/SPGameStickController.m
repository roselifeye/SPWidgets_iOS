//
//  SPGameStickController.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-16.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "SPGameStickController.h"
#import "SPGameStick.h"

#define MoveBtnR 15

@interface SPGameStickController () <SPGameStickDelegate> {
    SPGameStick *gameStick;
    UIImageView *moveBtn;
    UIPanGestureRecognizer *panGesture;
    UILongPressGestureRecognizer *longPressGes;
}

@end

@implementation SPGameStickController

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initMoveBtn];
        [self initStick];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickMoved:)];
    }
    return self;
}

- (void)initStick {
    float minSizeWidth = (self.frame.size.width>self.frame.size.height)?self.frame.size.width-MoveBtnR:self.frame.size.height-MoveBtnR;
    gameStick = [[SPGameStick alloc] initWithFrame:CGRectMake(0, 0, minSizeWidth, minSizeWidth)];
    gameStick.delegate = self;
    [self addSubview:gameStick];
}

- (void)initMoveBtn {
    moveBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-MoveBtnR*2, self.frame.size.height-MoveBtnR*2, MoveBtnR*2, MoveBtnR*2)];
    [moveBtn setImage:[UIImage imageNamed:@"close"]];
    
    longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enableMoveStickView:)];
    longPressGes.minimumPressDuration = 1.f;
    longPressGes.numberOfTouchesRequired = 1;
    [moveBtn addGestureRecognizer:longPressGes];
    moveBtn.userInteractionEnabled = YES;
    
    [self addSubview:moveBtn];
}

/**
 *  Long press the Move Button,
 *  and will call the move function which means the Pan Gesture will be added to the self.
 *
 *  In addition,
 *  the animation of the view will be called.
 *
 *  @param sender Long press gesture.
 */
- (void)enableMoveStickView:(UILongPressGestureRecognizer *)sender {
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan: {
            //  Shake Animation Called.
            CABasicAnimation *animation = (CABasicAnimation *)[self.layer animationForKey:@"rotation"];
            if (animation == nil) {
                [self shakePlayView:self];
            }else {
                [self shakeResume];
            }
            //  PanGesture is added to self.
            [self addGestureRecognizer:panGesture];
            //  Forbid the touch of the gameStick to avoid the collision with PanGesture.
            gameStick.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
}

/**
 *  The three functions below implement the shake animation for the view.
 */
- (void)shakePause {
    self.layer.speed = 0.f;
}

- (void)shakeResume {
    self.layer.speed = 1.f;
}

- (void)shakePlayView:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.08];
    
    //  For this old frame, I will write a blog to illustrate it.
    CGRect oldFrame = view.frame;
    animation.fromValue = @(-M_1_PI/3);
    animation.toValue = @(M_1_PI/3);
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    view.layer.anchorPoint = CGPointMake(1, 1);
    [view.layer addAnimation:animation forKey:@"rotation"];
    view.frame = oldFrame;
}

/**
 *  Pan Gesture called.
 *
 *  @param sender PanGesture.
 */
- (void)stickMoved:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}

/**
 *  Remove the PanGesture when tap to stop the shake animation.
 *  ReEnable the Touch of the GameStick.
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeGestureRecognizer:panGesture];
    gameStick.userInteractionEnabled = YES;
    longPressGes.enabled = YES;
    [self shakePause];
}

#pragma mark - SPGameStick Delegate
- (void)stickDidMoved:(SPGameStick *)gameStick withMovedCoodinate:(CGPoint)coordinate {
    if ([self.delegate respondsToSelector:@selector(stickValueDidChanged:withChangedCoodinate:)]) {
        [self.delegate stickValueDidChanged:self withChangedCoodinate:coordinate];
    }
}

@end
