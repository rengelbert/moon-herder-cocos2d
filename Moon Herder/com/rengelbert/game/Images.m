//
//  Images.m
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
	
#import "Images.h"

// Images implementation
@implementation Images

@synthesize loaded = _loaded;

- (void) dealloc {
    [super dealloc];
}


-(id) initWithGame:(Game *)game {
	self = [super init];

	if(self != nil) {
		
		_game = game;
        _loaded = NO;
        _imagesLoaded = 0;
	}
	
	return self;
}

-(CCSprite *) getSkin:(NSString *) name {
    return [CCSprite spriteWithSpriteFrameName:name];
}

-(CCTexture2D *) getTexture:(NSString *) name {
    return [[CCTextureCache sharedTextureCache] textureForKey:name];
}

-(CCSpriteFrame *) getSpriteFrame:(NSString *)name  {
    return [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name];
}

-(void) imageLoaded{}
-(void) loadImage{}

@end
	