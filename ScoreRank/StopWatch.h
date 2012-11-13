//
//  StopWatch.h
//  ScoreRank
//
//  Created by Kai Lenz on 12/11/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopWatch : NSObject{
    // カウント開始時刻
    NSDate*     startTime;
    // カウント終了時刻
    NSDate*     stopTime;
    // 一時停止開始時刻
    NSDate*     theWorld;
}

// 初期化
-(id)initStopWatch;
// 開始、停止、消去、再開
-(void)start;
-(void)stop;
-(void)clear;
-(void)restart;
// 開始からの経過秒数（ストップ前、ストップ後）
-(double)interval;
-(double)result;
// 一時停止・再開
-(BOOL)theWorld;
// 結果を指定された桁数分小数点を含む秒数で返す
-(NSString*)formatSecondsWithInterval:(double)interval Place:(int)place;
// 結果を指定された桁数分小数点を含む分数で返す
-(NSString*)formatMinutesWithInterval:(double)interval Place:(int)place;

@end
