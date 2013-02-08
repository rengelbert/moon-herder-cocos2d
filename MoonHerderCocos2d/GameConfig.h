//
//  GameConfig.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//
//

#ifndef MoonHerderCocos2d_GameConfig_h
#define MoonHerderCocos2d_GameConfig_h

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"

enum {
    kGameStatePlay,
    kGameStateNewLevel,
    kGameStateGameOver,
    kGameStateMenu
};

enum {
    kBackground,
    kMiddleground,
    kForeground
};

enum {
	STAR_SIZE_1 = 1,
	STAR_SIZE_2,
	STAR_SIZE_3,
	STAR_SIZE_4
};

enum {
	HORIZONTAL,
	VERTICAL
};


#define DT_RATE 10
#define TILE 16
#define GRAVITY 0.2f
#define TERMINAL_VELOCITY 30.0
#define LINE_TIME_ACTIVE 36
#define LINE_TIME_CURVING 0.85
#define LINE_BLINK_INTERVAL 1.0
#define LINE_CURVE_INTERVAL 1.5
#define LINE_CURVE_AMOUNT 40
#define LINE_BOUNCE 0.2
#define LINE_THICKNESS 6.0
#define BAR_THICKNESS 2.0 
#define STARS_IN_POOL 450

#endif
/*
 
 #import "cocos2d.h"
 @class Game;
 
 @interface GameSprite : NSObject {
 
 CCSprite * _skin;
 
 BOOL _active;
 BOOL _trashMe;
 BOOL _hit;
 
 @protected
 Game * _game;
 }
 
 @property (nonatomic, retain) CCSprite * skin;
 @property BOOL active;
 @property BOOL trashMe;
 @property BOOL hit;
 
 -(id) initWithGame:(Game *) game;
 -(void) reset;
 -(void) destroy;
 -(void) update:(float) dt;
 -(void) placeAtX:(float) x atY:(float) y;
 -(void) placeAtX:(float) x;
 -(void) placeAtY:(float) y;
 
 
 @end
 
 */
