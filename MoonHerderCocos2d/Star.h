//
//  Star.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameSprite.h"


@interface Star : GameSprite {

	CCSpriteFrame *_frame1;
	CCSpriteFrame *_frame2;
	
	float _blinkTimer;
	float _blinkInterval;
	int _frame;
    
    BOOL _boost;
    float _size;
}

@property BOOL isBoost;

+(Star *) create;
-(id) init;
-(void) setValues:(CGPoint) position boost:(BOOL) boost;


@end





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
