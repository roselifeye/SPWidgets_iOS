//
//  BasicMath.m
//  BasicAlgorithm
//
//  Created by sy2036 on 2015-09-21.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//
//  Original Git: https://github.com/roselifeye/SPAlogrithmFramework.git

#import "BasicMath.h"

@implementation BasicMath

+ (BOOL)LengthIsEqualWithFirstArray:(NSArray *)firstArray andSecondArray:(NSArray *)secondArray {
    BOOL isEqual = NO;
    if ([firstArray count] == [secondArray count]) {
        isEqual = YES;
    } else {
        NSLog(@"The Length of the Two Array is not the same, Please Check.");
    }
    return isEqual;
}

+ (double)MeanOfArray:(NSArray *)array {
    /*
    double sum = .0f;
    for(id number in array) {
        sum += [number doubleValue];
    }
    return (sum / [array count]);
     */
    double average = 0.f;
    average = [[array valueForKeyPath:@"@avg.doubleValue"] doubleValue];
    return average;
}

+ (double)StandardDeviationOfArray:(NSArray *)array {
    double mean = [BasicMath MeanOfArray:array];
    double sumOfSquaredDifferences = .0f;
    for(id number in array) {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += pow(difference, 2);
    }
    return sqrt(sumOfSquaredDifferences / [array count]);
}

@end
