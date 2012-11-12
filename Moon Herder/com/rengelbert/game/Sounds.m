//
//  Sounds.m
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "Sounds.h"

// Sounds implementation
@implementation Sounds

@synthesize audioEngineState = _audioEngineState;

- (void) dealloc {

	[super dealloc];
}


-(id) init {
	self = [super init];

	if(self != nil) {
		_soundsLoaded = 0;
        _loaded = NO;
        
        //preload sounds
		if ([CDAudioManager sharedManagerState] != kAMStateInitialised) {
			NSInvocationOperation* bufferLoadOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadSoundBuffers:) object:nil] autorelease];
			NSOperationQueue *opQ = [[[NSOperationQueue alloc] init] autorelease];
			[opQ addOperation:bufferLoadOp];
			_audioEngineState = kAudioStateAudioManagerInitialising;
		} else {
			[self loadSoundBuffers:nil];
			_audioEngineState = kAudioStateSoundBuffersLoading;
		}
	}
	
	return self;
}

-(void) play:(int) type{}
-(void) loadSoundBuffers:(NSObject*) data {}
-(void) stopBGMusic {
    [_audioEngine stopBackgroundMusic];
}
@end	
	
	