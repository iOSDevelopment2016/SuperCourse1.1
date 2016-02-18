//
//  SZYVideoManager.m
//  MoviePlayer
//
//  Created by Develop on 16/1/25.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "SZYVideoManager.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>

#define kTimerUpdateFrequency 0.1

#pragma clang diagnostic ignored "-Wdeprecated-declarations"


@interface SZYVideoManager ()

@property (nonatomic ,strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSTimer                 *playTimer;

@end

@implementation SZYVideoManager{
    BOOL isLoadDone;
}

+(instancetype)defaultManager{
    
    static SZYVideoManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[SZYVideoManager alloc]init];
    });
    return manager;
}

-(void)setUpRemoteVideoPlayerWithContentURL:(NSURL *)contentURL view:(UIView *)view
{
    _player = [[MPMoviePlayerController alloc]initWithContentURL:contentURL];
    isLoadDone = NO;
    // 去除系统自带的控件
    _player.controlStyle = MPMovieControlStyleNone;
    _player.scalingMode = MPMovieScalingModeAspectFill;
    // 视屏开始播放的时候，这个view开始响应用户的操作，把它关闭
    _player.view.userInteractionEnabled = NO;
    [_player.view setFrame:view.bounds]; // player's frame must match parent's
    [view addSubview:_player.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDurationAvailable) name:
     MPMovieDurationAvailableNotification object:nil];
}

//已经加载好，准备播放
-(void)movieDurationAvailable{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VideoLoadDoneNotification object:@(_player.duration)];
}

-(void)startWithHandler:(playProgressHandler)handler
{
    [_player prepareToPlay];
    [_player play];
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerUpdateFrequency block:^{
        if (_player.currentPlaybackTime != _player.duration) {
            NSTimeInterval timeRemaining = _player.duration - _player.currentPlaybackTime;
            handler(_player.currentPlaybackTime,timeRemaining,_player.playableDuration,NO);
        }
        else{
            NSTimeInterval timeRemaining = _player.duration - _player.currentPlaybackTime;
            handler(_player.currentPlaybackTime,timeRemaining,_player.playableDuration,YES);
        }
    } repeats:YES];
}

-(void)pause{
    [_player pause];
}

-(void)resume{
    [_player play];
}

-(void)stop{
    //注销通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMovieDurationAvailableNotification object:nil];
    [_player stop];
    [_playTimer invalidate];
    _playTimer = nil;
}

-(void)moveToSecond:(NSTimeInterval)second
{
    _player.currentPlaybackTime = second;
}

@end


@implementation NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(executeBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)executeBlock:(NSTimer *)inTimer {
    
    if ([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end

@implementation NSTimer (Control)

//暂停时间
static NSString * const pauseDate = @"NSTimerPauseDate";
//启动时间
static NSString * const previousFireDate = @"NSTimerPreviousFireDate";

-(void)pauseTimer {
    
    //setters
    //将函数执行时的时间绑定给实例变量－pauseDate
    objc_setAssociatedObject(self, (__bridge const void *)(pauseDate), [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //将启动时间绑定给实例变量－previousFireDate
    objc_setAssociatedObject(self, (__bridge const void *)(previousFireDate), self.fireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //暂停计时器
    self.fireDate = [NSDate distantFuture];
}

-(void)resumeTimer {
    //getters
    NSDate *pauseDateTime = objc_getAssociatedObject(self, (__bridge const void *)pauseDate);
    NSDate *previousFireDateTime = objc_getAssociatedObject(self, (__bridge const void *)previousFireDate);
    //上次暂停时距今的时间间隔
    const NSTimeInterval pauseTime = -[pauseDateTime timeIntervalSinceNow];
    //启动定时器
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:previousFireDateTime];
}

@end
