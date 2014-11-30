//
//  RFRadioView.m
//  RadioFree
//
//  Created by zhaojianguo-PC on 14-5-23.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import "RFRadioView.h"
#import "FSPlaylistItem.h"
#import "UIView+Additions.h"
#import "Globle.h"
#import "FMLrcView.h"
#import "FMSongListModel.h"
#import "FMSongModel.h"
#import "MCDataEngine.h"
#import "UIImageView+WebCache.h"
#import "FMPAImageView.h"
#import "FSAudioStream.h"
#import "ProgressHUD.h"

@implementation RFRadioView
@synthesize delegate = _delegate;
@synthesize selectedPlaylistItem = _selectedPlaylistItem;
@synthesize downLoadButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:232.f/255.f green:184.f/255.f blue:10.f/255.f alpha:1.f];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundControlRadioStatus:) name:FMRFRadioViewStatusNotifiation object:nil];
        
//        audioController = [[FSAudioController alloc] init];
        audioPlayer = [[AudioPlayer alloc] init];
        audioPlayer.delegate = self;

        _currentPlaybackTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, 25)];
        _currentPlaybackTime.font =[UIFont boldSystemFontOfSize:14.0f];
        _currentPlaybackTime.textAlignment = NSTextAlignmentCenter;
        _currentPlaybackTime.textColor = [UIColor blackColor];
        _currentPlaybackTime.text = @"00:00";
        [self addSubview:_currentPlaybackTime];
        
        progress = [[UISlider alloc] initWithFrame:CGRectMake(_currentPlaybackTime.size.width+_currentPlaybackTime.origin.x, 18,self.size.width-110,  progress.size.height)];
        progress.continuous = YES;
        progress.minimumTrackTintColor = [UIColor colorWithRed:244.0f/255.0f green:147.0f/255.0f blue:23.0f/255.0f alpha:1.0f];
        progress.maximumTrackTintColor = [UIColor lightGrayColor];
        [progress setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateNormal];
//        [progress setThumbImage:nil forState:UIControlStateNormal];
//        [progress addTarget:self action:@selector(seek) forControlEvents:UIControlEventValueChanged];
        [self addSubview:progress];
        
        _totalPlaybackTime = [[UILabel alloc] initWithFrame:CGRectMake(progress.size.width+progress.origin.x, 5, 50, 25)];
        _totalPlaybackTime.font =[UIFont boldSystemFontOfSize:14.0f];
        _totalPlaybackTime.textAlignment = NSTextAlignmentCenter;
        _totalPlaybackTime.textColor = [UIColor blackColor];
        _totalPlaybackTime.text = @"00:00";
        [self addSubview:_totalPlaybackTime];
        
        lrcView = [[FMLrcView alloc] initWithFrame:CGRectMake(0, progress.size.height+progress.origin.y+10, self.size.width, self.size.height-100)];
        [self addSubview:lrcView];
        
        backImageView = [[FMPAImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-64/2, frame.size.height-64-10, 64, 64)];
        [self addSubview:backImageView];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(frame.size.width/2-64/2, frame.size.height-64-10, 64, 64);
        [_playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"playHight.png"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _preButton.frame = CGRectMake(_playButton.origin.x-60, _playButton.origin.y+8, 48, 48);
        [_preButton setImage:[UIImage imageNamed:@"preSong.png"] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(preButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(_playButton.origin.x+70, _playButton.origin.y+8, 48, 48);
        [_nextButton setImage:[UIImage imageNamed:@"nextSong.png"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playbackButton.frame =  CGRectMake(5, _preButton.origin.y, 48, 48);
        [_playbackButton setImage:[UIImage imageNamed:@"order.png"] forState:UIControlStateNormal];
        [_playbackButton addTarget:self action:@selector(playBackButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playbackButton];
        isPlayBack = 0;
        
        _playListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playListButton.frame =  CGRectMake(self.size.width-48-5, _preButton.origin.y, 48, 48);
        [_playListButton setImage:[UIImage imageNamed:@"playList.png"] forState:UIControlStateNormal];
        [_playListButton addTarget:self action:@selector(playListButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playListButton];
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake(_currentPlaybackTime.origin.x, _currentPlaybackTime.origin.y+_currentPlaybackTime.size.height, 48, 48);
        [_collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_collectButton];
        
        self.downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.downLoadButton.frame = CGRectMake(_totalPlaybackTime.origin.x, _totalPlaybackTime.origin.y+_totalPlaybackTime.size.height, 48, 48);
        self.downLoadButton.enabled = NO;
        [self.downLoadButton setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateNormal];
        [self.downLoadButton addTarget:self action:@selector(downLoadButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.downLoadButton];

        
        noLrcLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2-25/2, frame.size.width, 25)];
        noLrcLabel.textAlignment = NSTextAlignmentCenter;
        noLrcLabel.textColor =[UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
        [self addSubview:noLrcLabel];
        noLrcLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    }
    return self;
}
-(void)setRadioViewLrc
{
    [backImageView setImageWithURL:[NSURL URLWithString:_songModel.songPicBig]];
    if ([_songModel.lrcLink length]!=0) {
        noLrcLabel.text = @"";
        NSFileManager * manager = [[NSFileManager alloc] init];
        NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.lrc",_songlistModel.ting_uid,_songlistModel.song_id,_songlistModel.song_id]];
        if ([manager fileExistsAtPath:filePath]) {
            [lrcView setLrcSourcePath:filePath];
        }else{
            MCDataEngine * network = [MCDataEngine new];
            [network getSongLrcWith:_songlistModel.ting_uid :_songlistModel.song_id :_songModel.lrcLink WithCompletionHandler:^(BOOL sucess, NSString *path) {
                if (sucess) {
                    [lrcView setLrcSourcePath:path];
                }
            } errorHandler:^(NSError *error) {
            }];
        }
        isLrc = YES;
    }else{
        noLrcLabel.text = @"无歌词";
        [lrcView scrollViewClearSubView];
        [lrcView selfClearKeyAndTitle];
        isLrc = NO;
    }
}
-(void)playButtonEvent
{
    if (isPlaying) {
        isPlaying = NO;
    }else{
        isPlaying = YES;
    }
    if (audioPlayer.state == AudioPlayerStatePaused){
        [audioPlayer resume];
        [self startTimer];
        backImageView.layer.speed = 0.2;
        CFTimeInterval pausedTime = [backImageView.layer timeOffset];
        CFTimeInterval timeSincePause = [backImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        backImageView.layer.beginTime = timeSincePause;

    }
    else{
        [audioPlayer pause];
        [_progressUpdateTimer invalidate];
        CFTimeInterval pausedTime = [backImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        backImageView.layer.speed = 0.0;
        backImageView.layer.timeOffset = pausedTime;

    }
    [_playButton setImage:isPlaying?[UIImage imageNamed:@"pasue.png"]:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_playButton setImage:isPlaying?[UIImage imageNamed:@"pasueHight.png"]:[UIImage imageNamed:@"playHight.png"] forState:UIControlStateHighlighted];
}
-(void)playBackButtonEvent
{
    isPlayBack+=1;
    NSString * name = nil;
    NSString * title = nil;
    switch (isPlayBack) {
        case 0:
            name = @"order.png";
            title = @"顺序播放";
            break;
        case 1:
            name = @"random.png";
            title = @"随机播放";
            break;
        case 2:
            name = @"lock.png";
            title = @"单曲播放";
            isPlayBack=-1;
            break;
        default:
            break;
    }
    [_playbackButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [ProgressHUD showSuccess:title];
}

-(void)preButtonEvent:(UIButton *)btn
{
    [self stopEverything];
    [_delegate radioView:self preSwitchMusic:btn];
}

-(void)nextButtonEvent:(UIButton *)btn
{
    [self stopEverything];
    [_delegate radioView:self nextSwitchMusic:btn];
}
-(void)playListButtonEvent:(UIButton *)btn
{
    [_delegate radioView:self playListButton:btn];
}
-(void)downLoadButtonEvent:(UIButton *)btn
{
    self.downLoadButton.enabled = NO;
   [_delegate radioView:self downLoadButton:btn];
}
-(void)collectButtonEvent:(UIButton *)btn
{
    
    
}
-(void)startTimer
{
    _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                            target:self
                                                          selector:@selector(updatePlaybackProgress)
                                                          userInfo:nil
                                                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_progressUpdateTimer forMode:NSRunLoopCommonModes];
}
-(void)startMusic
{

    [audioPlayer play:[NSURL URLWithString:self.selectedPlaylistItem.url]];
    
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 1.5f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO; //No Remove
    
    monkeyAnimation.repeatCount = FLT_MAX;
    [backImageView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    backImageView.layer.speed = 0.2;
    backImageView.layer.beginTime = 0.0;
}

-(NSString*)TimeformatFromSeconds:(int)seconds
{
    int totalm = seconds/(60);
    int h = totalm/(60);
    int m = totalm%(60);
    int s = seconds%(60);
    if (h==0) {
        return  [NSString stringWithFormat:@"%02d:%02d", m, s];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}
-(void)stopEverything
{
    self.downLoadButton.enabled = NO;
    isPlaying = NO;
    [audioPlayer stop];
    [_progressUpdateTimer invalidate];
    
    CFTimeInterval pausedTime = [backImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    backImageView.layer.speed = 0.0;
    backImageView.layer.timeOffset = pausedTime;
}
- (void)setSelectedPlaylistItem:(FSPlaylistItem *)selectedPlaylistItem {
    if (_selectedPlaylistItem != selectedPlaylistItem) {
        _selectedPlaylistItem = selectedPlaylistItem;
        [self stopEverything];
        NSFileManager * manager = [[NSFileManager alloc] init];
        NSString *filePath = [DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld/%lld.mp3",_songlistModel.ting_uid,_songlistModel.song_id,_songlistModel.song_id]];
        if ([manager fileExistsAtPath:filePath]) {
            _selectedPlaylistItem.url = [@"file://" stringByAppendingString:filePath];
            self.downLoadButton.enabled = NO;
        }else{
            self.downLoadButton.enabled = YES;
        }
        _totalPlaybackTime.text = [self TimeformatFromSeconds:_songModel.time];
        [self startMusic];
        [self startTimer];
    }
}

- (FSPlaylistItem *)selectedPlaylistItem {
    return _selectedPlaylistItem;
}
-(void)applicationDidEnterBackgroundControlRadioStatus:(NSNotification *)notification
{
     NSDictionary *dict = [notification userInfo];
    NSString * string = [dict objectForKey:@"keyStatus"];
    if ([string isEqualToString:@"UIEventSubtypeRemoteControlPause"]) {
        [self playButtonEvent];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlPlay"]){
        [self playButtonEvent];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlPreviousTrack"]){
        [self preButtonEvent:_preButton];
    }else if ([string isEqualToString:@"UIEventSubtypeRemoteControlNextTrack"]){
        [self nextButtonEvent:_nextButton];
    }
}
-(void) seek
{
    if (!audioPlayer)
    {
        return;
    }
    NSLog(@"Slider Changed: %f", progress.value);
    [audioPlayer seekToTime:progress.value];
}

-(void) updateControls
{
    if (audioPlayer.state == AudioPlayerStateStopped) {
        if (isPlaying) {
            [_delegate radioView:self musicStop:isPlayBack];
        }
        isPlaying = NO;
    }else if (audioPlayer.state == AudioPlayerStateReady){
    }else if (audioPlayer.state == AudioPlayerStateRunning){
    }else if (audioPlayer.state == AudioPlayerStatePlaying){
        isPlaying = YES;

    }else if (audioPlayer.state == AudioPlayerStateError){

    }
    [_playButton setImage:isPlaying?[UIImage imageNamed:@"pasue.png"]:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_playButton setImage:isPlaying?[UIImage imageNamed:@"pasueHight.png"]:[UIImage imageNamed:@"playHight.png"] forState:UIControlStateHighlighted];
}
-(void) updatePlaybackProgress
{
    if (!audioPlayer || audioPlayer.duration == 0){
        progress.value = 0;
        return;
    }
    progress.minimumValue = 0;
    progress.maximumValue = audioPlayer.duration;
    progress.value = audioPlayer.progress;
    _currentPlaybackTime.text =[self TimeformatFromSeconds:audioPlayer.progress];
    if (isLrc) {
        [lrcView scrollViewMoveLabelWith:_currentPlaybackTime.text];
    }
}
-(void) audioPlayer:(AudioPlayer*)audioPlayer stateChanged:(AudioPlayerState)state
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didEncounterError:(AudioPlayerErrorCode)errorCode
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    [self updateControls];
}

-(void) audioPlayer:(AudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(AudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self updateControls];
}

@end
