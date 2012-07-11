//
//  ViewController.h
//  MusicBook_wincy
//
//  Created by ditudao ditudao on 12-7-7.
//  Copyright (c) 2012年 sysu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface MScorePlayViewController : UIViewController <AVAudioPlayerDelegate,UIScrollViewDelegate>{
    IBOutlet UIButton *playButton;
    IBOutlet UIProgressView *progressView;
    IBOutlet UISlider *voiceView;
    IBOutlet UIScrollView *scroller;
    IBOutlet UIButton *accompanyButton;
    IBOutlet UIButton *preSong;
    IBOutlet UIButton *nextSong;
    IBOutlet UILabel *musicLabel;
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *backgroundPlayer;
    CGFloat currentTime;
    CGFloat totalPlayTime;
    
    float *timeArray;
    float *lenghtArray;
    int count;
    
    float currentIntervalMovedTime;
    float currentTimeInterval;
    float currentLength;
    float speed;
    float timeInteval;
    int currentSection;
    float currentMoveLenght;
    NSInteger currentLinkID;
    
    BOOL stopDraging;
    
    UIView *coverView;
    BOOL haveAccompany;
    
    NSTimer *playTimer;
    NSTimer *scrollMoveTimer;
    
    NSLock *lock;
    
    BOOL playFlag;
}

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UISlider *voiceView;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UIButton *accompanyButton;
@property (nonatomic, retain) IBOutlet UIButton *preSong;
@property (nonatomic, retain) IBOutlet UIButton *nextSong;
@property (nonatomic, retain) IBOutlet UILabel *musicLabel;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) AVAudioPlayer *backgroundPlayer;

-(id)initWithLink:(NSInteger)linkId;

-(IBAction)play;
-(IBAction)selectAccompany;
-(void)voiceChange:(id)sender;
-(void)changeViews;
-(void)changeTheScroll;
-(void)initTheData:(NSInteger)sourceID;
-(void)drapToChangeTheScroll:(UIScrollView *)scrollView;
-(void)lockTheThread;
-(void)unlockTheThread;
-(IBAction)selectPre;
-(IBAction)selectNext;
- (IBAction)backButton:(id)sender;

@end
