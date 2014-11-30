//
//  RFRadioView.h
//  RadioFree
//
//  Created by zhaojianguo-PC on 14-5-23.
//  Copyright (c) 2014年 xiaozi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSPlaylistItem;
@class RFRadioView;
@class FMLrcView;
@class FMSongListModel,FMSongModel;
@class FMPAImageView;

#import "AudioPlayer.h"


@protocol RFRadioViewDelegate <NSObject>
-(void)radioView:(RFRadioView *)view musicStop:(NSInteger)playModel;
-(void)radioView:(RFRadioView *)view preSwitchMusic:(UIButton *)pre;
-(void)radioView:(RFRadioView *)view nextSwitchMusic:(UIButton *)next;
-(void)radioView:(RFRadioView *)view playListButton:(UIButton *)btn;
-(void)radioView:(RFRadioView *)view downLoadButton:(UIButton *)btn;
@end
@interface RFRadioView : UIView<AudioPlayerDelegate>
{
    UISlider *progress;
    NSTimer *_progressUpdateTimer;
    NSTimer *_playbackSeekTimer;
    double _seekToPoint;
    BOOL _paused;
    
    UILabel *_currentPlaybackTime;
    UILabel * _totalPlaybackTime;
    
    UIButton * _playButton;
    UIButton * _preButton;
    UIButton * _nextButton;
    UIButton * _playbackButton;
    UIButton * _playListButton;
    UIButton * _collectButton;
    UIButton * downLoadButton;
    
    UILabel * noLrcLabel;
    
    BOOL isPlaying;
    BOOL isPasue;
    BOOL isLrc;
    
    NSInteger isPlayBack;
    
    id <RFRadioViewDelegate>delegate;
    
    FMLrcView * lrcView;
    FMPAImageView * backImageView;
        
   AudioPlayer* audioPlayer;

}
@property (nonatomic,strong) FMSongListModel * songlistModel;
@property (nonatomic,strong) FMSongModel * songModel;
@property (nonatomic,strong) FSPlaylistItem *selectedPlaylistItem;
@property (nonatomic,assign) id <RFRadioViewDelegate>delegate;
@property (nonatomic,strong) UIButton * downLoadButton;

-(void)playButtonEvent;
-(void)setRadioViewLrc;
@end
