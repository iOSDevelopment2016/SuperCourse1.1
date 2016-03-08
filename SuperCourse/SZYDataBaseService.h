//
//  SZYDataBaseService.h
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

typedef void (^dbSuccessHandler)(id result);
typedef void (^dbFailureHandler)(NSString *errorMsg);

@interface SZYDataBaseService : NSObject

@property (nonatomic, strong) FMDatabase *fmDataBase;

+(SZYDataBaseService*) getInstance;

-(void)executeSaveSql:(NSString *)sql insertValues:(NSArray *)insertValues  successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)executeReadSql:(NSString *)sql queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)executeUpdateSql:(NSString *)sql updateValues:(NSArray *)updateValues successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)executeDeleteSql:(NSString *)sql deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

@end
