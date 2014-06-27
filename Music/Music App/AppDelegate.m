//
//  AppDelegate.m
//  Music App
//
//  Created by ZAPMAC3 on 23/05/14.
//  Copyright (c) 2014 Zaptech Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CountDownViewController.h"

@implementation MPMediaPlaylist (Properties)

- (NSTimeInterval)duration {
	 NSTimeInterval interval = -1;
	
	if(interval == -1) {
		interval = 0;
		
		for(MPMediaItem *item in [self items]) {
			interval += [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] intValue];
		}
	}
    return interval;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HomeViewController *viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navControlelr = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = self.navControlelr;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
        NSArray *arr = [[NSArray alloc] init];
        [arr writeToFile:[self filePath] atomically:YES];
    }
    
    self.arrFav = [[NSMutableArray alloc] init];
    [self.arrFav addObjectsFromArray:[NSArray arrayWithContentsOfFile:[self filePath]]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.selectedPlayList = nil;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_volumeDidChanged)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: nil];
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    return YES;
}

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSString *)filePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:FILE_NAME];
}

#pragma mark - Player 
- (void)playPlayListByID:(NSString *)playListID at:(NSInteger)index {
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    self.selectedPlayListID = playListID;
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:playListID
                                                                           forProperty:MPMediaPlaylistPropertyPersistentID];
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    [query addFilterPredicate:predicate];
    if([[query collections] count]) {
        [self.musicPlayer endGeneratingPlaybackNotifications];
        self.selectedPlayList = [[query collections] objectAtIndex:0];
        
        [self.musicPlayer setQueueWithItemCollection:self.selectedPlayList];
        self.musicPlayer.nowPlayingItem = [self.selectedPlayList.items objectAtIndex:index];
        
        self.playlistTotalTime = [self.selectedPlayList duration];
        
         [self.musicPlayer beginGeneratingPlaybackNotifications];
        
    }
}

- (void)play1PlayListByID:(NSString *)playListID at:(NSInteger)index {
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    self.selectedPlayListID = playListID;
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:playListID
                                                                           forProperty:MPMediaPlaylistPropertyPersistentID];
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    [query addFilterPredicate:predicate];
    if([[query collections] count]) {
        [self.musicPlayer endGeneratingPlaybackNotifications];
        self.selectedPlayList = [[query collections] objectAtIndex:0];
                [self.musicPlayer pause];
        [self.musicPlayer setQueueWithItemCollection:self.selectedPlayList];
        self.musicPlayer.nowPlayingItem = [self.selectedPlayList.items objectAtIndex:index];
        self.playlistTotalTime = [self.selectedPlayList duration];
        [self.musicPlayer play];
        [self performSelector:@selector(methodFired) withObject:nil afterDelay:5.0];
        
    }
}

- (void)methodFired {
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    if([self.navControlelr.visibleViewController isKindOfClass:[CountDownViewController class]]) {
        CountDownViewController *controller = (CountDownViewController *)self.navControlelr.visibleViewController;
        [controller performSelector:@selector(setPlayPauseValue)];
    }
    
}

- (void)handle_NowPlayingItemChanged {
    if(self.musicPlayer.playbackState == MPMusicPlaybackStateStopped && self.selectedPlayList != nil) {
        NSUInteger index = [self.arrFav indexOfObject:self.selectedPlayListID];
        if(index < [self.arrFav count]-1) { // There is next playlist
            NSString *nextPlaylistID = [self.arrFav objectAtIndex:index+1];
            [self play1PlayListByID:nextPlaylistID at:0];
        }
        else {
            self.selectedPlayList = nil;
        }
    }
    
    if([self.navControlelr.visibleViewController isKindOfClass:[CountDownViewController class]]) {
        CountDownViewController *controller = (CountDownViewController *)self.navControlelr.visibleViewController;
        [controller performSelector:@selector(setCurrentItemValue)];
    }
    else if([self.navControlelr.visibleViewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *controller = (HomeViewController *)self.navControlelr.visibleViewController;
        [controller performSelector:@selector(setPlayListInfo)];
    }
}

- (void)handle_PlaybackStateChanged {
    
    if([self.navControlelr.visibleViewController isKindOfClass:[CountDownViewController class]]) {
        CountDownViewController *controller = (CountDownViewController *)self.navControlelr.visibleViewController;
        [controller performSelector:@selector(setPlayPauseValue)];
    }
}

- (void)handle_volumeDidChanged {
    if([self.navControlelr.visibleViewController isKindOfClass:[CountDownViewController class]]) {
        CountDownViewController *controller = (CountDownViewController *)self.navControlelr.visibleViewController;
        [controller performSelector:@selector(setVoumeValue)];
    }
}

@end