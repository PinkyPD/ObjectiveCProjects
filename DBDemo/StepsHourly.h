//
//  StepsHourly.h
//  Mile2Smile_DB_Temp
//
//  Created by Kishan Panchotiya on 27/06/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepsHourly : NSObject

@property NSTimeInterval startTime;
@property NSTimeInterval endTime;
@property NSTimeInterval updateTime;
@property int stepsCounted;
@property float distanceMeasured;
@property float caloriesBurned;

@property int isSync; // 0 or 1

-(id)initWithStartTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime updateTime:(NSTimeInterval)updateTime stepsCounted:(int)stepsCounted distanceMeasured:(float)distanceMeasured caloriesBurned:(float)caloriesBurned isSync:(int)isSync;

@end
