//
//  GameSprite.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameSprite.h"
#import "GameManager.h"


@implementation GameSprite

@synthesize active = _active, trashme = _trashme, hit = _hit, radius = _radius,
squaredRadius = _squaredRadius, vector = _vector, nextPosition = _nextPosition;


-(id) initWithFrameName:(NSString *) frame withRadius:(float) radius {
	self= [super initWithSpriteFrameName:frame];
	if (self != nil) {
		_radius = radius;
		_squaredRadius = _radius * _radius;
		_vector = ccp(0,0);
 		_active = YES;
 		_hit = NO;
 		_trashme = NO;
 		_screenSize = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(void) reset {
	_vector = ccp(0,0);
	_nextPosition = self.position;
	_active = true;
}

-(void) update:(float) dt {
	_nextPosition = ccp(
	self.position.x + _vector.x,
	self.position.y + _vector.y
	);
}

-(void) place {
	[self setPosition:_nextPosition];
}

@end
