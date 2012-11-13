//
//  RankView.m
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/07.
//
//

#import "RankView.h"

@implementation RankView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        // Initialization code
        _intRank = [[IntRank alloc] initWithDBName:@"intRank"];
        _timeRank = [[TimeRank alloc] initWithDBName:@"timeRank"];
        [_intRank startRankWithNum:10];
        [_timeRank startRankWithNum:10];
        modeStatus = 0;
        
        // モード選択用ボタンを配列にしてモード１と２でオンオフを逆で入れておく
        // これによって[]内に変数（modeStatus）を入れれば中身によって表示が適切に切り替わる
        imageMode1[0] = [UIImage imageNamed:@"rankMode1on.gif"];
        imageMode1[1] = [UIImage imageNamed:@"rankMode1off.gif"];
        imageMode2[0] = [UIImage imageNamed:@"rankMode2off.gif"];
        imageMode2[1] = [UIImage imageNamed:@"rankMode2on.gif"];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // モード選択用ボタンの表示。[]内にmodeStatusを入れる
    // これによってモードが0ならimageMode1はオン、imageMode2はオフが表示される
    [imageMode1[modeStatus] drawInRect:CGRectMake(10, 10, 120, 30)];
    [imageMode2[modeStatus] drawInRect:CGRectMake(150, 10, 120, 30)];
    int i;
    for (i = 1; i <= 10; i++) {
        Rank = [NSString stringWithFormat:@"%d位",i];
        if (modeStatus == 0) {
            Name = [_timeRank getNameWithRank:i];
            doubleScore = [_timeRank getScoreWithRank:i];
            Score = [NSString stringWithFormat:@"%.2f秒",doubleScore];
        }else{
            Name = [_intRank getNameWithRank:i];
            intScore = [_intRank getScoreWithRank:i];
            Score = [NSString stringWithFormat:@"%d回",intScore];
        }
        
        [Rank drawInRect:CGRectMake(10, 20+i*28, 40, 30)
                 withFont:[UIFont systemFontOfSize:18]
            lineBreakMode:UILineBreakModeClip
                alignment:UITextAlignmentRight
         ];
        [Name drawInRect:CGRectMake(50, 20+i*28, 150, 30)
                withFont:[UIFont systemFontOfSize:18]
           lineBreakMode:UILineBreakModeClip
               alignment:UITextAlignmentCenter
         ];
        [Score drawInRect:CGRectMake(210, 20+i*28, 60, 30)
                withFont:[UIFont systemFontOfSize:18]
           lineBreakMode:UILineBreakModeClip
               alignment:UITextAlignmentRight
         ];
    }
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
        // imageMode1の位置がタッチされた場合modeStatusを0（十連打）に変更
        if (10 < positionX && positionX < 130 && 10 < positionY && positionY < 40) {
            modeStatus = 0;
            
            // imageMode2の位置がタッチされた場合modeStatusを1（十秒間連打）に変更
        }else if(150 < positionX && positionX < 270 && 10 < positionY && positionY < 40){
            modeStatus = 1;
            
            // りりいの位置がタッチされた場合
        }
    [self setNeedsDisplay];

}

@end
