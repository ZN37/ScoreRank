//
//  TimeRank.h
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/07.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface TimeRank : NSObject{
    // データベース名（インスタンスごとに独立なので複数データベースを作成することも可能）
    NSString*   DBName;
}
// 名前をつけて初期化
-(id)initWithDBName:(NSString*)name;

// タイムランキングの開始
-(void)startRankWithNum:(int)num;
// スコア登録前にランキングに入れた場合何位になるかを取得
-(int)checkRankWithScore:(double)score;
// スコアをタイムランキングに登録（名前重複あり）
-(void)insertWithName:(NSString*)name Score:(double)score;
// スコアをタイムランキングに登録（名前重複なし）
-(void)updateWithName:(NSString*)name Score:(double)score;
// タイムランキングから指定された順位のスコアを取得
-(double)getScoreWithRank:(int)rank;
// タイムランキングから指定された順位の名前を取得
-(NSString*)getNameWithRank:(int)rank;

@end
