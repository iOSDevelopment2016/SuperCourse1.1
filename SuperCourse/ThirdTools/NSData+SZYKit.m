//
//  NSData+SZYKit.m
//  HttpDemo
//
//  Created by sunxiaoyuan on 16/1/19.
//  Copyright © 2016年 sunzhongyuan. All rights reserved.
//

#import "NSData+SZYKit.h"

@implementation NSData (SZYKit)

-(NSDictionary *)convertHttpResponseToDict{
    
    NSData *data = [[NSData alloc]initWithData:self];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

@end
