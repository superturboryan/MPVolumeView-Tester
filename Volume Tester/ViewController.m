//
//  ViewController.m
//  Volume Tester
//
//  Created by Ryan David Forsyth on 2020-05-08.
//  Copyright © 2020 Ryan David Forsyth. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet MPVolumeView *mpVolumeView;
@property (weak, nonatomic) IBOutlet UILabel *currentVolumeLabel;

@property (strong,nonatomic) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter
     addObserver:self
     selector:@selector(updateVolumeLabel)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    
    [AVAudioSession.sharedInstance setActive:YES error:nil];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.mpVolumeView.backgroundColor = UIColor.clearColor;
    
    self.currentVolumeLabel.text = [NSString stringWithFormat:@"%f", [self currentSystemVolume]];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (IBAction)tappedSetMaxVolume:(id)sender {
    [(UISlider*)self.mpVolumeView.subviews[1] setValue:1];
    [self performSelector:@selector(updateVolumeLabel) withObject:nil afterDelay:0.2];
}

- (IBAction)tappedSetMinVolume:(id)sender {
    [(UISlider*)self.mpVolumeView.subviews[1] setValue:0];
    [self performSelector:@selector(updateVolumeLabel) withObject:nil afterDelay:0.2];
}

- (IBAction)tappedPlaySound:(id)sender {
    NSURL *soundFileURL = [NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"meow" ofType:@"mp3"]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                   error:nil];
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    
    self.player.volume = [self currentSystemVolume];
    
    [self.player play];
}

-(void)updateVolumeLabel {
    self.currentVolumeLabel.text = [NSString stringWithFormat:@"%.0f%@", [self currentSystemVolume], @"%"];
}

-(float)currentSystemVolume {
    return AVAudioSession.sharedInstance.outputVolume * 100;
}


@end
