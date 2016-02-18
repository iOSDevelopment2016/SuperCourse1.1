//
//  SZYVideoManager.h
//  MoviePlayer
//
//  Created by Develop on 16/1/25.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define VideoLoadDoneNotification @"VideoLoadDoneNotification"

typedef void (^playProgressHandler)(NSTimeInterval elapsedTime, NSTimeInterval timeRemaining,NSTimeInterval playableDuration, BOOL finished);

@interface SZYVideoManager : NSObject

//+(instancetype)defaultManager;

//加载网络视频
-(void)setUpRemoteVideoPlayerWithContentURL:(NSURL *)contentURL view:(UIView *)view;
//开始播放
-(void)startWithHandler:(playProgressHandler)handler;
//暂停
-(void)pause;
//恢复
-(void)resume;
//结束播放，充值播放器，只有在确定抛弃当前视频的时候才能调用
-(void)stop;
//调节进度
-(void)moveToSecond:(NSTimeInterval)second;
//获取当前正在播放的进度
-(CGFloat)currentTime;
//设置播放速率
-(void)setCurrentRate:(float)rate;
//获取当前播放速率
-(float)currentRate;
//以当前速率向前
-(void)beginSeekingForward;
//以当前速率向后
-(void)beginSeekingBackward;
//结束追溯
-(void)endSeeking;

@end


@interface NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end

@interface NSTimer (Control)

-(void)pauseTimer;
-(void)resumeTimer;

@end


