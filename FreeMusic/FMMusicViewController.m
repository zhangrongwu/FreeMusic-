//
//  FMMusicViewController.m
//  FreeMusic
//
//  Created by zhaojianguo-PC on 14-5-28.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "FMMusicViewController.h"
#import "RFRadioView.h"
#import "FSPlaylistItem.h"
#import "MCDataEngine.h"
#import "FMSongListModel.h"
#import "FMSongModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FMPlayingListViewController.h"


@interface FMMusicViewController ()<RFRadioViewDelegate>
{
    RFRadioView * _radioView;
}
@end

@implementation FMMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(FMMusicViewController *)shareMusicViewController
{
    static FMMusicViewController * musicViewController;
    if (musicViewController == nil) {
        musicViewController = [[FMMusicViewController alloc] init];
    }
    return musicViewController;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigation.leftImage  = [UIImage imageNamed:@"nav_backbtn.png"];
//    self.navigation.headerImage = [UIImage imageNamed:@"nav_canadaicon.png"];
//    self.navigation.title = [NSString stringWithFormat:@"%@(歌曲%d)",_singerModel.name,_singerModel.songs_total];
    self.navigation.navigaionBackColor =  [UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
    
    _songModel = [FMSongModel new];
    
    _radioView = [[RFRadioView alloc] initWithFrame:CGRectMake(0,self.navigation.size.height+self.navigation.origin.y, 320,self.view.size.height-self.navigation.size.height-self.navigation.origin.y)];
    _radioView.delegate = self;
    [self.view addSubview:_radioView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundSetSongInformation:) name:FMRFRadioViewSetSongInformationNotification object:nil];

    // Do any additional setup after loading the view.
}
-(BOOL)isLocalMP3
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.mp3",_songListModel.ting_uid,_songListModel.song_id,_songListModel.song_id]];
    if ([manager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}
-(NSString *)localMP3path
{
    NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.mp3",_songListModel.ting_uid,_songListModel.song_id,_songListModel.song_id]];
    return filePath;
}
-(void)playMusicWithSongLink:(FMSongListModel*)model
{
    NSLog(@"%@",model.title);
        MCDataEngine * network = [MCDataEngine new];
        [network getSongInformationWith:model.song_id WithCompletionHandler:^(FMSongModel *songModel) {
            FSPlaylistItem * item = [[FSPlaylistItem alloc] init];
            item.title = songModel.songName;
            item.url = songModel.songLink;
            _radioView.songlistModel = model;
            _radioView.songModel = songModel;
            [_radioView setRadioViewLrc];
            globle.isPlaying = YES;
            _songModel = songModel;
            _songListModel =model;
            self.navigation.title =songModel.songName;
            _radioView.selectedPlaylistItem = item;
            if (globle.isApplicationEnterBackground) {
                [self applicationDidEnterBackgroundSetSongInformation:nil];
            }
        } errorHandler:^(NSError *error) {
            if ([self isLocalMP3]) {
                NSLog(@"isLocal");
                [self playModleIsLock];
                [ProgressHUD showError:@"网络错误"];
//                FSPlaylistItem * item = [[FSPlaylistItem alloc] init];
//                item.title = _songListModel.title;
//                item.url = [self localMP3path];
//                _radioView.songlistModel = model;
//                [_radioView setRadioViewLrc];
//                globle.isPlaying = YES;
//                _songListModel =model;
//                self.navigation.title =_songListModel.title;
//                _radioView.selectedPlaylistItem = item;
            }
        }];
}
-(void)applicationDidEnterBackgroundSetSongInformation:(NSNotification *)notification
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
		NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
		[dict setObject:_songModel.songName forKey:MPMediaItemPropertyTitle];
		[dict setObject:_songListModel.author  forKey:MPMediaItemPropertyArtist];
//		[dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]] forKey:MPMediaItemPropertyArtwork];
		[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
		[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
	}
}

-(void)playModleIsLock
{
    FSPlaylistItem * item = [[FSPlaylistItem alloc] init];
    item.title = _songModel.songName;
    item.url = _songModel.songLink;
    _radioView.selectedPlaylistItem = item;
    _radioView.songlistModel = _songListModel;
    _radioView.songModel = _songModel;
    globle.isPlaying = YES;
    self.navigation.title =_songModel.songName;
}
#pragma
#pragma mark RFRadioViewDelegate
-(void)radioView:(RFRadioView *)view musicStop:(NSInteger)playModel
{
    FMSongListModel * model = nil;
    switch (playModel) {
        case 0:
        {
            self.index+=1;
            if (self.index>=[self.array count]) {
                self.index = 0;
            }
            model = [self.array objectAtIndex:self.index];
            [self playMusicWithSongLink:model];
        }
            break;
        case 1:
        {
            NSInteger  number = [self.array count];
            model = [self.array objectAtIndex:arc4random()%number];
            [self playMusicWithSongLink:model];
        }
            break;
        case -1:
        {
            model = self.songListModel;
            [self playModleIsLock];
        }
            break;
        default:
            break;
    }
}
-(void)radioView:(RFRadioView *)view preSwitchMusic:(UIButton *)pre
{
    if ([self.array count]!=0) {
        self.index-=1;
        if (self.index<0) {
            self.index = 0;
        }
        FMSongListModel * model = [self.array objectAtIndex:self.index];
        [self playMusicWithSongLink:model];
    }
}
-(void)radioView:(RFRadioView *)view nextSwitchMusic:(UIButton *)next
{
    if ([self.array count]!=0) {
        self.index+=1;
        if (self.index==[self.array count]) {
            self.index = self.index-1;
        }
        FMSongListModel * model = [self.array objectAtIndex:self.index];
        [self playMusicWithSongLink:model];
    }
}
-(void)radioView:(RFRadioView *)view playListButton:(UIButton *)btn
{
    FMPlayingListViewController * viewController = [[FMPlayingListViewController alloc] init];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentViewController:navigation animated:YES completion:^{
        
    }];
}
-(void)radioView:(RFRadioView *)view downLoadButton:(UIButton *)btn
{
    MCDataEngine * network = [MCDataEngine new];
    [network downLoadSongWith:_songListModel.ting_uid :_songListModel.song_id :view.selectedPlaylistItem.url WithCompletionHandler:^(BOOL sucess, NSString *path) {
        _radioView.downLoadButton.enabled = NO;
    } errorHandler:^(NSError *error) {
        _radioView.downLoadButton.enabled = YES;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
