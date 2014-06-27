//
//  HomeViewController.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "HomeViewController.h"
#import "AboutUSViewController.h"
#import "PlayListViewController.h"
#import "SettingsViewController.h"
#import "CountDownViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedDelegate];
    if(!isiPhone5) {
        CGRect frame = self.imgLogo.frame;
        frame.origin.y -= 30;
        self.imgLogo.frame = frame;
        
        frame = self.innerView.frame;
        frame.origin.y -= 20;
        self.innerView.frame = frame;
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self setPlayListInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)setPlayListInfo {
    if(appDelegate.selectedPlayList != nil) {
        self.lblPlayListName.text = [appDelegate.selectedPlayList valueForProperty: MPMediaPlaylistPropertyName];
        if(appDelegate.playlistTotalTime >= 3600) {
            int hours = appDelegate.self.playlistTotalTime / 3600;
            int remaining = appDelegate.self.playlistTotalTime % 3600;
            int minutes = remaining / 60;
            int seconds = remaining % 60;
            self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
        }
        else {
            int minutes = appDelegate.self.playlistTotalTime / 60;
            int seconds = appDelegate.self.playlistTotalTime % 60;
            self.lblTime.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
        }
        [self.btnGO setAdjustsImageWhenHighlighted:YES];
    }
    else {
        self.lblPlayListName.text = @"";
        self.lblTime.text = @"";
        [self.btnGO setAdjustsImageWhenHighlighted:NO];
    }
}

#pragma mark - Button Actions

- (IBAction)btnFavroitePressed {
    PlayListViewController *viewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    viewController.isFromFav = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnSettingsPressed {
    SettingsViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnAboutUSPressed {
    AboutUSViewController *viewController = [[AboutUSViewController alloc] initWithNibName:@"AboutUSViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnAddPlayListPressed {
    PlayListViewController *viewController = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:nil];
    viewController.isFromFav = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnGOPressed {
    if(appDelegate.selectedPlayList != nil) {
        [appDelegate.musicPlayer play];
        CountDownViewController *viewController = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end