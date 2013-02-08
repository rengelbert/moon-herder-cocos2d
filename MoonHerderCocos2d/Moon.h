//
//  Moon.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameSprite.h"

@class GameManager;

@interface Moon : GameSprite {
 	BOOL _off;
	GameManager * _manager;
	
	float _blinkTimer;
	int _blinkInterval;
	int _blinkState;  
}

@property BOOL isOff;

+(Moon *) create;
-(id) init;
-(void) limitSpeeds;
-(void) turnOnOff:(BOOL) value;



@end

