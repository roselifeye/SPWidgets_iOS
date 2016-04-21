//
//  BasicMath.h
//  BasicAlgorithm
//
//  Created by sy2036 on 2015-09-21.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicMath : NSObject

/**
 *  Distinguish the lengths of two arrays are equal or not.
 *  If the numbers of the two arrays are same, return Yes,
 *  Otherwise, return No.
 *
 *  @param firstArray  The first array
 *  @param secondArray The second array
 *
 *  @return Yes or No.
 */
+ (BOOL)LengthIsEqualWithFirstArray:(NSArray *)firstArray andSecondArray:(NSArray *)secondArray;

/**
 *  Get the mean of the array.
 *
 *  @param array The array need calculate.
 *
 *  @return The mean of the array.
 */
+ (double)MeanOfArray:(NSArray *)array;

/**
 *  Get the Standard Deviation S of the Array.
 *
 *  @param array The array need calculate.
 *
 *  @return The S of the array.
 */
+ (double)StandardDeviationOfArray:(NSArray *)array;

@end
