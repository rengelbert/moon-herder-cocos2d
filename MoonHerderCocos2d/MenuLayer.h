//
//  MenuLayer.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameManager.h"

@interface MenuLayer : CCLayer {
    CCSpriteBatchNode * _gameBatchNode;
	
	CCSprite * _btnPlay;
	CCSprite * _btnHelp;
	
	GameManager * _manager;
	
	CGSize _screenSize;
	
	int _starsUpdateIndex;
	int _starsUpdateRange;
	int _starsUpdateInterval;
	float _starsUpdateTimer;
}

+(MenuLayer *) create;
+(CCScene *) scene;

-(id) initMenu;

-(void) createScreen;


@end

