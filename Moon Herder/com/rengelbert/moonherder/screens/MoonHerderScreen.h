//
//  MoonHerderScreen.h
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "GameHeaders.h"

enum {
    Z_STARS = 1,
    Z_MOON = 2,
    Z_SUN = 3,
    Z_GROUND = 4
};

@class Line;
@class PowerBar;
@class TimeBar;

static const int TILE_SIZE = 16;

@interface MoonHerderScreen : Screen {

	CGPoint _startPoint;

    NSMutableArray *_lines;
	PowerBar * _powerBar;
	TimeBar * _timeBar;
    
	CCSpriteBatchNode * _sprites;
    CCSpriteBatchNode * _menu;
    
    CCSprite *_bgDark;
    CCSprite *_bgLight;
    CCSprite *_ground;
    
	BOOL _run;
	int _cols;
	int _rows;
	int _tile_size;
    int _numStars;
    int _gameRate;
    
    int _starsUpdateIndex;
    int _starsUpdateRange;
    int _starsUpdateInterval;
    float _starsUpdateTimer;
}

@property CGPoint startPoint;
@property (readonly) NSMutableArray * lines;
@property (readonly) PowerBar * powerBar;
@property (readonly) TimeBar * timeBar;

+(NSMutableArray *) gridCells;
+(NSMutableArray *) stars;

-(id) initWithGame:(Game *) game;
-(void) initScreen;
-(void) blinkStars:(float) dt;
-(void) addStars;
-(void) clearAllStars;

@end	
	
	