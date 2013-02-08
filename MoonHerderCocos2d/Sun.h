//
//  Sun.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameSprite.h"

@class GameManager;
@class Moon;

@interface Sun : GameSprite {

	CCSpriteFrame *_frame1;
	CCSpriteFrame *_frame2;
    GameManager * _manager;
    
	float _friction;
	int _sunPosY;
	
	BOOL _hasRisen;
	BOOL _hasGrown;
}

@property BOOL hasRisen;
@property BOOL hasGrown;

+(Sun *) create;
-(id) init;
-(void) highNoon;
-(BOOL) checkCollisionWithMoon:(Moon *) moon;

@end

