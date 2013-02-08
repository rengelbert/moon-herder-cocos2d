//
//  Line.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//
//

#import "GameConfig.h"

@class Moon;
@class GameManager;

@interface Line : NSObject {
    
    GameManager * _manager;

	BOOL _active;
	BOOL _trashme;
	BOOL _hit;
	float _length;
	int _blinkState;
	int _curveState;
	CGPoint _start;
	CGPoint _end;
	CGPoint _curve;
	CGPoint _collisionPoint;
	
	float _blinkInterval;
	float _activeInterval;
	float _curveInterval;
	float _vectorX;
	float _vectorY;
	float _normalAngle;
	float _normalCos;
	float _normalSin;
	float _lenSquared;
	
	CGPoint _normalLeft;
	CGPoint _normalRight;
	
	bool _blinking;
}

@property BOOL active;
@property BOOL trashme;
@property BOOL hit;
@property float length;
@property int blinkState;
@property int curveState;
@property CGPoint start;
@property CGPoint end;
@property CGPoint curve;
@property CGPoint collisionPoint;

+(Line *) create;
-(void) update:(float) dt;
-(void) setValues:(CGPoint) start end:(CGPoint) end;
-(BOOL) collidesWithMoon:(Moon *) moon;
-(float) rangeWithMoon:(Moon *) moon;
-(CGPoint) getNormalForMoon:(Moon *) moon;
-(float) moonProjectionOfMoon:(Moon *) moon normal:(CGPoint) normal;
-(void) calculateLineData;

@end

