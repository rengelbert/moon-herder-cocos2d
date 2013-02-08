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

void addStars(void);
@end
/*

 
 virtual void ccTouchesBegan(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 virtual void ccTouchesMoved(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 virtual void ccTouchesEnded(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 void update (float dt);
 
 private:
 
 
 inline bool pointEqualsPoint (CCPoint point1, CCPoint point2) {
 return point1.x == point2.x && point1.y == point2.y;
 }
 
 inline void clearLabels (void) {
 _labelMeridian->setVisible(false);
 _labelGameOver->setVisible(false);
 _labelBestScore->setVisible(false);
 _labelPoundKey->setVisible(false);
 _btnTryAgain->setVisible(false);
 _btnStart->setVisible(false);
 _btnMenu->setVisible(false);
 _scoreLabel->setVisible(false);
 _levelLabel->setVisible(false);
 }
 
 };
 
 #endif // __GameLayer_SCENE_H__
 

 */

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
