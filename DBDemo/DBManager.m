//
//  DBManager.m
//  Mile2Smile_DB_Temp
//
//  Created by Kishan Panchotiya on 24/06/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import "DBManager.h"

//Databse Name
#define DB_NAME @"Demo.db" 

//Table Constants
#define TBL_STEPS_HOURLY @"steps_hourly"
#define TBL_STEPS_HOURLY_TIME_START @"time_start"
#define TBL_STEPS_HOURLY_TIME_END @"time_end"
#define TBL_STEPS_HOURLY_TIME_CURRENT @"time_current"
#define TBL_STEPS_HOURLY_TOTAL_STEPS @"total_steps"
#define TBL_STEPS_HOURLY_DISTANCE @"distance"
#define TBL_STEPS_HOURLY_CALORIES_BURNED @"calories_burned"
#define TBL_STEPS_HOURLY_IS_SYNC @"is_sync"

@interface DBManager()
{
    FMDatabase* db;
}
@end

@implementation DBManager

+ (DBManager *)sharedManager{
    static DBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        [self createCopyOfDatabaseIfNeeded];
        
        NSString* dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DB_NAME];
        db = [FMDatabase databaseWithPath:dbPath];
        if([db open]){
            NSLog(@"Databse file opened with path - %@",dbPath);
        }else{
            NSLog(@"Failed to open Databse at path - %@",dbPath);
        }
    }
    return self;
}

- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *appDBPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:DB_NAME];
    success = [fileManager fileExistsAtPath:appDBPath];
    if (success) {
        return;
    }
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:appDBPath error:&error];
    NSAssert(success, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
}

-(BOOL)insertData:(NSArray*)aryData inTable:(NSString*)strTableName{
    
    if(!aryData || aryData.count == 0){
        return NO;
    }
    
    if([strTableName isEqualToString:TBL_STEPS_HOURLY] && [[aryData firstObject] isKindOfClass:[StepsHourly class]]){
        BOOL valueToReturn = YES;
        for(StepsHourly* stepsHourly in aryData){
            NSString* strQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@, %@, %@) VALUES (%d, %d, %d, %d, %f, %f, %d)", TBL_STEPS_HOURLY,
                                  TBL_STEPS_HOURLY_TIME_START,
                                  TBL_STEPS_HOURLY_TIME_END,
                                  TBL_STEPS_HOURLY_TIME_CURRENT,
                                  TBL_STEPS_HOURLY_TOTAL_STEPS,
                                  TBL_STEPS_HOURLY_DISTANCE,
                                  TBL_STEPS_HOURLY_CALORIES_BURNED,
                                  TBL_STEPS_HOURLY_IS_SYNC,
                                  
                                  (int)stepsHourly.startTime,
                                  (int)stepsHourly.endTime,
                                  (int)stepsHourly.updateTime,
                                  stepsHourly.stepsCounted,
                                  stepsHourly.distanceMeasured,
                                  stepsHourly.caloriesBurned,
                                  stepsHourly.isSync
                                  ];
            
            BOOL success = [db executeUpdate:strQuery];
            if (!success) {
                NSLog(@"error to Written records from Steps Hourly = %@", [db lastErrorMessage]);
                valueToReturn = NO;
            }else{
                NSLog(@"Steps Hourly Written successfully");
            }
        }
        return valueToReturn;
    }
    return NO;
}
-(BOOL)updateData:(NSArray*)aryData inTable:(NSString*)strTableName{
    
    if(!aryData || aryData.count == 0){
        return NO;
    }
    
    if([strTableName isEqualToString:TBL_STEPS_HOURLY] && [[aryData firstObject] isKindOfClass:[StepsHourly class]]){
        BOOL valueToReturn = YES;
        for(StepsHourly* stepsHourly in aryData){
            NSString* strQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %d, %@ = %d, %@ = %f,  %@ = %f, %@ = %d WHERE %@ = %d",TBL_STEPS_HOURLY,
                                  TBL_STEPS_HOURLY_TIME_CURRENT, (int)stepsHourly.updateTime,
                                  TBL_STEPS_HOURLY_TOTAL_STEPS, stepsHourly.stepsCounted,
                                  TBL_STEPS_HOURLY_DISTANCE, stepsHourly.distanceMeasured,
                                  TBL_STEPS_HOURLY_CALORIES_BURNED, stepsHourly.caloriesBurned,
                                  TBL_STEPS_HOURLY_IS_SYNC,stepsHourly.isSync,
                                  TBL_STEPS_HOURLY_TIME_START, (int)stepsHourly.startTime];
            
            BOOL success = [db executeUpdate:strQuery];
            if (!success) {
                NSLog(@"error to Written records from Steps Hourly = %@", [db lastErrorMessage]);
                valueToReturn = NO;
            }else{
                NSLog(@"Steps Hourly Written successfully");
            }
        }
        return valueToReturn;
    }
    return NO;
}
-(BOOL)deleteDataFromTable:(NSString*)strTableName{
    if([strTableName isEqualToString:TBL_STEPS_HOURLY]){
        BOOL isTableDeleted = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",TBL_STEPS_HOURLY]];
        return isTableDeleted;
    }
    return NO;
}
-(NSArray*)getDataFromTable:(NSString*)strTableName{
    if([strTableName isEqualToString:TBL_STEPS_HOURLY]){
        NSMutableArray* aryToRetun = [NSMutableArray new];
        NSString* queryStr = [NSString stringWithFormat:@"SELECT * FROM %@",TBL_STEPS_HOURLY_TIME_START];
        FMResultSet *result = [db executeQuery:queryStr];
        while ([result next]) {
            [aryToRetun addObject:[[StepsHourly alloc] initWithStartTime:[result intForColumn:TBL_STEPS_HOURLY_TIME_START] endTime:[result intForColumn:TBL_STEPS_HOURLY_TIME_END] updateTime:[result intForColumn:TBL_STEPS_HOURLY_TIME_CURRENT] stepsCounted:[result intForColumn:TBL_STEPS_HOURLY_TOTAL_STEPS] distanceMeasured:[result doubleForColumn:TBL_STEPS_HOURLY_DISTANCE] caloriesBurned:[result doubleForColumn:TBL_STEPS_HOURLY_CALORIES_BURNED] isSync:[result intForColumn:TBL_STEPS_HOURLY_IS_SYNC]]];
        }
        [result close];
        return aryToRetun.copy;
    }
    return nil;
}

-(void)dealloc{
    [db close];
}

@end
