//
//  WebHelper.m
//  DBDemo
//
//  Created by Kishan Panchotiya on 25/10/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import "WebHelper.h"

@implementation WebHelper

+ (WebHelper *)sharedManager{
    static WebHelper *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (id)getDataAtPath:(NSString *)path fromResultObject:(NSDictionary *)resultObject{
    id dataObject	= resultObject;
    NSArray *pathArray	= [path componentsSeparatedByString:@"."];
    for (NSString *step in pathArray) {
        if ([dataObject isKindOfClass:[NSDictionary class]])
            dataObject = [dataObject objectForKey:step];
        else
            return nil;
    }
    return dataObject;
}

-(void)callWebServiceWithType:(NSString*)strURL withPath:(NSString*)strPath WithRequestPara:(NSDictionary*)reqDict OnCompletion:(OperationDidSuccessfulBlock)completeBlock OnError:(OperationFaiedBlock)errorBlock
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSURL *url;
    NSMutableURLRequest *request;

    // Get
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strURL]];
        request = [NSMutableURLRequest GETRequestWithURL:url parameters:reqDict];
        
  
    //Post
        
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strURL]];
//        request = [NSMutableURLRequest POSTRequestWithURL:url parameters:nil];
//        NSData *requestData = [[reqDict bv_jsonStringWithPrettyPrint:NO] dataUsingEncoding:NSUTF8StringEncoding];
//        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPBody: requestData];
    
   
    [request setTimeoutInterval:1000.0];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error:%@",[error description]);
            errorBlock(error);
   
                }
        else {
            
            //            NSLog(@"Response Came: >>>%@",[responseObject description]);
            
            if([responseObject isKindOfClass:[NSDictionary class]]){
                id response;
                if(strPath != nil && ![strPath isEqualToString:@""]){
                    response = [WebHelper getDataAtPath:strPath fromResultObject:responseObject];
                }else{
                    response = responseObject;
                }
                
                if([response isKindOfClass:[NSArray class]]){
                    NSArray* responseArray = (NSArray*)response;
                    completeBlock(responseArray);
                    
                }
                else if([response isKindOfClass:[NSDictionary class]]){
                    NSDictionary* responseDict = (NSDictionary*)response;
                    responseDict = [self dictionaryByReplacingNullsWithStringsWithInputDict:responseDict];
                    completeBlock(responseDict);
                }
                else if([response isKindOfClass:[NSString class]]){
                    NSString* responseStr = (NSString*)response;
                    completeBlock(responseStr);
                }
            }
            else if([responseObject isKindOfClass:[NSArray class]]){
                id response;
                response = responseObject;
                NSArray* responseArray = (NSArray*)response;
                completeBlock(responseArray);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
    }];
    [dataTask resume];
    
}

-(void)downloadFileWithURL:(NSString*)strURL WithCompletion:(void (^)(BOOL success))completed WithProgress:(void (^)(double progress))progress{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.fractionCompleted);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if(!error){
            completed(YES);
        }else{
            completed(NO);
        }
    }];
    [downloadTask resume];
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Method for nil values to be replaced with blank values
- (NSDictionary *)dictionaryByReplacingNullsWithStringsWithInputDict:(NSDictionary*)dictInput {
    const NSMutableDictionary *replaced = [dictInput mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in dictInput) {
        const id object = [dictInput objectForKey:key];
        if(object == nul) {
            [replaced setObject:blank
                         forKey:key];
        }
    }
    return [replaced copy];
}

@end

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}



@end


