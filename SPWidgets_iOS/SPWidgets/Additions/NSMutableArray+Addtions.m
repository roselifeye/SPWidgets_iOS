//
//  NSMutableArray+Addtions.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-06-11.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "NSMutableArray+Addtions.h"

@implementation NSMutableArray (Addtions)

- (void)moveObjectFromIndex:(NSUInteger)fromObj toIndex:(NSUInteger)toObj {
    if (toObj != fromObj) {
        id obj = [self objectAtIndex:fromObj];
        
        [self removeObjectAtIndex:fromObj];
        if (toObj >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:toObj];
        }
    }
}

@end
