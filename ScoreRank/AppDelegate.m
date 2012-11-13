//
//  AppDelegate.m
//  ScoreRank
//
//  Created by Kai Lenz on 12/10/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    // 各ビューコントローラーの作成
    _gvc = [[GameViewController alloc] initWithNibName:nil bundle:nil];
    _rvc = [[RankViewController alloc] initWithNibName:nil bundle:nil];
    
    // ナビゲーションコントローラーの作成、ゲームビューコントローラーを初期ページに指定
    _navi = [[UINavigationController alloc] initWithRootViewController:_gvc];
    
    // ナビゲーションコントローラーのビューを設置
    [self.window addSubview:_navi.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) pushBtNext:(id)sender {
    // ナビにお願いして、表示するビューコントローラを_rvcに切り替え
    [_navi pushViewController:_rvc animated:YES];
}

-(void) pushBtBack:(id)sender {
    // ナビにお願いして、ひとつ前のビューコントローラに戻す
    [_navi popViewControllerAnimated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
