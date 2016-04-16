//
//  SPGameStickController.h
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-04-16.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPGameStickController;
@protocol SPGameStickControllerDelegate <NSObject>

@required
- (void)stickValueDidChanged:(SPGameStickController *)gameStick withChangedCoodinate:(CGPoint)coordinate;

@end

@interface SPGameStickController : UIView

@property (nonatomic, assign) id<SPGameStickControllerDelegate> delegate;

@end
