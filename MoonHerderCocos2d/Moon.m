//
//  Moon.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "Moon.h"
#import "GameManager.h"

@implementation Moon

@synthesize isOff = _off;

+(Moon *) create {
	Moon * moon = [[[Moon alloc] init] autorelease];
	return moon;
}

-(id) init {
    
	self = [super initWithFrameName:@"moon.png" withRadius:16  * [GameManager sharedGameManager].gameScale];

	if(self != nil) {
		
		//timer for blinking 
        _blinkInterval = 2;
        _blinkTimer = 0;
        _blinkState = 1;
        _off = NO;
        _manager = [GameManager sharedGameManager];
        
	}
	
	return self;
}
-(void) reset {
    [super reset];
    _off = NO;
    _blinkTimer = 0;
    _blinkState = 1;
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon.png"]];
    
}

-(void) update:(float) dt {
	
    _vector.y -= 0.2f;
    
	[self limitSpeeds];
	
	_nextPosition.x = self.position.x + _vector.x * dt;
	_nextPosition.y = self.position.y + _vector.y * dt;
	
	//if hitting sides of screen
	if (_nextPosition.x < _radius) {
		_nextPosition.x = _radius ;
		_vector.x *= -1.0;
		//I play the same sound as when sun is hit
        [[SimpleAudioEngine sharedEngine] playEffect:@"sun_hit.wav"];
	}
	if (_nextPosition.x > _screenSize.width - _radius) {
		_nextPosition.x = _screenSize.width - _radius ;
		_vector.x *= -1.0;
        [[SimpleAudioEngine sharedEngine] playEffect:@"sun_hit.wav"];
	}
	
	//rotate moon based on vector.x
	self.rotation += _vector.x * 0.08f;
    
    //moon blinks when power is boosting
    if (_manager.boosting) {
        _blinkTimer += dt;
        if (_blinkTimer > _blinkInterval) {
            _blinkTimer = 0;
            
            if (_blinkState == 1) {
                _blinkState = 0;
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon_off.png"]];
            } else {
                _blinkState = 1;
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon.png"]];
            }
        }
    }

    
}

//moon is shown without halo, when power runs out
-(void) turnOnOff:(BOOL) value {
    if (value) {
        _off = NO;
        _blinkState = 1;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon.png"]];
    } else {
        _off = YES;
        _blinkState = 0;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"moon_off.png"]];
    }
}

-(void) limitSpeeds {
	if (_vector.x > TERMINAL_VELOCITY * _manager.gameScale) _vector.x = TERMINAL_VELOCITY * _manager.gameScale;
	if (_vector.x < -TERMINAL_VELOCITY * _manager.gameScale) _vector.x = -TERMINAL_VELOCITY * _manager.gameScale;
	if (_vector.y > TERMINAL_VELOCITY * _manager.gameScale) _vector.y = TERMINAL_VELOCITY * _manager.gameScale;
	if (_vector.y < -TERMINAL_VELOCITY * _manager.gameScale) _vector.y = -TERMINAL_VELOCITY * _manager.gameScale;
}


@end
