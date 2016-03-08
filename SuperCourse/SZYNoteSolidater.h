//
//  SZYNoteSolidater.h
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZYDataBaseService.h"

@interface SZYNoteSolidater : NSObject

//插入
-(void)saveOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

//更新
-(void)updateDownloading:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;
-(void)updateFinished:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;
//查询
-(void)readallBySuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)readByCriteria:(NSString *)criteria queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)readOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)readOneByName:(NSString *)name successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)readOneByFinished:(NSString *)finished successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)readOneByDownloading:(NSString *)les_downloading successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;
//-(void)readOneByPID:(NSString *)PID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;
//
//-(void)readAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

//删除
-(void)deleteByCriteria:(NSString *)criteria deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

-(void)deleteOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

//-(void)deleteOneByPID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;
//
//-(void)deleteAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure;

@end
