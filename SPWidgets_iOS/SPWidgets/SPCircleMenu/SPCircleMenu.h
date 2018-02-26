//
//  SPCircleMenu.h
//
//  Created by Roselifeye on 14-3-4.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCircleMenuItem.h"

@protocol SPCircleMenuDelegate;

@interface SPCircleMenu : UIView<SPCircleMenuItemDelegate> {
}

@property (nonatomic, copy) NSArray *menusArray;
@property (nonatomic, getter = isExpanding) BOOL expanding;
@property (nonatomic, weak) id<SPCircleMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;
@property (nonatomic, assign) CGFloat animationDuration;

- (id)initWithFrame:(CGRect)frame startItem:(SPCircleMenuItem *)startItem optionMenus:(NSArray *)aMenusArray;

@end

@protocol SPCircleMenuDelegate <NSObject>
- (void)SPCircleMenu:(SPCircleMenu *)menu didSelectIndex:(NSInteger)idx;
@optional
- (void)SPCircleMenuDidFinishAnimationClose:(SPCircleMenu *)menu;
- (void)SPCircleMenuDidFinishAnimationOpen:(SPCircleMenu *)menu;


@end
