//
//  RankView.h
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/07.
//
//

#import <UIKit/UIKit.h>

// 整数値ランククラスのインポート
#import "IntRank.h"

// タイムランククラスのインポート
#import "TimeRank.h"

// ストップウォッチクラスのインポート
#import "StopWatch.h"

@interface RankView : UIView{
    
    // 整数値スコアランククラス
    IntRank*        _intRank;
    
    // タイムスコアランククラス
    TimeRank*       _timeRank;
    
    // ストップウォッチクラス
    StopWatch*      _stopWatch;

    // モード状況の判定用
    int             modeStatus;
    
    // モード選択用ボタン二つずつ（オン/オフ）
    UIImage*        imageMode1[2];
    UIImage*        imageMode2[2];
    
    // 整数値一時保存用変数
    int             intScore;
    
    // 小数値一時保存用変数
    double          doubleScore;
    
    // ランキング表示用文字列
    NSString*       Rank;
    NSString*       Score;
    NSString*       Name;

    // タッチ位置の判定用
    int             positionX;
    int             positionY;
}

@end
