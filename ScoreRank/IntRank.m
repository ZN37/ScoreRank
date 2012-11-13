//
//  IntRank.m
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/07.
//
//

#import "IntRank.h"

@implementation IntRank

// 名前をつけて初期化
-(id)initWithDBName:(NSString *)name{
    self = [super init];
    
    if (self) {
        // 受け取ったデータベース名をメンバ変数に挿入
        DBName = [NSString stringWithFormat:@"%@.sqlite",name];
    }
    
    return self;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 整数ランキングの開始
-(void)startRankWithNum:(int)num{
    // データベースの読み込み設定（初回のみ作成、以降読み込み）
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースに接続
    [db open];
    // tablenameで指定した名前のテーブルが存在しなければ作成
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS intscore (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,score INTEGER)"];
    
    // データベースから全てのレコードを取得
    FMResultSet*    results = [db executeQuery:@"SELECT * FROM intscore"];
    // クエリの実行結果の行数分numから引く
    while ([results next]){
        num = num - 1;
    }
    // 入っているレコードがnumよりも多かった場合scoreが低いものから順に削除
    if (num < 0) {
        FMResultSet*    ashikiri = [db executeQuery:@"SELECT * FROM intscore ORDER BY score, id DESC"];
        while (num < 0) {
            [ashikiri next];
            int deleteid = [ashikiri intForColumn:@"id"];
            [db executeUpdate:@"DELETE FROM intscore WHERE id = ?",[NSNumber numberWithInteger:deleteid]];
            num = num + 1;
        }
    }
    // 入っているレコードがnumより少なかったら追加で挿入
    for (int i = 0; i < num; i++) {
        [db executeUpdate:@"INSERT INTO intscore (name, score) VALUES (?, 0)",@"-----"];
    }
    
    // データベースへの接続終了
    [db close];
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// スコア登録前にランキングに入れた場合何位になるかを取得
-(int)checkRankWithScore:(int)score{
    // 開始時と同じ。以下おまじない
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースに接続
    [db open];
    
    // 送られて来たスコアよりも高い点のレコードをデータベースから取得
    FMResultSet*    rank = [db executeQuery:@"SELECT * FROM intscore WHERE score > ?",[NSNumber numberWithInteger:score]];
    
    // 初期値１
    int rRank = 1;
    // 結果の行数分だけ繰り返しながらカウントアップ
    while ([rank next]) {
        rRank = rRank + 1;
    }
    
    // データベースへの接続終了
    [db close];
    
    // 結果を返す
    return rRank;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// スコアをランキングに登録（名前重複あり）
-(void)insertWithName:(NSString *)name Score:(int)score{
    // おまじない
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースに接続
    [db open];
    
    // tablenameで指定したテーブルに名前とスコアを挿入
    [db executeUpdate:@"INSERT INTO intscore (name, score) VALUES (?, ?)",name,[NSNumber numberWithInteger:score]];
    
    // テーブルからレコードをスコアの低い順、idの小さい（古い）順に取得
    FMResultSet*    ashikiri = [db executeQuery:@"SELECT * FROM intscore ORDER BY score, id"];
    // 一番はじめのレコード（ランキング最下位）の中身を取得
    [ashikiri next];
    int deleteid = [ashikiri intForColumn:@"id"];
    // 最下位のレコードをidで指定して削除
    [db executeUpdate:@"DELETE FROM intscore WHERE id = ?",[NSNumber numberWithInteger:deleteid]];
    
    // データベースへの接続終了
    [db close];
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// スコアをランキングに登録（名前重複なし）
-(void)updateWithName:(NSString *)name Score:(int)score{
    // おまじない
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースへの接続
    [db open];
    
    // tablenameで指定したテーブルに名前とスコアを挿入
    [db executeUpdate:@"INSERT INTO intscore (name, score) VALUES (?, ?)",name,[NSNumber numberWithInteger:score]];
    
    // 送られて来た名前と一致するレコードをスコアの高い順に取得
    FMResultSet*    results = [db executeQuery:@"SELECT * FROM intscore WHERE name = ? ORDER BY score DESC",name];
    // 一番はじめのレコード（同じ名前で一番高い点）の中身を取得
    [results next];
    int resultid = [results intForColumn:@"id"];
    // 一番高い点をidで指定してそれ以外の同名のレコードを削除
    [db executeUpdate:@"DELETE FROM intscore WHERE name = ? AND id != ?",name,[NSNumber numberWithInteger:resultid]];
    
    // データベースへの接続終了
    [db close];
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 整数ランキングから指定された順位のスコアを取得
-(int)getScoreWithRank:(int)rank{
    // おまじない
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースへ接続
    [db open];
    
    // テーブルからレコードをスコアの高い順、idの大きい（新しい）順に取得
    FMResultSet* results = [db executeQuery:@"SELECT * FROM intscore ORDER BY score DESC, id DESC"];
    // 送られて来た数値の数だけ繰り返し次の行を参照
    for (int i = 0; i < rank; i++) {
        [results next];
    }
    // スコアを取得してrScoreに代入
    int rScore = [results intForColumn:@"score"];
    
    // データベースへの接続終了
    [db close];
    
    // rScoreを返す
    return rScore;
}

// ZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZNZN

// 整数ランキングから指定された順位の名前を取得
-(NSString*)getNameWithRank:(int)rank{
    // おまじない
    NSArray*        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*       dir = [paths objectAtIndex:0];
    FMDatabase*     db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DBName]];
    
    // データベースへ接続
    [db open];
    
    // テーブルからレコードをスコアの高い順、idの大きい（新しい）順に取得
    FMResultSet* results = [db executeQuery:@"SELECT * FROM intscore ORDER BY score DESC, id DESC"];
    // 送られて来た数値の数だけ繰り返し次の行を参照
    for (int i = 0; i < rank; i++) {
        [results next];
    }
    // スコアを取得してrNameに代入
    NSString* rName = [results stringForColumn:@"name"];
    
    // データベースへの接続終了
    [db close];
    
    // rNameを返す
    return rName;
}

@end
