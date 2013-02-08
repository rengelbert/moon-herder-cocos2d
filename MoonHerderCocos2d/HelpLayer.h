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
    
}


+(CCScene *) scene;

@end

/*
 #ifndef __MoonHerderCpp__HelpLayer__
 #define __MoonHerderCpp__HelpLayer__
 
 #include "GameManager.h"
 #include "DrawLayer.h"
 
 class HelpLayer : public cocos2d::CCLayer
 {
 public:
 
 ~HelpLayer();
 HelpLayer();
 
 static HelpLayer * create();
 static cocos2d::CCScene* scene();
 
 virtual void ccTouchesBegan(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 virtual void ccTouchesMoved(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 virtual void ccTouchesEnded(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
 void update (float dt);
 
 private:
 
 CCSpriteBatchNode * _gameBatchNode;
 CCLabelTTF * _tutorialLabel;
 
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
 
 CCSize _screenSize;
 CCPoint _moonStartPoint;
 
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
 
 void initHelp();
 void createHelpScreen();
 void clearStarAt(CCPoint point);
 
 inline bool pointEqualsPoint (CCPoint point1, CCPoint point2) {
 return point1.x == point2.x && point1.y == point2.y;
 }
 
 };

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
