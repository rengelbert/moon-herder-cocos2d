//
//  MovingSprite.m
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
	
#import "MovingSprite.h"

// MovingSprite implementation
@implementation MovingSprite

@synthesize vx = _vx, vy = _vy, nextX = _nextX, nextY = _nextY, speed = _speed;


- (void) dealloc {
	
	[super dealloc];
}

-(void) place {
    [self placeAtX:_nextX atY:_nextY];
}

-(void) placeAtX:(float) x atY:(float) y {
	[super placeAtX:x atY:y];
    _nextX = x;
    _nextY = y;
}
-(void) placeAtX:(float) x {
    [super placeAtX:x];
     _nextX = x;
}

-(void) placeAtY:(float) y {
    [super placeAtY:y];
    _nextY = y;
}

-(void) update:(float) dt {
	_nextX = _skin.position.x + _vx;
	_nextY = _skin.position.y + _vy;
}

-(void) reset {
	_vx = _vy = 0;
	_nextX = _skin.position.x;
	_nextY = _skin.position.y;
    _active = YES;
}

@end	

		
		