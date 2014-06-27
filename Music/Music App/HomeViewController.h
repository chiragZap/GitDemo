//
//  HomeViewController.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController {
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) IBOutlet UILabel *lblPlayListName;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UIButton *btnGO;
@property (nonatomic, retain) IBOutlet UIImageView *imgLogo;
@property (nonatomic, retain) IBOutlet UIView *innerView;

- (IBAction)btnFavroitePressed;
- (IBAction)btnSettingsPressed;
- (IBAction)btnAboutUSPressed;
- (IBAction)btnAddPlayListPressed;
- (IBAction)btnGOPressed;
- (void)setPlayListInfo;
@end
