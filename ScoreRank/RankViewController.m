//
//  RankViewController.m
//  ScoreRank
//
//  Created by KaiLenz on 2012/11/05.
//
//

#import "RankViewController.h"
#import "AppDelegate.h"

@interface RankViewController ()

@end

@implementation RankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // サンプルから流用
    // AppDelegateを使いたいので取得しておく（お約束の書き方。結構重要)
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    // このビューコンが使われているとき、ナビに表示されるボタンを作成
    UIBarButtonItem *btBack = [[UIBarButtonItem alloc]
                               initWithTitle:@"ゲームに戻る"               // ボタンのタイトル
                               style:UIBarButtonItemStyleBordered       // 見た目
                               target:appDelegate                       // 押したときの呼び出し先(重要!：appDelegateを指定)
                               action:@selector(pushBtBack:)];          // 押したとき呼ぶ関数(命令)
    // このビューコンを表示しているときに、ナビの「左側」にボタンを表示
    self.navigationItem.leftBarButtonItem = btBack;
    
    // ランクビューコントローラーの設定
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.title = @"ランキング";
    
    // ランクビューの作成、設置
    _rankView = [[RankView alloc] initWithFrame:CGRectMake(20, 20, 280, 375)];
    [self.view addSubview:_rankView];
}

-(void)viewWillAppear:(BOOL)animated{
    [_rankView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
