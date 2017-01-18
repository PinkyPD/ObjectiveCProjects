//
//  StepsHourly.m
//  Mile2Smile_DB_Temp
//
//  Created by Kishan Panchotiya on 27/06/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import "StepsHourly.h"

@implementation StepsHourly

-(id)initWithStartTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime updateTime:(NSTimeInterval)updateTime stepsCounted:(int)stepsCounted distanceMeasured:(float)distanceMeasured caloriesBurned:(float)caloriesBurned isSync:(int)isSync{
    
    if (self = [super init]) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.updateTime = updateTime;
        self.stepsCounted = stepsCounted;
        self.distanceMeasured = distanceMeasured;
        self.caloriesBurned = caloriesBurned;
        self.isSync = isSync;
    }
    return(self);
}

@end
