//
//  DrawLayer.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "DrawLayer.h"


@implementation DrawLayer


@synthesize length = _length, startPoint = _startPoint, touchPoint = _touchPoint;

+(DrawLayer *) create {
	DrawLayer * layer = [[[DrawLayer alloc] init] autorelease];
	return layer;
}

-(id) init {
	self = [super init];
	if (self) {
		
        _manager = [GameManager sharedGameManager];
        _screenSize = [[CCDirector sharedDirector] winSize];

		glLineWidth(LINE_THICKNESS * _manager.gameScale);
 
		//_blinking = false;
		_blinkTimer = 0;
		_blinkCount = 0;
		_blinkStateTime = 0;
		_blinkStateEnergy = 0;
		_startPoint = ccp(0,0);
	}
	return self;

}

-(void) draw {

	[super draw];
	
	glLineWidth(LINE_THICKNESS  * _manager.gameScale);
	//draw lines
	CCArray * lines = _manager.lines;
	
	int numLines = lines.count;
    Line * line;
    for (int i = numLines - 1; i >= 0; i--) {
        line = (Line *) [lines objectAtIndex:i];
        [self drawLine:line];
    }
    
    _blinkTimer++;
    
    if (_blinkTimer > 10) {
        if (_blinkStateTime == 0) {
            _blinkStateTime = 1;
        } else {
            _blinkStateTime = 0;
        }
        if (_blinkStateEnergy == 0) {
            _blinkStateEnergy = 1;
        } else {
            _blinkStateEnergy = 0;
        }
        _blinkTimer = 0;
        _blinkCount++;
        if (_blinkCount > 5) {
            _blinkStateTime = 0;
            _blinkCount = 6;
        }
    }
	//draw temp line if any
    if (!CGPointEqualToPoint(_startPoint, CGPointZero) &&
        !CGPointEqualToPoint(_touchPoint, CGPointZero)) {
        ccDrawColor4F(0.0, 0.0, 0.0, 1.0);
        
        ccDrawCircle(_startPoint, 5 * _manager.gameScale, CC_DEGREES_TO_RADIANS(360), 10, false);
        
        ccDrawCircle(_touchPoint, 5 * _manager.gameScale, CC_DEGREES_TO_RADIANS(360), 10, false);
            
        ccDrawLine(_startPoint, _touchPoint);
        
    }
	
	glLineWidth(BAR_THICKNESS * _manager.gameScale);

	//draw time bar
	[self drawBar:HORIZONTAL];
	
	//draw power bar
	[self drawBar:VERTICAL];
}

-(void) setBlinking:(BOOL) var {
	if (var) {
		_blinkCount = 0;
		_blinkStateTime = 0;
	}
}


-(void) drawBar:(int) orientation {
	float barX;
	float barY;
	
	if (orientation == HORIZONTAL) {
        //draw time bar
        if (_manager.time == 0.0) return;
        
        float totalWidth = _screenSize.width * 0.8f;
        barX = _screenSize.width * 0.1f;
        barY = _screenSize.height * 0.03f;
        
        if (_manager.time != 1) {
        	ccDrawColor4F(0.0, 0.0, 0.0, 1.0);
        	ccDrawLine(ccp(barX,barY),
        			   ccp(barX + totalWidth, barY));
        }
        
        ccDrawColor4F(0.0, 1.0, 1.0, 1.0);
        ccDrawLine(ccp(barX, barY), ccp(barX + totalWidth * _manager.time, barY));
        
    } else {
        //draw energy bar
        float totalHeight = _screenSize.height * 0.8f;
        barX = _screenSize.width * 0.96f;
        barY = _screenSize.height * 0.1f;
        
        if (_manager.lineEnergy != 1) {
            if (_blinkStateTime == 0) {
                ccDrawColor4F(0.0, 0.0, 0.0, 1.0);
            } else {
                ccDrawColor4F(1.0, 0.0, 0.0, 1.0);
            }
            ccDrawLine(ccp(barX, barY), ccp(barX, barY + totalHeight));
        }
        
        if (_manager.lineEnergy <= 0) return;
        
        if (_manager.boosting) {
            if (_blinkStateEnergy == 0) {
                ccDrawColor4F(1.0, 0.9, 0.0, 1.0);
            } else {
                ccDrawColor4F(1.0, 0.0, 1.0, 1.0);
            }
        } else {
            ccDrawColor4F(1.0, 0.9, 0.0, 1.0);
        }
        
        ccDrawLine(ccp(barX, barY), ccp(barX, barY + totalHeight * _manager.lineEnergy));
    }

}


-(void) drawLine:(Line *) line {
	if (line.blinkState == 0) {
        ccDrawColor4F(1.0, 0.0, 1.0, 1.0);
    } else {
        ccDrawColor4F(1.0, 1.0, 1.0, 1.0);
    }
    
    //draw curved line
    if (line.curveState != 0 && !CGPointEqualToPoint(line.curve, CGPointZero)) {
        
        [self drawQuadBezier:line.start
                     control:line.curve
                 destination:line.end
                    segments:10
         
         ];
        
    //draw straight line
    } else {
        ccDrawLine(line.start, line.end);
    }
}


-(void) drawQuadBezier:(CGPoint) origin  control:(CGPoint) control  destination:(CGPoint) destination  segments:(int) segments {
	
	float t = 0.0f;
    float x_;
    float y_;
    
    CGPoint previous = origin;
    for (int i = 0; i < segments + 1; i++) {
        
        x_ = powf(1 - t, 2) * origin.x + 2.0f * (1 - t) * t * control.x + t * t * destination.x;
        y_ = powf(1 - t, 2) * origin.y + 2.0f * (1 - t) * t * control.y + t * t * destination.y;
        
        if (i != 0)

        ccDrawCircle(previous, 2.2  * _manager.gameScale, M_PI, 6, false);
        
        ccDrawLine(previous, ccp (x_, y_) );
        previous = ccp(x_, y_);
        
        t += (float) 1 / segments;
    }

}



@end

