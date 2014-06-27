//
//  AppDelegate.h
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#define FILE_NAME @"playlist.plist"

#define APP_URL @"APP_URL"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE


@interface MPMediaPlaylist (Properties)

@property (nonatomic, readonly) NSTimeInterval duration;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *arrFav;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) MPMediaPlaylist *selectedPlayList;
@property (nonatomic, strong) NSString *selectedPlayListID;
@property (nonatomic, strong) UINavigationController *navControlelr;
@property (nonatomic) int playlistTotalTime;
@property (nonatomic) BOOL isUP;
+ (AppDelegate *)sharedDelegate;
- (NSString *)filePath;
- (void)playPlayListByID:(NSString *)playListID at:(NSInteger)index;

@end
