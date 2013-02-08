//
//  HelpLayer.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//
#include "GameManager.h"
#include "DrawLayer.h"

@interface HelpLayer : CCLayer {
    CCSpriteBatchNode * _gameBatchNode;
	CCSprite * _moonPerch;
	CCSprite * _bgDark;
	CCSprite * _bgLight;
		
	GameManager * _manager;
	Moon * _moon;
	Sun * _sun;
	DrawLayer *_drawLayer;
	CCLayer * _particlesLayer;
	CCParticleSystem * _boostHitParticles;
	CCParticleSystem * _lineHitParticles;
	CCParticleSystem * _groundHitParticles;
	CCParticleSystem * _starHitParticles;
	
	CCLabelTTF * _tutorialLabel;
	
	CGSize _screenSize;
	CGPoint _moonStartPoint;
	
	bool _starsCollected;
	bool _sunRise;
	bool _running;
    bool _energyMsgShown;
    bool _timeMsgShown;
    bool _tutorialDone;
	
	int _gameState;
	int _numStars;
	int _starsUpdateIndex;
	int _starsUpdateRange;
	int _starsUpdateInterval;
	float _starsUpdateTimer;
    
    float _labelTimer;
    int _labelInterval;
}

+(HelpLayer *) create;
+(CCScene *) scene;

-(id) initHelp;

-(void) createHelpScreen;
-(void) clearStarAt:(CGPoint) point;

@end
