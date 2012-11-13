//
//  GameView.h
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/05.
//
//

#import <UIKit/UIKit.h>

// 整数値ランククラスのインポート
#import "IntRank.h"

// タイムランククラスのインポート
#import "TimeRank.h"

// ストップウォッチクラスのインポート
#import "StopWatch.h"

// テキストフィールドの機能を使うために<UITextF〜>と追記↓
@interface GameView : UIView<UITextFieldDelegate>{
    
    // 整数値スコアランククラス
    IntRank*        _intRank;
    
    // タイムスコアランククラス
    TimeRank*       _timeRank;

    // ストップウォッチクラス
    StopWatch*      _stopWatch;
    
    // ゲームモードの判定用
    int             modeStatus;
    // プレイ状況の判定用
    int             playStatus;
    // タッチ状況の判定用
    int             touchStatus;
    
    // タッチ回数のカウント用
    int             touchCount;
    
    // モード選択用ボタン二つずつ（オン/オフ）
    UIImage*        imageMode1[2];
    UIImage*        imageMode2[2];
    // リトライ用ボタン
    UIImage*        imageRetry;
    
    // りりい
    UIImage*        imageLily;
    // 怒りのりりい
    UIImage*        imageLilyAngry;
    
    // スコア取得用
    double          timeScore;
    // スコア形式変更用
    NSString*       formatedScore;
    // スコア表示用
    NSString*       Score;
    // 暫定ランク取得用
    int             tempRank;
    // ランク表示用
    NSString*       Rank;
    
    // 名前入力用テキストフィールド
    UITextField*    inputName;
    // 名前保存用
    NSString*       playerName;
    
    // タッチ位置の判定用
    int             positionX;
    int             positionY;
}

@end
