//
//  GameSprite.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameConfig.h"

@interface GameSprite : CCSprite {
	BOOL _active;
	BOOL _trashme;
	BOOL _hit;
	
	float _speed;
	float _radius;
	float _squaredRadius;
	CGPoint _vector;
	CGPoint _nextPosition;
	CGSize _screenSize;
}

@property BOOL active;
@property BOOL trashme;
@property BOOL hit;
@property float radius;
@property float squaredRadius;
@property CGPoint vector;
@property CGPoint nextPosition;

-(id) initWithFrameName:(NSString *) frame withRadius:(float) radius;

-(void) reset;
-(void) update:(float) dt;
-(void) place;


@end


