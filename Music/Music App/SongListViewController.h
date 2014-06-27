//
//  SongListViewController.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SongListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    AppDelegate *appDelegate;
    
}
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIButton  *btnCenter;
@property (nonatomic, retain) IBOutlet UIButton  *btnGo;
@property (nonatomic , assign) MPMediaPlaylist *selectedPlayList;
@property (nonatomic) BOOL isFromFav;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnGOPressed;
- (IBAction)btnAddPressed;
@end
