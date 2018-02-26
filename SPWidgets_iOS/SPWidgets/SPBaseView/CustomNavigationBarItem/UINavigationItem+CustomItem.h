//
//  UINavigationBar+CustomItem.h
//  AirChinaLoc
//
//  Created by 叶思盼 on 15/4/13.
//  Copyright (c) 2015年 roselife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBarItem.h"

@interface UINavigationItem (CustomItem)

/**
 *  Please check CustomBarItem.h for detail
 *
 */
- (CustomBarItem *)setItemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type;
- (CustomBarItem *)setItemWithImage:(NSString *)imageName size:(CGSize)size itemType:(ItemType)type;
- (CustomBarItem *)setItemWithCustomView:(UIView *)customView itemType:(ItemType)type;


@end
