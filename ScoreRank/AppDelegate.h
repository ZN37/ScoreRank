//
//  AppDelegate.h
//  ScoreRank
//
//  Created by Kai Lenz on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// 自作ビューコントローラーをインポート
#import "GameViewController.h"
#import "RankViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    // 各ビューコントローラ及びナビゲーションコントローラー
    GameViewController*     _gvc;
    RankViewController*     _rvc;
    
    UINavigationController* _navi;
    
}

@property (strong, nonatomic) UIWindow *window;

@end
