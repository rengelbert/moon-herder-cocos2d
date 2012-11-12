//
//  Sounds.h
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import <Foundation/Foundation.h>
#import "Game.h"
#import "SimpleAudioEngine.h"

typedef enum {
	kAudioStateAudioManagerInitialising,	//Audio manager is being initialised
	kAudioStateSoundBuffersLoading,		//Sound buffers are loading
	kAudioStateReady						//Everything is loaded
} tSoundEngineState;


@interface Sounds : NSObject {
    Game * _game;
    NSArray * _sfx;
    NSArray * _bgSound;
    
    int _soundsLoaded;
    BOOL _loaded;
    tSoundEngineState _audioEngineState;
    
    SimpleAudioEngine * _audioEngine;
    
}

@property tSoundEngineState audioEngineState;

-(void) play:(int) type;
-(void) loadSoundBuffers:(NSObject*) data;
-(void) stopBGMusic;
@end	
