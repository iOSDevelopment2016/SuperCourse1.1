//
//  SZYDataBaseService.m
//  iNote
//
//  Created by 孙中原 on 15/10/9.
//  Copyright (c) 2015年 sunzhongyuan. All rights reserved.
/**
 * 1.SQLite是一款轻型的数据库,它的设计目标是嵌入式的，当前很多嵌入式操作系统都将其作为数据库首选。
     其数据文件就存储在一个单一的磁盘文件上。
 * 2.SQLite现在主流的版本是SQLite3，使用C语言开发，完全开源
 * 3.SQLite是动态数据类型（实际上是一种无类型的概念）的数据库。字段可以不指定数据类型，因为创建时定义了一种类型，在实际操作时也可以存储其他类型。但是从编程规范的角度上讲，通常还是需要在建表的时候为字段指
     定数据类型，便于阅读和理解
 * 4.FMDatabase是OC风格的封装，对开发者更加友好
 * 5.对数据库的访问可能是随机的（在任何时候）、不同线程间（不同的网络回调等）的请求。使用FMDatabaseQueue，可以用block接受SQL语句，这样所有的数据库操作会在一个串行队列中按照被接受的顺序执行，数据库的资源就不会被争抢
 */

#import "SZYDataBaseService.h"
#import "SCDownlodaMode.h"


@implementation SZYDataBaseService

static SZYDataBaseService* instance = nil;

+(SZYDataBaseService *)getInstance{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[SZYDataBaseService alloc]init];
    });
    return instance;
}

-(id)init{
    if (self = [super init]) {
        //实例化数据库
        //这里接受的数据库地址如果是“”或者nil，会在临时目录创建一个空的数据库，当数据库关闭后会自动删除
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myDatabase.sqlite3"];
        _fmDataBase = [[FMDatabase alloc]initWithPath:path];
        [self setUpDataBase];
    }
    return self;
}

-(void)setUpDataBase{
    //打开数据库需要判断，因为有时如果资源不足或者权限不够，可能打开失败。如果数据库没有打开，再执行SQL语句就有可能报"out of memory"的错误
    //如果更严谨的话，应该在每次操作数据库的时候调用goodConnection方法，查看数据库的打开和连接情况
    if ([self.fmDataBase open]){
        //创建数据表
        [self createTables];
        //关闭数据库
        //一般情况下，建立连接后通常不需要关闭连接（尽管可以手动关闭）
        //[self.fmDataBase close];
    }else{
        NSLog(@"error = %@",[self.fmDataBase lastErrorMessage]);
    }
}

-(void)createTables{
    //这里我们数据表的名字就是数据模型的类名
//    NSString *noteTableName = NSStringFromClass([SCDownlodaMode class]);
    NSString *sql =  @"CREATE TABLE IF NOT EXISTS DOWNLOADINFO  (LESSON_ID varchar PRIMARY KEY ,  LESSON_NAME varchar , LESSON_URL varchar, LESSON_SIZE varchar, LESSON_DOWNLOADING varchar, FINISHED varchar)";
    if (![self.fmDataBase executeUpdate:sql]) {
        NSLog(@"error = %@",[self.fmDataBase lastErrorMessage]);
    }
}

#pragma mark - 数据库操作

-(void)executeSaveSql:(NSString *)sql insertValues:(NSArray *)insertValues  successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{

    BOOL isSuccess = [self.fmDataBase executeUpdate:sql withArgumentsInArray:insertValues];
    if (isSuccess) {
        success(nil);
    }else{
        failure([self.fmDataBase lastErrorMessage]);
    }
}

-(void)executeUpdateSql:(NSString *)sql updateValues:(NSArray *)updateValues successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    BOOL isSuccess = [self.fmDataBase executeUpdate:sql withArgumentsInArray:updateValues];
    if (isSuccess) {
        success(nil);
    }else{
        failure([self.fmDataBase lastErrorMessage]);
    }
}

-(void)executeReadSql:(NSString *)sql queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    FMResultSet *rs;
    if (queryValue) {
        rs = [self.fmDataBase executeQuery:sql,queryValue];
    }else{
        rs = [self.fmDataBase executeQuery:sql];
    }
    if ([self.fmDataBase hadError]) {
        failure([self.fmDataBase lastErrorMessage]);
    }else{
        success(rs);
    }
}

-(void)executeDeleteSql:(NSString *)sql deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    BOOL isSuccess;
    if (!deleteValue) {
       isSuccess = [self.fmDataBase executeUpdate:sql];
    }else{
       isSuccess = [self.fmDataBase executeUpdate:sql,deleteValue];
    }
    if (isSuccess) {
        success(nil);
    }else{
        failure([self.fmDataBase lastErrorMessage]);
    }
}

@end
