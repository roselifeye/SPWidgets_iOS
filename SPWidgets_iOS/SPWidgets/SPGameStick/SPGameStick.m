//
//  SPGameStick.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-16.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "SPGameStick.h"

#define RatioOfCenterAndBG 68/128

#define MoveBtnR 15

@interface SPGameStick () {
    UIImageView *stickBG;
    UIImageView *stickCenter;
    
    float minSizeWidth;
    
    CGPoint sCenter;
}

@end

@implementation SPGameStick

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initStickController];
        self.tag = 9999;
    }
    return self;
}

- (void)initStickController {
    sCenter = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    
    stickCenter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [stickCenter setImage:[UIImage imageNamed:@"round_center"]];
    [stickCenter setCenter:sCenter];
    
    stickBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    [stickBG setImage:[UIImage imageNamed:@"stick_BG"]];
    [stickBG addSubview:stickCenter];
    
    [self addSubview:stickBG];
}


- (void)stickTouched:(NSSet<UITouch *> *)touches {
    if([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    
    if(view != self)
        return;
    
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint disOffset, disToCenter, maxOffset, maxCenter;
    
    maxCenter.x = maxOffset.x = disToCenter.x = disOffset.x = touchPoint.x - sCenter.x;
    maxCenter.y = maxOffset.y = disToCenter.y = disOffset.y = touchPoint.y - sCenter.y;
    
    double len = sqrt(disToCenter.x*disToCenter.x + disToCenter.y*disToCenter.y);
    float largestOffset = self.frame.size.width/2-(self.frame.size.width/2)*RatioOfCenterAndBG;
    
    if(len < 0.1 && len > -0.10) {
        //  If the |len| is smaller than 1, the stick is considered not moved.
        maxCenter.x = maxOffset.x = disToCenter.x = disOffset.x = 0.f;
        maxCenter.y = maxOffset.y = disToCenter.y = disOffset.y = 0.f;
    } else {
        //  Calculate the Max Offset and Center.
        //  Normalize the distance.
        double len_inv = (1.0 / len);
        maxOffset.x *= len_inv;
        maxOffset.y *= len_inv;
        maxCenter.x = maxOffset.x * largestOffset;
        maxCenter.y = maxOffset.y * largestOffset;
        //  Obtain the real Center, and limite it with maxCenter.
        disToCenter.x = (len>largestOffset)?maxCenter.x:disToCenter.x;
        disToCenter.y = (len>largestOffset)?maxCenter.y:disToCenter.y;
        //  Nomarlize X and Y, and rerange the direction.
        disOffset.x = (disToCenter.x)/largestOffset;
        disOffset.y = -(disToCenter.y)/largestOffset;
    }
    
    [self stickMoveTo:disToCenter];
    
    if ([self.delegate respondsToSelector:@selector(stickDidMoved:withMovedCoodinate:)]) {
        [self.delegate stickDidMoved:self withMovedCoodinate:disOffset];
    }
}

/**
 *  The stick will move to the coordinate
 *
 *  @param offSetToCenter The distance to the Center of the ImageView.
 */
- (void)stickMoveTo:(CGPoint)offSetToCenter {
    CGRect fr = stickCenter.frame;
    fr.origin.x = offSetToCenter.x;
    fr.origin.y = offSetToCenter.y;
    stickCenter.frame = fr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickMoveTo:CGPointMake(0, 0)];

    if ([self.delegate respondsToSelector:@selector(stickDidMoved:withMovedCoodinate:)]) {
        [self.delegate stickDidMoved:self withMovedCoodinate:CGPointMake(0, 0)];
    }
}

@end
