//
//  Line.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//
//

#import "Line.h"
#import "Moon.h"
#import "GameConfig.h"
#import "GameManager.h"

@implementation Line

@synthesize active = _active, trashme = _trashme, hit = _hit, length = _length, 
blinkState = _blinkState, curveState = _curveState, start = _start, end = _end,
curve = _curve,  collisionPoint = _collisionPoint;


+(Line *) create {
	Line * line = [[[Line alloc] init] autorelease];
	return line;
}


-(void) update:(float) dt {
	if (!_active || _trashme) return;
	
    //count active time
	_activeInterval += dt;
	if (_hit) {
		//animate curve if line is hit
		_curveInterval += dt;

		if (_curveInterval > LINE_CURVE_INTERVAL) {
			_curveInterval = 0;
			_curveState = (_curveState == 0) ? 1 : 0;
		}
		
	} else {
		//if not hit, and at 75% active time, start blinking the line
		if (_activeInterval > LINE_TIME_ACTIVE * 0.75f) {
           _blinking = YES;
		}
	}
	
	//destroy line if past its active time
	if (_activeInterval > LINE_TIME_ACTIVE) {
		_active = NO;
		_trashme = YES;
		return;
	}
	
	if (_blinking) {
		_blinkInterval += dt;
		//blink
		if (_blinkInterval > LINE_BLINK_INTERVAL) {
            _blinkInterval = 0;
			_blinkState = (_blinkState == 0) ? 1 : 0;
		}
		
	}
}


-(void) setValues:(CGPoint) start end:(CGPoint) end{
	if (start.x <= end.x) {
		_start = start;
		_end = end;
	} else {
		_start = end;
		_end = start;
	}
	
	_curve = ccp(0,0);
    
	_active = YES;
	_trashme = NO;
	_hit = NO;
	
	//these are used as timers for blinking time, active time, curve animation
	_blinkInterval = 0;
	_activeInterval = 0;
	_curveInterval = 0;
	_blinking = NO;
	_blinkState = 0;
	_curveState = 0;

	[self calculateLineData];
}


-(BOOL) collidesWithMoon:(Moon *) moon {
    
	//line can only collide once
	if (_hit)
	{
		return NO;
	}
	
	//if within range of line segment
	float r = [self rangeWithMoon:moon];
	
	if (r < 0 || r > 1)  return NO;
	
	CGPoint normal = [self getNormalForMoon:moon];
	float t = [self moonProjectionOfMoon:moon onNormal:normal];
	
	if (t > 0 && t < 1) {
        
        //get moon's vector
        float moonDiffX = moon.nextPosition.x - moon.position.x;
		float moonDiffY = moon.nextPosition.y - moon.position.y;
        
        if (moonDiffX * normal.x + moonDiffY * normal.y > 0) return NO;
        
		//collision!!!!
		_hit = YES;
		_blinking = true;
		if (_activeInterval < LINE_TIME_ACTIVE * LINE_TIME_CURVING) _activeInterval = LINE_TIME_ACTIVE * LINE_TIME_CURVING;
		
        float bounce = LINE_BOUNCE / CC_CONTENT_SCALE_FACTOR();
        moon.vector = ccp( bounce * _length * normal.x,
                           bounce * _length * normal.y);
		
		_collisionPoint = ccp(moon.position.x + t * moonDiffX,
                              moon.position.y + t * moonDiffY);
		_curve = _collisionPoint;
		
		_curve.x -= LINE_CURVE_AMOUNT *  normal.x;
		_curve.y -= LINE_CURVE_AMOUNT *  normal.y;
        
		_curveState = 1;
        
		return YES;
	}
	
	return NO;
}

-(float) rangeWithMoon:(Moon *) moon {
	float moonToStartX = moon.position.x - _start.x;
	float moonToStartY = moon.position.y - _start.y;
    
	//get dot product of this line's vector and moonToStart vector
	float dot = moonToStartX * _vectorX + moonToStartY * _vectorY;
	//solve it to the segment
	return dot/_lenSquared;;
}

-(CGPoint) getNormalForMoon:(Moon *) moon {
	float lineStartToMoonX = moon.position.x - _start.x;
	float lineStartToMoonY = moon.position.y - _start.y;
	
	//check dot product value to grab correct normal
	float leftNormal = lineStartToMoonX * _normalLeft.x + lineStartToMoonY * _normalLeft.y;
	CGPoint normal;
	
	if (leftNormal > 0) {
		normal = _normalLeft;
	} else {
		normal = _normalRight;
	}
	return normal;
}

-(float) moonProjectionOfMoon:(Moon *) moon onNormal:(CGPoint) normal {
	
	float lineStartToMoonNowX = moon.position.x - _start.x;
	float lineStartToMoonNowY = moon.position.y - _start.y;
	
	float lineStartToMoonnextPositionX = moon.nextPosition.x - _start.x;
	float lineStartToMoonnextPositionY = moon.nextPosition.y - _start.y;
	
	//check dot product value to grab correct normal
	float distanceToLineNow = lineStartToMoonNowX * normal.x + lineStartToMoonNowY * normal.y;
	float distanceToLineNext = lineStartToMoonnextPositionX * normal.x + lineStartToMoonnextPositionY * normal.y;
	
	return (moon.radius - distanceToLineNow) / (distanceToLineNext - distanceToLineNow);
	
}

-(void) calculateLineData {
	
    _length = ccpDistance(_start,_end);
    //line vector
    _vectorX = _end.x - _start.x;
	_vectorY = _end.y - _start.y;
	//squared length
	_lenSquared = _vectorX * _vectorX + _vectorY * _vectorY;
	
	//_normalAngle = atan2(_vectorY, -_vectorX);
    //_normalCos = cosf(_normalAngle);
    //_normalSin = sinf(_normalAngle);
	
	float normalX = _vectorY;
	float normalY = -_vectorX;
	
	float normalLength = sqrt(normalX * normalX + normalY * normalY);
	//normalized normals
	_normalLeft = ccp(normalX / normalLength, normalY / normalLength);
	_normalRight = ccp( -1*_normalLeft.x, -1*_normalLeft.y);
	
}
@end

