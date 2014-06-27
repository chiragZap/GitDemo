//
//  PlayListViewController.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate> {
    AppDelegate *appDelegate;
    
}
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIImageView *imgCenter;
@property (nonatomic, retain) IBOutlet UIView *rightView;
@property (nonatomic, retain) IBOutlet UILabel *lblNoData;
@property (nonatomic) BOOL isFromFav;


-(IBAction)btnBack:(id)sender;
-(IBAction)btnClearAllPressed;

@end
