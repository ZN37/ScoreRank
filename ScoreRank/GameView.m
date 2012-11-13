//
//  GameView.m
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/05.
//
//

#import "GameView.h"

@implementation GameView

// 初期化処理
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色を布模様に
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

        // 整数値スコアランクを作成し開始しておく
        _intRank = [[IntRank alloc] initWithDBName:@"intRank"];
        // タイムスコアランクを作成し開始しておく
        _timeRank = [[TimeRank alloc] initWithDBName:@"timeRank"];

        // 引数に10を指定してベストテンの整数値ランキングを開始
        [_intRank startRankWithNum:10];
        // 引数に10を指定してベストテンのタイムランキングを開始
        [_timeRank startRankWithNum:10];

        // ストップウォッチを作成
        _stopWatch = [[StopWatch alloc] initStopWatch];

        // 各変数を初期値にしておく
        // ゲームモード。0は十連打、1は十秒間連打
        modeStatus = 0;
        // プレイ状況。0は開始前、1はゲーム中、2はゲーム終了
        playStatus = 0;
        // タッチ状況。0はタッチなし、1はタッチ中
        touchStatus = 0;

        // りりいをタッチされた回数
        touchCount = 0;

        // モード選択用ボタンを配列にしてモード１と２でオンオフを逆で入れておく
        // これによって[]内に変数（modeStatus）を入れれば中身によって表示が適切に切り替わる
        imageMode1[0] = [UIImage imageNamed:@"gameMode1on.gif"];
        imageMode1[1] = [UIImage imageNamed:@"gameMode1off.gif"];
        imageMode2[0] = [UIImage imageNamed:@"gameMode2off.gif"];
        imageMode2[1] = [UIImage imageNamed:@"gameMode2on.gif"];

        // リトライ用ボタン、りりい達の画像指定
        imageRetry = [UIImage imageNamed:@"retry.gif"];
        imageLily = [UIImage imageNamed:@"Lily.png"];
        imageLilyAngry = [UIImage imageNamed:@"LilyAngry.png"];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 開始前及びゲーム中は同じものを表示するのでifの条件を「2未満」に設定
    if (playStatus < 2) {
        // モード選択用ボタンの表示。[]内にmodeStatusを入れる
        // これによってモードが0ならimageMode1はオン、imageMode2はオフが表示される
        [imageMode1[modeStatus] drawInRect:CGRectMake(10, 10, 120, 30)];
        [imageMode2[modeStatus] drawInRect:CGRectMake(150, 10, 120, 30)];

        // タッチ状況によって表示するりりいを変更
        // 0の場合（タッチされていない時）は通常、1の場合（タッチされている時）は怒りのりりい
        if(touchStatus == 0) {
            [imageLily drawInRect:CGRectMake(10, 100, 260, 260)];
        }else{
            [imageLilyAngry drawInRect:CGRectMake(10, 100, 260, 260)];
        }
    }
    // ゲーム終了時に表示する内容
    if (playStatus == 2) {
        // ゲームモードが0（十連打）の場合のスコア内容処理
        if (modeStatus == 0) {
            // ストップウォッチクラスのresultメソッドを使って結果時間を取得
            timeScore = [_stopWatch result];
            // フォーマットメソッドに取得した結果時間と小数点以下の桁数を送りx.xxの形で取得
            formatedScore = [_stopWatch formatSecondsWithInterval:timeScore Place:2];
            // スコア表示用文字列に〜〜秒の形で挿入
            Score = [NSString stringWithFormat:@"%@秒", formatedScore];
            // 取得した時間をもとにタイムランキングの暫定順位を確認
            tempRank = [_timeRank checkRankWithScore:timeScore];

        // ゲームモードが1（十秒間連打）の場合のスコア内容処理
        }else{
            // スコア表示用文字列に〜〜回の形でタッチ回数を挿入
            Score = [NSString stringWithFormat:@"%d回", touchCount];
            // タッチ回数をもとに整数値ランキングの暫定順位を確認
            tempRank = [_intRank checkRankWithScore:touchCount];
        }
        // ランク表示用文字列に第〜位の形で暫定ランクを挿入
        Rank = [NSString stringWithFormat:@"第%d位",tempRank];
        
        // モード選択ボタンのあった位置にそれぞれ表示
        // 今回のスコアの表示
        [Score drawInRect:CGRectMake(10, 10, 120, 30)   // 表示領域
                  withFont:[UIFont systemFontOfSize:25]     // フォントサイズ
             lineBreakMode:UILineBreakModeClip              // 段落設定
                 alignment:UITextAlignmentCenter            // 中央寄せ表示
         ];
        // このスコアの暫定順位を表示（設定は位置以外スコアと同じ）
        [Rank drawInRect:CGRectMake(150, 10, 120, 30)
                  withFont:[UIFont systemFontOfSize:25]
             lineBreakMode:UILineBreakModeClip
                 alignment:UITextAlignmentCenter
         ];
        
        // リトライボタンの表示
        [imageRetry drawInRect:CGRectMake(150, 55, 120, 30)];
        // 怒ったりりいの表示
        [imageLilyAngry drawInRect:CGRectMake(10, 100, 260, 260)];
    }
}

// テキストフィールドの決定ボタンが押された時（つまりゲーム終了後のランク登録時）に呼ばれる
// このメソッドを使うには.hの冒頭で<UITextFieldDelegate>を追加
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 入力された名前の取得
    playerName = inputName.text;

    // モードが0（十連打）ならタイムランクに今回のスコアをインサート
    if (modeStatus ==0) {
        [_timeRank insertWithName:playerName Score:timeScore];

    // モードが1（十秒間連打）なら整数値ランクに今回のスコアをインサート
    }else{
        [_intRank insertWithName:playerName Score:touchCount];
    }
    // キーボードをしまう
    [textField resignFirstResponder];
    // テキストフィールドを無効にする
    // これによって登録は一度きりになる
    inputName.enabled = NO;

    // このメソッドは最後にYESを返す必要があるので返す
    return YES;
}

// ビューがタッチされた時の処理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // タッチされた位置の取得
    for(UITouch* touch in touches){
        // タッチされた位置をptに保存
        CGPoint pt = [touch locationInView:self];
        
        // タッチされた位置のX座標をpositionX、Y座標をpositionYに保存
        positionX = pt.x;
        positionY = pt.y;
    }
    
    // プレイ状況に応じてタッチ時の挙動を変える
    // playStatusが0（ゲーム開始前）の場合の挙動
    if (playStatus == 0) {
        // imageMode1の位置がタッチされた場合modeStatusを0（十連打）に変更
        if (10 < positionX && positionX < 130 && 10 < positionY && positionY < 40) {
            modeStatus = 0;

        // imageMode2の位置がタッチされた場合modeStatusを1（十秒間連打）に変更
        }else if(150 < positionX && positionX < 270 && 10 < positionY && positionY < 40){
            modeStatus = 1;

        // りりいの位置がタッチされた場合
        }else if (10 < positionX && positionX < 270 && 100 < positionY && positionY < 360) {
            // タッチ状況（りりいの表示変更用変数）を1（怒ったりりい）にする
            touchStatus = 1;
            
            // タッチされた回数を1にする
            touchCount = 1;
            
            // プレイ状況を1（ゲーム中）にする
            playStatus = 1;
            
            // ストップウォッチの時間計測開始
            [_stopWatch start];
        }

    // checkPlayが1（ゲーム中）の場合の挙動
    }else if(playStatus == 1){
        // りりいの位置がタッチされた場合のみ処理
        if (10 < positionX && positionX < 270 && 100 < positionY && positionY < 360) {
            // モードが0（十連打）でタッチ回数が10未満の場合（ゲーム終了ではない時）
            if (modeStatus == 0 && touchCount < 10) {
                // タッチ回数を1つ増やす
                touchCount = touchCount + 1;
                // タッチ状況を1（タッチされている）に変更
                touchStatus = 1;

            // モードが1（十秒間連打）でストップウォッチ開始からの経過秒数が10未満の場合（ゲーム終了ではない時）
            }else if(modeStatus == 1 && [_stopWatch interval] < 10){
                // タッチ回数を1つ増やす
                touchCount = touchCount + 1;
                // タッチ状況を1（タッチされている）に変更
                touchStatus = 1;

            // 上のどちらでもない場合（ゲーム終了の時）
            }else{
                // プレイ状況を2（ゲーム終了）に
                playStatus = 2;
                // ストップウォッチを止めて経過秒数を確定させる
                [_stopWatch stop];
                
                // ゲーム終了時に名前を入力するためのテキストフィールドを位置指定して生成
                inputName = [[UITextField alloc]initWithFrame:CGRectMake(10, 55, 120, 30)];
                // 背景色を白に設定
                inputName.backgroundColor = [UIColor whiteColor];
                // フィールドの境界部分を丸角に設定
                inputName.borderStyle = UITextBorderStyleRoundedRect;
                // 未入力時に登録と出るように設定
                inputName.placeholder = @"登録";
                // タッチされた時に呼び出すキーボードタイプを設定（決定ボタンがDoneになっているもの）
                inputName.returnKeyType = UIReturnKeyDone;
                // 決定ボタンが押された時に呼び出す対象を自分（GameView）に設定
                inputName.delegate = self;
                // テキストフィールドをビューに貼付け
                [self addSubview:inputName];
            }
        }

    //  playStatusが2（ゲーム終了）の場合の挙動
    }else{
        // リトライボタンの位置がタッチされた場合のみ処理
        if (150 < positionX && positionX < 270 && 55 < positionY && positionY < 85) {
            // 各種値を0に戻す
            modeStatus = 0;
            playStatus = 0;
            touchCount = 0;
            // ストップウォッチの時刻をクリア
            [_stopWatch clear];
            // キーボードをしまう
            [inputName resignFirstResponder];
            // テキストフィールドをはがす
            [inputName removeFromSuperview];
        }
    }
    // 画面を再描画する
    [self setNeedsDisplay];
}

// ビューへのタッチが離された時
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // タッチ状況を0（タッチされていない）に変更
    touchStatus = 0;
    // 画面を再描画
    [self setNeedsDisplay];
}

@end
