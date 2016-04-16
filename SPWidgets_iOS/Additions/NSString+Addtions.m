//
//  NSString+Addtions.m
//
//  Created by Roselifeye on 14-5-6.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "NSString+Addtions.h"

static NSString *UUID = nil;

@implementation NSString (Addtions)

+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    return documentDir;
}

+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //return [NSString getBuildVersion];
}

+ (NSString *)getBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSString * regex = @"^[0-9]{11,11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

@end
