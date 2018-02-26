//
//  Distance.h
//  BasicAlgorithm
//
//  Created by sy2036 on 2015-09-21.
//  Copyright (c) 2015 Roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Distance : NSObject

/**
 *  Euclidean Distance
 *
 *  @param fArray  The first vector
 *  @param sArray The second vector
 *
 *  @return Distance.
 */
+ (double)EuclideanDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray;

/**
 *  Also called CityBlock Distance
 *
 *  @param fArray  The first vector
 *  @param sArray The second vector
 *
 *  @return Distance.
 */
+ (double)ManhattanDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray;

/**
 *  Chebyshev Distance
 *
 *  @param fArray  The first vector
 *  @param sArray The second vector
 *
 *  @return Distance.
 */
+ (double)ChebyshevDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray;

/**
 *  Minkowski Distance
 *  Minkowski Distance is not a kind of distance,
 *  it is kinds of distance.
 *
 *  When parameter P is equal to 1, it's Manhattan Distance.
 *  When P is equal to 2, it's Euclidean Distance.
 *  When P is equal to ∞, it's Chebyshev Distance.
 *
 *  @param fArray    The first vector
 *  @param sArray    The second vector
 *  @param parameter The variable parameter
 *
 *  @return Distance.
 */
+ (double)MinkowskiDistanceWithFirstArray:(NSArray *)fArray toSecondArray:(NSArray *)sArray andParameter:(int)parameter;

#pragma Advanced Distance.




@end
