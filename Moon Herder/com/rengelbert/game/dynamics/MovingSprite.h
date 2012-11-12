//
//  MovingSprite.h
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "GameSprite.h"

@interface MovingSprite : GameSprite {
    float _vx;
    float _vy;
    float _nextX;
    float _nextY;
    float _speed;
}

@property float vx;
@property float vy;
@property float nextX;
@property float nextY;
@property float speed;

-(void) place;

@end	


		