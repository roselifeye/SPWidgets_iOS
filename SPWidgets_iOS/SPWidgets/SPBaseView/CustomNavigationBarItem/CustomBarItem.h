//
//  CustomBarItem.h
//  AirChinaLoc
//
//  Created by 叶思盼 on 15/4/13.
//  Copyright (c) 2015年 roselife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 The Position of Bar Item.
 */
typedef enum {
    left,
    center,
    right
} ItemType;

@interface CustomBarItem : NSObject

@property (nonatomic, strong) UIBarButtonItem *fixBarItem;
@property (nonatomic, strong) UIButton *contentBarItem;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) ItemType itemType;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) BOOL isCustomView;

/**
 *  Create Title NavigationBarItem by parameters.
 *
 *  @param title Bar Title
 *  @param color Title Color
 *  @param font  Title Fond
 *  @param type  Please see the ItemType
 *
 *  @return Bar Item.
 */
+ (CustomBarItem *)itemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type;

/**
 *  Create Image NavigationBarItem by parameters.
 *
 *  @param imageName Image Name
 *  @param size      Size of the Bar Item
 *  @param type      Please see the ItemType
 *
 *  @return Bar Item.
 */
+ (CustomBarItem *)itemWithImage:(NSString *)imageName size:(CGSize)size type:(ItemType)type;

/**
 *  Create Custom View NavigationBarItem by parameters.
 *
 *  @param customView Customize View
 *  @param type       Please see the ItemType
 *
 *  @return Bar Item.
 */
+ (CustomBarItem *)itemWithCustomeView:(UIView *)customView type:(ItemType)type;
- (void)setItemWithNavigationItem:(UINavigationItem *)navigationItem itemType:(ItemType)type;
- (void)addTarget:(id)target selector:(SEL)selector event:(UIControlEvents)event;

/**
 * Setting Offset for item
 * @param offSet
 */
- (void)setOffset:(CGFloat)offSet;

@end
