//
//  GameLayer.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//
#import "GameManager.h"
#import "DrawLayer.h"


@interface GameLayer : CCLayer {
	CCSpriteBatchNode * _gameBatchNode;
	CCSprite * _moonPerch;
	CCSprite * _bgDark;
	CCSprite * _bgLight;
	
	CCSprite * _labelMeridian;
	CCSprite * _labelGameOver;
	CCSprite * _labelBestScore;
	CCSprite * _labelPoundKey;
	CCSprite * _btnTryAgain;
	CCSprite * _btnStart;
	CCSprite * _btnMenu;
	
	GameManager * _manager;
	Moon * _moon;
	Sun * _sun;
	DrawLayer *_drawLayer;
	CCLayer * _particlesLayer;
	CCParticleSystem * _boostHitParticles;
	CCParticleSystem * _lineHitParticles;
	CCParticleSystem * _groundHitParticles;
	CCParticleSystem * _starHitParticles;
	
	CCLabelBMFont * _scoreLabel;
	CCLabelBMFont * _levelLabel;
	
	CGSize _screenSize;
	CGPoint _moonStartPoint;
	
	bool _starsCollected;
	bool _sunRise;
	bool _running;
	
	int _gameState;
	int _numStars;
	int _starsUpdateIndex;
	int _starsUpdateRange;
	int _starsUpdateInterval;
	float _starsUpdateTimer;
}

+(GameLayer *) create;
+(CCScene *) scene;

-(id) initGame;

-(void) createGameScreen;
-(void) newLevel;
-(void) gameOver;
-(void) reset;
-(void) clearStarAt:(CGPoint) point;
-(void) addStars;
@end
