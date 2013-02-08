//
//  Sun.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "Sun.h"
#import "Moon.h"
#import "GameManager.h"

@implementation Sun

@synthesize hasRisen = _hasRisen, hasGrown = _hasGrown;

+(Sun *) create {
	Sun * sun = [[[Sun alloc] init] autorelease];
	return sun;	
}

-(id) init {
	self = [super initWithFrameName:@"sun_1.png" withRadius:50  * [GameManager sharedGameManager].gameScale];
	if (self) {
        
        _manager = [GameManager sharedGameManager];
		_frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun_1.png"] ;
        _frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sun_2.png"] ;
    		
		_hasRisen = NO;
		_hasGrown = NO;
		_friction = 0.98f;
		
		_sunPosY = _screenSize.height - 120 * _manager.gameScale;
	 
	}
	return self;
}


-(void) reset {
	//bring values back to small sun
	_radius = 50 * _manager.gameScale;
    _squaredRadius = _radius * _radius;
    [self setDisplayFrame:_frame1];
    _friction = 0.98f;
	_hasGrown = NO;
}

-(void) highNoon {
	//show big sun
	_radius = 64 * _manager.gameScale;
    _squaredRadius = _radius * _radius;
    [self setDisplayFrame:_frame2];

	_friction = 0.9f;
	
	_hasGrown = YES;
}

-(BOOL) checkCollisionWithMoon:(Moon *) moon {
	if (!_hasRisen) return NO;
			
	float diffx = moon.nextPosition.x - _nextPosition.x;
	float diffy = moon.nextPosition.y - _nextPosition.y;
	float distance = (diffx * diffx + diffy * diffy);

	//simple collision check
	if (distance < (moon.radius + _radius) * (moon.radius + _radius)) {
		float angle = atan2(diffy,diffx);
        
        moon.vector = ccp(10 * _manager.gameScale * cos(angle), 10 * _manager.gameScale * sin(angle));

		_vector.x = -1 * moon.vector.x;
		_vector.y = -1 * moon.vector.y;
        
        return YES;
	}
    
    return NO;

}

-(void) update:(float)dt {
    
    //move sun up to final positon; don't check for collision yet
	if (!_hasRisen) {
				
		_vector.y += dt * 0.5f;
		
        if (_nextPosition.y >= _sunPosY) {
			_vector.y = 0;
			_hasRisen = YES;
		} else {
			_nextPosition.y = self.position.y + _vector.y;
		}
		
		
	} else {
		//sun is ready, 
        if (_nextPosition.y < 80 * _manager.gameScale) _vector.y +=  0.2 * _manager.gameScale;
        
		_nextPosition.x = self.position.x + _vector.x * dt;
		_nextPosition.y = self.position.y + _vector.y * dt;
	
		
		//check collision with sides
		if (_nextPosition.x < _radius) {
			_nextPosition.x = _radius ;
			_vector.x *= -1;
		}
		
		if (_nextPosition.x > _screenSize.width - _radius) {
			_nextPosition.x = _screenSize.width - _radius ;
			_vector.x *= -1;
		}
    
        if (_nextPosition.y > _screenSize.height) {
			_nextPosition.y = _screenSize.height;
            _vector.y *= -1;
		}
		
		//rotate sun based either o vector.x or dt 
        if (fabs(_vector.x) > dt) {
            self.rotation += _vector.x * 0.5f;
        } else {
            self.rotation +=  dt;
        }
		
		_vector.x *= _friction;
		_vector.y *= _friction;
	}
}

@end

