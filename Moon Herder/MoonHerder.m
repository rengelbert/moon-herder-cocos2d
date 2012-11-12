//
//  MoonHerder
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright DoneWithComputers 2012. All rights reserved.
//


// Import the interfaces
#import "MoonHerder.h"
#import "MoonHerderGame.h"



// HelloWorldLayer implementation
@implementation MoonHerder

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MoonHerder *layer = [MoonHerder node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        MoonHerderGame * game = [[[MoonHerderGame alloc] initWithWidth:size.width withHeight:size.height] autorelease];
        
        [self addChild:game];
        
    }
	return self;
}

    
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
