//
//  Distance.m
//  BasicAlgorithm
//
//  Created by sy2036 on 2015-09-21.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//
//  Original Git: https://github.com/roselifeye/SPAlogrithmFramework.git

#import "Distance.h"
#import "BasicMath.h"

@implementation Distance

+ (double)EuclideanDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray {
    double distance = .0f;
    if ([BasicMath LengthIsEqualWithFirstArray:fArray andSecondArray:sArray]) {
        return 0;
    }
    double sumDistance = .0f;
    for (int i = 0; i < [fArray count]; i++) {
        double firstValue = [[fArray objectAtIndex:i] doubleValue];
        double secondValue = [[sArray objectAtIndex:i] doubleValue];
        sumDistance += pow((firstValue - secondValue), 2);
    }
    distance = sqrt(sumDistance);
    
    return distance;
}

+ (double)ManhattanDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray {
    double distance = 0.f;
    if ([BasicMath LengthIsEqualWithFirstArray:fArray andSecondArray:sArray]) {
        return 0;
    }
    for (int i = 0; i < [fArray count]; i++) {
        double firstValue = [[fArray objectAtIndex:i] doubleValue];
        double secondValue = [[sArray objectAtIndex:i] doubleValue];
        distance += fabs(firstValue - secondValue);
    }
    return distance;
}

+ (double)ChebyshevDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray {
    double distance = 0.f;
    if ([BasicMath LengthIsEqualWithFirstArray:fArray andSecondArray:sArray]) {
        return 0;
    }
    for (int i = 0; i < [fArray count]; i++) {
        double firstValue = [[fArray objectAtIndex:i] doubleValue];
        double secondValue = [[sArray objectAtIndex:i] doubleValue];
        distance = fmax(distance, fabs(firstValue - secondValue));
    }
    return distance;
}

+ (double)MinkowskiDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray andParameter:(int)parameter {
    double distance = 0.f;
    if ([BasicMath LengthIsEqualWithFirstArray:fArray andSecondArray:sArray]) {
        return 0;
    }
    double sumDistance = .0f;
    for (int i = 0; i < [fArray count]; i++) {
        double firstValue = [[fArray objectAtIndex:i] doubleValue];
        double secondValue = [[sArray objectAtIndex:i] doubleValue];
        sumDistance += pow(fabs(firstValue - secondValue), parameter);
    }
    
    //  This method is not very efficient, I will update it.
    distance = pow(sumDistance, (double)(1.0/parameter));
    return distance;
}

@end
