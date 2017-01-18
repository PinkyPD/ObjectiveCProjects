//
//  DBManager.h
//  Mile2Smile_DB_Temp
//
//  Created by Kishan Panchotiya on 24/06/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "StepsHourly.h"

//typedef NS_ENUM(NSInteger, DBTable) {
//    DBTableStepsHourly,
//};

@interface DBManager : NSObject

+ (DBManager *)sharedManager;

-(BOOL)insertData:(NSArray*)aryData inTable:(NSString*)strTableName;
-(BOOL)updateData:(NSArray*)aryData inTable:(NSString*)strTableName;
-(BOOL)deleteDataFromTable:(NSString*)strTableName;
-(NSArray*)getDataFromTable:(NSString*)strTableName;

@end
