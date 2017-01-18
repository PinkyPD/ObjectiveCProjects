//
//  WebHelper.h
//  DBDemo
//
//  Created by Kishan Panchotiya on 25/10/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "RequestUtils.h"

typedef void (^OperationDidSuccessfulBlock)(id response);
typedef void (^OperationFaiedBlock)(id error);

@interface WebHelper : NSObject
{
    OperationDidSuccessfulBlock operationDidSuccessfulBlock;
    OperationFaiedBlock operationFaiedBlock;
}

+ (WebHelper *)sharedManager;

-(void)callWebServiceWithType:(NSString*)strURL withPath:(NSString*)strPath WithRequestPara:(NSDictionary*)reqDict OnCompletion:(OperationDidSuccessfulBlock)completeBlock OnError:(OperationFaiedBlock)errorBlock;

-(void)downloadFileWithURL:(NSString*)strURL WithCompletion:(void (^)(BOOL success))completed WithProgress:(void (^)(double progress))progress;

@end

@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end
