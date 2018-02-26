//
//  SPGameStick.h
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-16.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPGameStick;
@protocol SPGameStickDelegate <NSObject>

@required

- (void)stickDidMoved:(SPGameStick *)gameStick withMovedCoodinate:(CGPoint)coordinate;

@end


@interface SPGameStick : UIView

@property (nonatomic, assign) id<SPGameStickDelegate> delegate;

@end
