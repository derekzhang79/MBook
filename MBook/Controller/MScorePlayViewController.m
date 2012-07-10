//
//  ViewController.m
//  MusicBook_wincy
//
//  Created by ditudao ditudao on 12-7-7.
//  Copyright (c) 2012年 sysu. All rights reserved.
//

#import "MScorePlayViewController.h"

@implementation MScorePlayViewController

@synthesize playButton;
@synthesize audioPlayer;
@synthesize accompanyButton;
@synthesize progressView;
@synthesize voiceView;
@synthesize scroller;
@synthesize backgroundPlayer;
@synthesize preSong;
@synthesize nextSong;
@synthesize musicLabel;

#define timeIntervalConstant 0.1
#define constant 10

#define imageViewTag 1000
#define lingViewTag 999



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MScorePlayViewController" bundle:nil];
    if (self) {
        // Custom initialization
        NSLog(@"MScorePlayViewController");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#pragma mark - View lifecycle

-(void)dealloc{
    [playButton release];
    [audioPlayer release];
    [progressView release];
    [voiceView release];
    [scroller release];
    [backgroundPlayer release];
    [accompanyButton release];
    [lock release];
    [preSong release];
    [nextSong release];
    [musicLabel release];
    
    free(timeArray);
    free(lenghtArray);
    
    [super dealloc];
}

- (void)viewDidLoad
{    
    [self.view setBackgroundColor:[UIColor grayColor]];

    [musicLabel setText:[NSString stringWithFormat:@"music%d",currentLinkID]];
    [progressView setProgress:0.0f];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation== UIInterfaceOrientationLandscapeLeft||
            interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

#pragma function
-(void)clean{
    
    playFlag=NO;
    
    [[scroller viewWithTag:imageViewTag] removeFromSuperview];
    [progressView setProgress:0.0f];
    
    [playTimer invalidate];
    [scrollMoveTimer invalidate];
    playTimer=nil;
    scrollMoveTimer=nil;
    
    [audioPlayer stop];
    [audioPlayer release];
    audioPlayer=nil;
    
    [backgroundPlayer stop];
    [backgroundPlayer release];
    backgroundPlayer=nil;
    
    free(timeArray);
    free(lenghtArray);
    timeArray=nil;
    lenghtArray=nil;
    
    [coverView release];
    coverView=nil;
    
    [musicLabel setText:@"没有选中音乐"];
}

-(IBAction)selectPre{
    
    [self clean];
    
    [self initTheData:--currentLinkID];
}

-(IBAction)selectNext{
    
    [self clean];
    
    [self initTheData:++currentLinkID];
}

-(id)initWithLink:(NSInteger)linkId{
    self=[super init];
    if (self) {
        [self initTheData:linkId];
    }
    return self;
}

-(void)initTheData:(NSInteger)sourceID{
    
    currentLinkID=sourceID;
    
    // just for demo
    if (currentLinkID>2 || currentLinkID<1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"这demo没有此歌" message:nil delegate:nil cancelButtonTitle: nil   otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        
        [playButton setEnabled:NO];
        [accompanyButton setEnabled:NO];
         
        return;
    }
    
    // 设置标题
    [musicLabel setText:[NSString stringWithFormat:@"music%d",currentLinkID]];
    
    // 设置按钮
    [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playButton setEnabled:YES];
    [accompanyButton setEnabled:YES];
    
    // 读取音乐资源
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"musicInform" ofType:@"plist"];
    NSDictionary *musicDict=[[[NSDictionary alloc]initWithContentsOfFile:filePath]autorelease];
    NSMutableDictionary *resourceDict=[musicDict valueForKey:[NSString stringWithFormat:@"%d",sourceID]];
    
    // set AVAudioPlayer
    // 没伴奏
    filePath = [[NSBundle mainBundle] pathForResource:[resourceDict valueForKey:@"music2"] ofType:[resourceDict valueForKey:@"music2Type"]];  
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];  
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [fileURL release];
    
    // 有伴奏
    filePath=[[NSBundle mainBundle] pathForResource:[resourceDict valueForKey:@"music1"] ofType:[resourceDict valueForKey:@"music1Type"]];  
    NSURL *fileURL2=[[NSURL alloc] initFileURLWithPath:filePath];
    backgroundPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
    [fileURL2 release];
    haveAccompany=YES;
    
    audioPlayer.delegate=self;
    backgroundPlayer.delegate=self;
    
    //预载缓冲，为播放声音准备
    [self.audioPlayer prepareToPlay];
    [self.backgroundPlayer prepareToPlay];
    
    currentTime=0.0f;
    totalPlayTime=self.audioPlayer.duration;
    
    [progressView setProgress:0.0f];
    
    playFlag=NO;
    
    // 读取控制数据
    filePath=[[NSBundle mainBundle] pathForResource:[resourceDict valueForKey:@"data"] ofType:[resourceDict valueForKey:@"dataType"]];
    NSMutableString *data=[[NSMutableString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    char temp;
    char mark='/',markBreak='\n',markEnd='#';
    count=0;
    NSMutableString *tempString=[[NSMutableString alloc]init];
    
    for (int i=0; i<[data length]; i++) {
        temp=[data characterAtIndex:i];
        if (temp==mark) {
            count++;
        }
    }
    
    timeArray=(float *)malloc(sizeof(float)*count);
    lenghtArray=(float *)malloc(sizeof(float)*count);
    int tempTimeCount=0;
    int tempLenghtCount=0;
    
    for (int i=0; i<[data length]; i++) {
        temp=[data characterAtIndex:i];
        if (temp!=mark && temp!=markBreak && temp!=markEnd) {
            [tempString appendFormat:[NSString stringWithFormat:@"%c",temp]];
        }
        else{
            if (temp==mark) {
                timeArray[tempTimeCount++]=[tempString floatValue];
                [tempString replaceCharactersInRange:NSMakeRange(0, [tempString length]) withString:@""];
            }
            else{
                if (temp==markBreak) {
                    lenghtArray[tempLenghtCount++]=[tempString floatValue];
                    [tempString replaceCharactersInRange:NSMakeRange(0, [tempString length]) withString:@""];
                }
            }
        }
    }
    
    // 初始话滚动控制
    currentSection=0;
    currentIntervalMovedTime=0;
    currentTimeInterval=timeArray[currentSection];
    currentLength=lenghtArray[currentSection];
    currentMoveLenght=0;
    
    timeInteval=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?timeIntervalConstant:currentTimeInterval-currentIntervalMovedTime;
    speed=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?currentLength/(currentTimeInterval*constant):currentLength;
    lock=[[NSLock alloc]init];
    
    // 设置音乐图片
    filePath = [[NSBundle mainBundle] pathForResource:[resourceDict valueForKey:@"picture"] ofType:[resourceDict valueForKey:@"pictureType"]];
    
    UIImage *tempImage=[UIImage imageWithContentsOfFile:filePath];
    float ratio=tempImage.size.height/160;
    UIImageView *imageView=[[UIImageView alloc]initWithImage:tempImage];
    imageView.tag=imageViewTag;
    imageView.frame = CGRectMake(160, 20, tempImage.size.width/ratio, tempImage.size.height/ratio);
    coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 80, 0, 50)];
    [coverView setBackgroundColor:[UIColor blueColor]];
    [coverView setAlpha:0.3];
    [imageView addSubview:coverView];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    animation.fillMode = kCAFillModeForwards;
    
    [animation setType:kCATransitionFade];
    animation.subtype = kCATransitionFromBottom;
    [self.view.layer addAnimation:animation forKey:@"Reveal"];
    
    [scroller addSubview:imageView];
    [imageView release];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(160, 46, 2, scroller.frame.size.height-46)];
    [lineView setBackgroundColor:[UIColor blueColor]];
    lineView.alpha=0.5f;
    [self.view addSubview:lineView];
    [lineView release];
    
    scroller.contentSize=CGSizeMake(467+imageView.frame.size.width, scroller.contentSize.height);
    scroller.pagingEnabled=NO;
    scroller.showsHorizontalScrollIndicator=NO;
    scroller.showsVerticalScrollIndicator=NO;
    [scroller setContentOffset:CGPointMake(0, scroller.contentOffset.y)];
    
    [data release];
    [tempString release];
}

-(IBAction)selectAccompany{
    haveAccompany=!haveAccompany;
    [accompanyButton setBackgroundImage:[UIImage imageNamed:haveAccompany? @"伴奏选中.png":@"伴奏.png"] forState:UIControlStateNormal];

    if (playFlag) {
        if (haveAccompany) {
            self.backgroundPlayer.currentTime=self.audioPlayer.currentTime;
            currentTime=self.backgroundPlayer.currentTime;
            [self.backgroundPlayer play];
            [self.audioPlayer stop];
        }
        else{
            self.audioPlayer.currentTime=self.backgroundPlayer.currentTime;
            currentTime=self.audioPlayer.currentTime;
            [self.audioPlayer play];
            [self.backgroundPlayer stop];
        }
    }
}

-(IBAction)play {
    if (playFlag==NO) {
        //确认声音播放时间点在开始的位置  
        if (currentTime==0) {
            [coverView setFrame:CGRectMake(0, 80, lenghtArray[0], 50)];
        }
        self.audioPlayer.currentTime = currentTime;  
        self.backgroundPlayer.currentTime=currentTime;
        //声音播放器启动
        if (haveAccompany) [self.backgroundPlayer play];
        else [self.audioPlayer play];
        
        
        playFlag=YES;  
        [self changeViews];
        [self changeTheScroll];
        
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else{
        currentTime=haveAccompany?self.backgroundPlayer.currentTime: self.audioPlayer.currentTime;
        if (haveAccompany) [self.backgroundPlayer stop];
        else [self.audioPlayer stop];
        
        playFlag=NO;
        
        [playTimer invalidate];
        [scrollMoveTimer invalidate];
        playTimer=nil;
        scrollMoveTimer=nil;
        
        [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

-(void)voiceChange:(id)sender{
    UISlider *tempSlider=(UISlider *)sender;
    self.audioPlayer.volume=tempSlider.value;
    self.backgroundPlayer.volume=tempSlider.value;
}

-(void)changeViews{
    if (playFlag) {
        if  (!haveAccompany)[progressView setProgress:self.audioPlayer.currentTime/totalPlayTime];
        else [progressView setProgress:self.backgroundPlayer.currentTime/totalPlayTime];
        
        playTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeViews) userInfo:nil repeats:NO];
    }
}

-(void)lockTheThread{
    [lock lock];
}

-(void)unlockTheThread{
    [lock unlock];
}

-(void)drapToChangeTheScroll:(UIScrollView *)scrollView{
    
    [self performSelectorOnMainThread:@selector(lockTheThread) withObject:nil waitUntilDone:NO];
    
    //停止定时器
    [playTimer invalidate];
    [scrollMoveTimer invalidate];
    playTimer=nil;
    scrollMoveTimer=nil;

    // 调整播放控制信息
    currentMoveLenght=scrollView.contentOffset.x;
    float tempLenght;
    int mark=0;
    for (; mark<count; mark++) {
        tempLenght+=lenghtArray[mark];
        if (currentMoveLenght<tempLenght) {
            tempLenght=tempLenght-lenghtArray[mark];
            break;
        }
    }
    
    float moveInterval=currentMoveLenght-tempLenght;
    
    currentIntervalMovedTime=timeArray[mark]*(moveInterval/lenghtArray[mark]);
    currentSection=mark;
    currentTimeInterval=timeArray[mark];
    currentLength=lenghtArray[mark];
    
    timeInteval=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?timeIntervalConstant:currentTimeInterval-currentIntervalMovedTime;
    speed=timeInteval>=timeIntervalConstant?currentLength/(currentTimeInterval*constant):currentLength/(currentTimeInterval*constant)*(timeInteval/timeIntervalConstant);
    
    [coverView setFrame:CGRectMake(tempLenght, coverView.frame.origin.y, lenghtArray[currentSection], coverView.frame.size.height)];
    
    //确认声音播放时间点在开始的位置  
    currentTime=0;
    if (mark==0) {
        currentTime+=currentIntervalMovedTime;
    }
    else{
        for (int i=0; i<mark; i++) currentTime+=timeArray[i];
        currentTime+=currentIntervalMovedTime;
    }
        
    self.audioPlayer.currentTime = currentTime;  
    self.backgroundPlayer.currentTime=currentTime;
    
    //声音播放器启动
    if (haveAccompany) [self.backgroundPlayer play];
    else [self.audioPlayer play];
    
    playFlag=YES;  
    [playButton setEnabled:YES];
    [self changeViews];
    [self changeTheScroll];
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    
    [self performSelectorOnMainThread:@selector(unlockTheThread) withObject:nil waitUntilDone:NO];
}

-(void)changeTheScroll{
    if (playFlag && scrollMoveTimer!=nil) {
        if (currentSection<=count-1) {
            currentIntervalMovedTime+=timeInteval;
            currentMoveLenght+=speed;
            [scroller setContentOffset:CGPointMake(scroller.contentOffset.x+speed, scroller.contentOffset.y) animated:NO];
            
            if (currentIntervalMovedTime==currentTimeInterval) {
                
                // 设置播放控制数据
                currentIntervalMovedTime=0;
                currentSection++;
                currentTimeInterval=timeArray[currentSection];
                currentLength=lenghtArray[currentSection];
                
                // 设置播放覆盖图片
                [coverView setFrame:CGRectMake(currentMoveLenght, coverView.frame.origin.y, lenghtArray[currentSection], coverView.frame.size.height)];
                
                timeInteval=currentTimeInterval>timeIntervalConstant?timeIntervalConstant:currentTimeInterval;
                speed=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?currentLength/(currentTimeInterval*constant):currentLength;
            }
            else{
                timeInteval=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?timeIntervalConstant:currentTimeInterval-currentIntervalMovedTime;
                speed=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?speed:speed*(currentTimeInterval-currentIntervalMovedTime)*constant;
            }
            
            scrollMoveTimer=[NSTimer scheduledTimerWithTimeInterval:timeInteval target:self selector:@selector(changeTheScroll) userInfo:nil repeats:NO];
        }
        else{
            scrollMoveTimer=nil;
        }
    }
    else{
        scrollMoveTimer=[NSTimer scheduledTimerWithTimeInterval:timeInteval target:self selector:@selector(changeTheScroll) userInfo:nil repeats:NO];
    }
}

int drapCount=0;

#pragma Scroll view delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    playFlag=NO;
    [playButton setEnabled:NO];
    [playTimer invalidate];
    [scrollMoveTimer invalidate];
    playTimer=nil;
    scrollMoveTimer=nil;
    
    // 设置播放控制
    if (haveAccompany) [self.backgroundPlayer stop];
    else [self.audioPlayer stop];
    
    [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self drapToChangeTheScroll:scrollView];
    } 
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self drapToChangeTheScroll:scrollView];
}

#pragma AVAudioPlayer delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    playFlag=NO;
    currentTime=0.0f;
    [progressView setProgress:currentTime];
    [scroller setContentOffset:CGPointMake(0, scroller.contentOffset.y) animated:NO];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
    scrollMoveTimer=nil;
    playTimer=nil;
    
    // 初始话滚动控制
    currentSection=0;
    currentIntervalMovedTime=0;
    currentTimeInterval=timeArray[currentSection];
    currentLength=lenghtArray[currentSection];
    currentMoveLenght=0;
    
    timeInteval=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?timeIntervalConstant:currentTimeInterval-currentIntervalMovedTime;
    speed=(currentTimeInterval-currentIntervalMovedTime)>=timeIntervalConstant?currentLength/(currentTimeInterval*constant):currentLength;
}

@end
