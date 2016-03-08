//
//  SZYNoteSolidater.m
//  iNote
//
//  Created by sunxiaoyuan on 15/11/6.
//  Copyright © 2015年 sunzhongyuan. All rights reserved.

#import "SZYNoteSolidater.h"
#import "SCDownlodaMode.h"
#import "FMResultSet.h"


@interface SZYNoteSolidater ()
@property (nonatomic, strong) SZYDataBaseService *dbService;
@end

@implementation SZYNoteSolidater{
    NSString *tableName;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dbService = [SZYDataBaseService getInstance];
        //tableName = NSStringFromClass([SZYNoteModel class]);
    }
    return self;
}

#pragma mark - 数据库方法

//往数据库中写数据的时候，数据都必须时NSObject的子类。基本数据类型需要装箱

-(void)saveOne:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SCDownlodaMode *note = (SCDownlodaMode *)model;
    //构造sql查询语句
    NSString *sql = @"INSERT INTO DOWNLOADINFO (LESSON_ID,LESSON_NAME,LESSON_URL,LESSON_SIZE,LESSON_DOWNLOADING,FINISHED) VALUES (?, ?, ?, ?,?,?)";
    //将nil的属性转换成空字符串
    //[note transferNilPropertiesToNullString];
    NSArray *valueArr = @[note.les_id,note.les_name,note.les_url,note.les_size,note.les_downloading,note.finished];
    [_dbService executeSaveSql:sql insertValues:valueArr successHandler:success failureHandler:failure];
}

-(void)updateDownloading:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SCDownlodaMode *note = (SCDownlodaMode *)model;
    //[note transferNilPropertiesToNullString];
    NSArray *valueArr = @[note.les_downloading,note.les_id];
    NSString * sql = @"update DOWNLOADINFO set LESSON_DOWNLOADING = ? where LESSON_ID = ? ";
    [_dbService executeUpdateSql:sql updateValues:valueArr successHandler:success failureHandler:failure];
}

-(void)updateFinished:(id)model successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    SCDownlodaMode *note = (SCDownlodaMode *)model;
    //[note transferNilPropertiesToNullString];
    NSArray *valueArr = @[note.finished,note.les_id];
    NSString * sql = @"update DOWNLOADINFO set FINISHED = ? where LESSON_ID = ? ";
    [_dbService executeUpdateSql:sql updateValues:valueArr successHandler:success failureHandler:failure];
}

-(void)readByCriteria:(NSString *)criteria queryValue:(id)queryValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM DOWNLOADINFO %@",criteria];
    [_dbService executeReadSql:sql queryValue:queryValue successHandler:^(id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tempArr = [NSMutableArray array];
        while ([rs next]) {
            SCDownlodaMode *tempNote = [[SCDownlodaMode alloc]init];
            tempNote.les_id = [rs stringForColumn:@"LESSON_ID"];
            tempNote.les_name = [rs stringForColumn:@"LESSON_NAME"];
            tempNote.les_url = [rs stringForColumn:@"LESSON_URL"];
            tempNote.les_size = [rs stringForColumn:@"LESSON_SIZE"];
            tempNote.les_downloading = [rs stringForColumn:@"LESSON_DOWNLOADING"];
            tempNote.finished = [rs stringForColumn:@"FINISHED"];
            [tempArr addObject:tempNote];
        }
        //结果回调
        success(tempArr);
    } failureHandler:failure];
}

-(void)readOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE LESSON_ID = ?";
    [self readByCriteria:criteria queryValue:ID successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
        success(noteArr);
    } failureHandler:failure];
}
-(void)readOneByName:(NSString *)name successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE LESSON_NAME = ?";
    [self readByCriteria:criteria queryValue:name successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
        success(noteArr);
    } failureHandler:failure];
}
-(void)readOneByFinished:(NSString *)finished successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE FINISHED = ?";
    [self readByCriteria:criteria queryValue:finished successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
        success(noteArr);
    } failureHandler:failure];
}


-(void)readOneByDownloading:(NSString *)les_downloading successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE LESSON_DOWNLOADING = ?";
    [self readByCriteria:criteria queryValue:les_downloading successHandler:^(id result) {
        NSArray *noteArr = (NSArray *)result;
//        if ([noteArr count] < 1) {
//            success(nil);
//        }else{
//            success([noteArr firstObject]);
//        }
        success(noteArr);
    } failureHandler:failure];
}


-(void)readallBySuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    NSString *str=@"DOWNLOADINFO";
    NSString *sql = @"SELECT * FROM DOWNLOADINFO";
    [_dbService executeReadSql:sql queryValue:str successHandler:^(id result) {
        FMResultSet *rs = (FMResultSet *)result;
        NSMutableArray *tempArr = [NSMutableArray array];
        while ([rs next]) {
            SCDownlodaMode *tempNote = [[SCDownlodaMode alloc]init];
            tempNote.les_id = [rs stringForColumn:@"LESSON_ID"];
            tempNote.les_name = [rs stringForColumn:@"LESSON_NAME"];
            tempNote.les_url = [rs stringForColumn:@"LESSON_URL"];
            tempNote.les_size = [rs stringForColumn:@"LESSON_SIZE"];
            tempNote.les_downloading = [rs stringForColumn:@"LESSON_DOWNLOADING"];
            tempNote.finished = [rs stringForColumn:@"FINISHED"];
            [tempArr addObject:tempNote];
        }
        //结果回调
        success(tempArr);
    } failureHandler:failure];
}


//-(void)readOneByPID:(NSString *)PID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
//    
//    NSString *criteria = @"WHERE noteBook_id_belonged = ?";
//    [self readByCriteria:criteria queryValue:PID successHandler:success failureHandler:failure];
//}
//
//-(void)readAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
//    
//    [self readByCriteria:@"" queryValue:nil successHandler:success failureHandler:failure];
//}

-(void)deleteByCriteria:(NSString *)criteria deleteValue:(id)deleteValue successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM DOWNLOADINFO %@",criteria];
    [_dbService executeDeleteSql:sql deleteValue:deleteValue successHandler:success failureHandler:failure];
}

-(void)deleteOneByID:(NSString *)ID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
    
    NSString *criteria = @"WHERE LESSON_ID = ?";
    [self deleteByCriteria:criteria deleteValue:ID successHandler:success failureHandler:failure];
}

//-(void)deleteOneByPID:(NSString *)PID successHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
//    
//    NSString *criteria = @"WHERE noteBook_id_belonged = ?";
//    [self deleteByCriteria:criteria deleteValue:PID successHandler:success failureHandler:failure];
//}
//
//-(void)deleteAllSuccessHandler:(dbSuccessHandler)success failureHandler:(dbFailureHandler)failure{
//    
//    [self deleteByCriteria:@"" deleteValue:nil successHandler:success failureHandler:failure];
//}

@end
