//
//  StopWatch.m
//  ScoreRank
//
//  Created by Kai Lenz on 12/11/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StopWatch.h"

@implementation StopWatch

// 初期化
-(id)initStopWatch{
    self = [super init];
    if (self) {
        // 各種時刻を空にしておく
        startTime = nil;
        stopTime = nil;
        theWorld = nil;
    }
    return self;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 開始、停止、クリア
// それぞれ時刻の挿入・クリア
-(void)start{
    startTime = [NSDate date];
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

-(void)stop{
    stopTime = [NSDate date];
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

-(void)clear{
    startTime = nil;
    stopTime = nil;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 停止させたタイマーの再スタート
-(void)restart{
    // 停止時間から現在までの経過時間を取得
    NSTimeInterval stopinterval = [stopTime timeIntervalSinceNow];
    // 開始時間に足す
    [startTime dateByAddingTimeInterval:-stopinterval];
    // 停止時間のクリア
    stopTime = nil;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 開始からの経過秒数
-(double)interval{
    // 開始時刻からの経過秒数を取得
    NSTimeInterval  interval = [startTime timeIntervalSinceNow];
    // 取得時点ではマイナスの値なのでマイナスをつけてdoubleに変換
    double rDouble = -interval;
    
    // 呼び出し個所へリターン
    return rDouble;
}

-(double)result{
    // 開始時刻からの経過秒数を取得
    NSTimeInterval interval = [startTime timeIntervalSinceDate:stopTime];
    // 取得時点ではマイナスの値なのでマイナスをつけてdoubleに変換
    double rDouble = -interval;
    
    // 呼び出し個所へリターン
    return rDouble;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 一時停止・再開
// 停止していた秒数を開始時刻に足す事で停止前後で経過秒数が同じになる
-(BOOL)theWorld{
    // theWorldが空（呼ばれたのが奇数回目、停止状態でない）なら現在時刻を挿入してYESを返す
    if (theWorld == nil) {
        theWorld = [NSDate date];
        return YES;
    // 空でなければ（呼ばれたのが偶数回目、停止状態）停止時刻からの経過秒数を開始時刻に足す
    }else{
        // starPlatinumにtheWorldからの経過秒数を挿入
        NSTimeInterval starPlatinum = [theWorld timeIntervalSinceNow];
        // 所得時点ではマイナスなのでマイナスをつけて開始時刻に足す
        startTime = [startTime dateByAddingTimeInterval:-starPlatinum];
        // 停止時刻を空に。これで次に呼ばれた時再度一時停止になる
        theWorld = nil;
        // BOOlを返すことで呼び出し側が停止状態か否か判断できる
        return NO;
    }
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 経過秒数を指定された桁数分小数点を含む秒数で返す
-(NSString*)formatSecondsWithInterval:(double)interval Place:(int)place{
    // 最大値を気にしないのでとりあえず何か入れとく
    NSString*       rTime = @"returnTime";

    // 指定の桁数に応じて小数点第n位まで含めた文字列に上書き
    if (place == 1) {
        rTime = [NSString stringWithFormat:@"%.1f", interval];
    }else if(place == 2){
        rTime = [NSString stringWithFormat:@"%.2f", interval];
    }else if(place == 3){
        rTime = [NSString stringWithFormat:@"%.3f", interval];
    }else if(place == 4){
        rTime = [NSString stringWithFormat:@"%.4f", interval];
    // 指定は小数第一位から四位でそれ以外は整数で返す
    }else{
        rTime = [NSString stringWithFormat:@"%02d", (int)interval];
    }
    
    // できあがった文字列を呼び出し個所へ返す
    return rTime;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 経過秒数を指定された桁数分小数点を含む分数で返す
-(NSString*)formatMinutesWithInterval:(double)interval Place:(int)place{
    // 最大で一時間以内なので最大値を入れておく
    NSString*       rTime = @"59:59.9999";

    // 秒数から分数を引くために分数を求める
    int    mInterval = floor(interval / 60);
    // 求めた分数×60を引いた値をsIntervalに代入
    double sInterval = interval - (mInterval * 60);

    // 経過秒数が3600（一時間）を超えていなければ指定の桁数に応じてxx:xx.xxxxの形で上書き
    if (interval < 3600) {
        if (place == 1) {
            rTime = [NSString stringWithFormat:@"%02d:%.1f", mInterval, sInterval];
        }else if(place == 2){
            rTime = [NSString stringWithFormat:@"%02d:%.2f", mInterval, sInterval];
        }else if(place == 3){
            rTime = [NSString stringWithFormat:@"%02d:%.3f", mInterval, sInterval];
        }else if(place == 4){
            rTime = [NSString stringWithFormat:@"%02d:%.4f", mInterval, sInterval];
        // 指定は小数第一位から四位でそれ以外は整数で返す
        }else{
            rTime = [NSString stringWithFormat:@"%02d:%02d", mInterval, (int)sInterval];
        }
    }
    
    // できあがった文字列を呼び出し個所へ返す
    return rTime;
}

@end
