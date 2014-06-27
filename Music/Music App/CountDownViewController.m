//
//  CountDownViewController.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "CountDownViewController.h"
#import "PlayListViewController.h"

@interface CountDownViewController ()
@property (nonatomic, retain) NSMutableArray *arrLaps;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSTimer *songTimer;
@property (nonatomic) int totalTime;
@property (nonatomic) int elapsedTime;
@property (nonatomic) int lastLapTime;
@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedDelegate];
    _arrLaps = [[NSMutableArray alloc] init];
    //self.table.tableHeaderView = self.headrView;
    
    self.elapsedTime = 0;
    self.lastLapTime = 0;
    
    if(appDelegate.isUP) {
        self.btnUp.selected = FALSE;
        self.btnDown.selected = TRUE;
    }
    else {
        self.btnUp.selected = TRUE;
        self.btnDown.selected = FALSE;
    }
    
    [self songTimerFired];
    [self setCurrentItemValue];
    self.songTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(songTimerFired) userInfo:nil repeats:YES];
    
    
    self.lblStopWatch.text = @"00:00";
    self.btnLap.enabled = FALSE;
    
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"trackbar_img.png"]
                               stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
    
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"trackbar_img.png"]
                                 stretchableImageWithLeftCapWidth:15.0 topCapHeight:0.0];
    
    
    [self.timeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self.timeSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
   
   [self.timeSlider setThumbImage:[UIImage imageNamed:@"trackbar_sep_img.png"] forState:UIControlStateNormal];
    [self.timeSlider setThumbImage:[UIImage imageNamed:@"trackbar_sep_img.png"] forState:UIControlStateHighlighted];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(300);
    self.lbltrackdownCaption.transform = transform;
    
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(300);
    self.lblstopWatchCaption.transform = transform1;
    
}

#pragma mark - Buttons Actions

-(IBAction)btnBack:(id)sender{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)btnPlaylist:(id)sender{
    PlayListViewController *viewcontroller=[[PlayListViewController alloc]init];
    [self.navigationController pushViewController:viewcontroller animated:YES];
    
}

- (IBAction)btnUpPressed {
    if(!self.btnUp.selected) {
        return;
    }
    appDelegate.isUP = TRUE;
    self.btnUp.selected = FALSE;
    self.btnDown.selected = TRUE;
}

- (IBAction)btnDownPressed {
    if(!self.btnDown.selected) {
        return;
    }
    appDelegate.isUP = FALSE;
    self.btnDown.selected = FALSE;
    self.btnUp.selected = TRUE;
}

- (IBAction)btnNextSongPressed {
    [appDelegate.musicPlayer skipToNextItem];
}

- (IBAction)btnPreviouSongPressed {
    [appDelegate.musicPlayer skipToPreviousItem];
}

- (IBAction)btnPlayPressed {
    if(appDelegate.musicPlayer.playbackState == MPMoviePlaybackStatePaused) {
        [appDelegate.musicPlayer play];
        self.btnPlay.selected = TRUE;
    }
    else {
        [appDelegate.musicPlayer pause];
        self.btnPlay.selected = FALSE;
    }
}

- (IBAction)btnPlusVolumePressed {
    appDelegate.musicPlayer.volume += 0.1;
}

- (IBAction)btnMinusVolumePressed {
    appDelegate.musicPlayer.volume -= 0.1;
}

- (IBAction)timerSliderValueChanged {
    appDelegate.musicPlayer.currentPlaybackTime = self.timeSlider.value;
}

- (IBAction)volumeSliderValueChanged {
    appDelegate.musicPlayer.volume = self.volumeSlider.value;
}

- (IBAction)btnStartPressed {
    self.btnStart.selected = !self.btnStart.selected;
    if(self.btnStart.selected) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        self.btnLap.enabled = TRUE;
        self.btnLap.selected = FALSE;
    }
    else { // Stop
        [self.timer invalidate];
        self.btnLap.selected = TRUE;
    }
}

- (IBAction)btnLapPressed {
    if(self.btnLap.selected) { // Reset
        [self.arrLaps removeAllObjects];
        self.lblStopWatch.text = @"00:00";
        self.elapsedTime = 0;
        self.lastLapTime = 0;
        self.btnLap.enabled = FALSE;
        self.btnLap.selected = FALSE;
        [self.table reloadData];
    }
    else { // Lap
        int lapTime = self.elapsedTime - self.lastLapTime;
        int minutes = lapTime / 60;
        int seconds = lapTime % 60;
        self.lastLapTime += lapTime;
        [self.arrLaps addObject:[NSString stringWithFormat:@"%02d:%02d",minutes,seconds]];
        [self.table reloadData];
    }
}

#pragma mark - Timer

- (void)timerFired {
    self.elapsedTime ++;
    if(self.elapsedTime >= 3600) {
        int hours = self.elapsedTime / 3600;
        int remaining = self.elapsedTime % 3600;
        int minutes = remaining / 60;
        int seconds = remaining % 60;
        
        self.lblStopWatch.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }
    else {
        int minutes = self.elapsedTime / 60;
        int seconds = self.elapsedTime % 60;
        self.lblStopWatch.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    
}

- (void)songTimerFired {
    int passedTime = appDelegate.musicPlayer.currentPlaybackTime;
    int totalTime = [[appDelegate.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyPlaybackDuration] intValue];
    
    self.timeSlider.value = passedTime;
    
    if(passedTime >= 3600) {
        int hours = passedTime / 3600;
        int remaining = passedTime % 3600;
        int minutes = remaining / 60;
        int seconds = remaining % 60;
        
        self.lblTimeElapsed.text = [NSString stringWithFormat:@"%d:%02d:%02d",hours,minutes,seconds];
    }
    else {
        int minutes = passedTime / 60;
        int seconds = passedTime % 60;
        self.lblTimeElapsed.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    }
    
    int remainingTime = totalTime - passedTime;
    if(remainingTime >= 3600) {
        int hours = remainingTime / 3600;
        int remaining = remainingTime % 3600;
        int minutes = remaining / 60;
        int seconds = remaining % 60;
        
        self.lblTimeRemaining.text = [NSString stringWithFormat:@"-%d:%02d:%02d",hours,minutes,seconds];
    }
    else {
        int minutes = remainingTime / 60;
        int seconds = remainingTime % 60;
        self.lblTimeRemaining.text = [NSString stringWithFormat:@"-%d:%02d",minutes,seconds];
    }
    
    if(appDelegate.isUP) {
        
        if(passedTime >= 3600) {
            int hours = passedTime / 3600;
            int remaining = passedTime % 3600;
            int minutes = remaining / 60;
            int seconds = remaining % 60;
            
            self.lblTrackCountDown.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        }
        else {
            int minutes = passedTime / 60;
            int seconds = passedTime % 60;
            self.lblTrackCountDown.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
        }
        
    }
    else {
        if(remainingTime >= 3600) {
            int hours = remainingTime / 3600;
            int remaining = remainingTime % 3600;
            int minutes = remaining / 60;
            int seconds = remaining % 60;
            
            self.lblTrackCountDown.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        }
        else {
            int minutes = remainingTime / 60;
            int seconds = remainingTime % 60;
            self.lblTrackCountDown.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
        }
    }
 
    if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.btnPlay.selected = FALSE;
    }
    else if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        self.btnPlay.selected = TRUE;
    }
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrLaps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anyCell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"anyCell"];
        UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(230, 0,50, 30)];
        lblTime.backgroundColor = [UIColor clearColor];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        lblTime.font = [UIFont fontWithName:@"Helvetica " size:cell.textLabel.font.pointSize];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica " size:cell.textLabel.font.pointSize];

        cell.textLabel.textColor=[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        lblTime.textColor=[UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        
        lblTime.tag = 1;
        [cell.contentView addSubview:lblTime];
 
    }

    UILabel *lblTime = (UILabel *)[cell.contentView viewWithTag:1];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Lap%d",indexPath.row+1];
    lblTime.text = [NSString stringWithFormat:@"%@",[self.arrLaps objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setCurrentItemValue {
  
    if(appDelegate.selectedPlayList == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    MPMediaItem *song = appDelegate.musicPlayer.nowPlayingItem;
    
    NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
    NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist];
    NSString *album = [song valueForProperty: MPMediaItemPropertyAlbumTitle];
    
    self.lblSongName.text = songTitle;
    self.lblSongDetails.text = [NSString stringWithFormat:@"%@ - %@",artist,album];
    
    int passedTime = appDelegate.musicPlayer.currentPlaybackTime;
    int totalTime = [[appDelegate.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyPlaybackDuration] intValue];
    self.timeSlider.maximumValue = totalTime;
    
    if(passedTime >= 3600) {
        
        int hours = passedTime / 3600;
        int remaining = passedTime % 3600;
        int minutes = remaining / 60;
        int seconds = remaining % 60;
        
        self.lblTimeElapsed.text = [NSString stringWithFormat:@"%d:%02d:%02d",hours,minutes,seconds];
    }
    else {
        int minutes = passedTime / 60;
        int seconds = passedTime % 60;
        self.lblTimeElapsed.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
    }
    
    int remainingTime = totalTime - passedTime;
    if(remainingTime >= 3600) {
        
        int hours = remainingTime / 3600;
        int remaining = remainingTime % 3600;
        int minutes = remaining / 60;
        int seconds = remaining % 60;
        
        self.lblTimeRemaining.text = [NSString stringWithFormat:@"-%d:%02d:%02d",hours,minutes,seconds];
    }
    else {
        int minutes = remainingTime / 60;
        int seconds = remainingTime % 60;
        self.lblTimeRemaining.text = [NSString stringWithFormat:@"-%d:%02d",minutes,seconds];
    }
    
    self.timeSlider.value = passedTime;
    
    self.volumeSlider.value = appDelegate.musicPlayer.volume;
    if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.btnPlay.selected = FALSE;
    }
    else if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        self.btnPlay.selected = TRUE;
    }

    if(appDelegate.musicPlayer.indexOfNowPlayingItem == 0) {
        self.btnPreviousSong.enabled = FALSE;
    }
    else {
        self.btnPreviousSong.enabled = TRUE;
    }
    
    if(appDelegate.musicPlayer.indexOfNowPlayingItem == [appDelegate.selectedPlayList.items count]-1) {
        self.btnNextSong.enabled = FALSE;
    }
    else {
        self.btnNextSong.enabled = TRUE;
    }

}

- (void)setPlayPauseValue {
    if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        self.btnPlay.selected = FALSE;
    }
    else if(appDelegate.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        self.btnPlay.selected = TRUE;
    }
}

- (void)setVoumeValue {
    self.volumeSlider.value = appDelegate.musicPlayer.volume;
}

@end