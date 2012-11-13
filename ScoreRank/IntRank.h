//
//  IntRank.h
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/07.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface IntRank : NSObject{
    // データベース名（インスタンスごとに独立なので複数データベースを作成することも可能）
    NSString*   DBName;
}
// 名前をつけて初期化
-(id)initWithDBName:(NSString*)name;

// 整数値ランキングの開始
-(void)startRankWithNum:(int)num;
// スコア登録前に整数値ランキングに入れた場合何位になるかを取得
-(int)checkRankWithScore:(int)score;
// スコアを整数値ランキングに登録（名前重複あり）
-(void)insertWithName:(NSString*)name Score:(int)score;
// スコアを整数値ランキングに登録（名前重複なし）
-(void)updateWithName:(NSString*)name Score:(int)score;
// 整数値ランキングから指定された順位のスコアを取得
-(int)getScoreWithRank:(int)rank;
// 整数値ランキングから指定された順位の名前を取得
-(NSString*)getNameWithRank:(int)rank;

@end
