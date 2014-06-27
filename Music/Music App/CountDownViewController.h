//
//  CountDownViewController.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CountDownViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {
    AppDelegate *appDelegate;
}
@property(retain,nonatomic)IBOutlet UIView *navigationView;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic , assign) MPMediaPlaylist *selectedPlayList;

@property (nonatomic, retain) IBOutlet UIButton *btnUp;
@property (nonatomic, retain) IBOutlet UIButton *btnDown;
@property (nonatomic, retain) IBOutlet UIButton *btnNextSong;
@property (nonatomic, retain) IBOutlet UIButton *btnPreviousSong;
@property (nonatomic, retain) IBOutlet UIButton *btnPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnPlusVolume;
@property (nonatomic, retain) IBOutlet UIButton *btnMinusVolume;
@property (nonatomic, retain) IBOutlet UIButton *btnStart;
@property (nonatomic, retain) IBOutlet UIButton *btnLap;

@property (nonatomic, retain) IBOutlet UISlider *timeSlider;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;

@property (nonatomic, retain) IBOutlet UIView *headrView;

@property (nonatomic, retain) IBOutlet UILabel *lblTrackCountDown;
@property (nonatomic, retain) IBOutlet UILabel *lblStopWatch;
@property (nonatomic, retain) IBOutlet UILabel *lblSongName;
@property (nonatomic, retain) IBOutlet UILabel *lblSongDetails;
@property (nonatomic, retain) IBOutlet UILabel *lblTimeElapsed;
@property (nonatomic, retain) IBOutlet UILabel *lblTimeRemaining;
@property (nonatomic, retain) IBOutlet UILabel *lbltrackdownCaption;
@property (nonatomic, retain) IBOutlet UILabel *lblstopWatchCaption;


- (IBAction)btnUpPressed;
- (IBAction)btnDownPressed;
- (IBAction)btnNextSongPressed;
- (IBAction)btnPreviouSongPressed;
- (IBAction)btnPlayPressed;
- (IBAction)btnPlusVolumePressed;
- (IBAction)btnMinusVolumePressed;
- (IBAction)btnStartPressed;
- (IBAction)btnLapPressed;
- (IBAction)btnBack:(id)sender;
- (IBAction)btnPlaylist:(id)sender;
- (IBAction)timerSliderValueChanged;
- (IBAction)volumeSliderValueChanged;

- (void)setCurrentItemValue;
- (void)setPlayPauseValue;
- (void)setVoumeValue;
@end
