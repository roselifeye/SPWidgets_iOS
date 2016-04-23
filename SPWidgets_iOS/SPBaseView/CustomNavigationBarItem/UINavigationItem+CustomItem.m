//
//  UINavigationBar+CustomItem.m
//  AirChinaLoc
//
//  Created by 叶思盼 on 15/4/13.
//  Copyright (c) 2015年 roselife. All rights reserved.
//

#import "UINavigationItem+CustomItem.h"

@implementation UINavigationItem (CustomItem)

- (CustomBarItem *)setItemWithTitle:(NSString *)title textColor:(UIColor *)color fontSize:(CGFloat)font itemType:(ItemType)type {
    CustomBarItem *item = [CustomBarItem itemWithTitle:title textColor:color fontSize:font itemType:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}

- (CustomBarItem *)setItemWithImage:(NSString *)imageName size:(CGSize)size itemType:(ItemType)type {
    CustomBarItem *item = [CustomBarItem itemWithImage:imageName size:size type:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}

- (CustomBarItem *)setItemWithCustomView:(UIView *)customView itemType:(ItemType)type {
    CustomBarItem *item = [CustomBarItem itemWithCustomeView:customView type:type];
    [item setItemWithNavigationItem:self itemType:type];
    return item;
}


@end
