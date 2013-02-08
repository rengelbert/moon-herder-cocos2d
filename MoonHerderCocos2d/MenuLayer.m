//
//  MenuLayer.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "HelpLayer.h"


@implementation MenuLayer

+(MenuLayer *) create {
	
	MenuLayer * layer = [[[MenuLayer alloc] initMenu] autorelease];
	return layer;
}

-(id) initMenu {
	self  = [super init];
	if (self) {
		_screenSize = [[CCDirector sharedDirector] winSize];
        
        _manager = [GameManager sharedGameManager];
        _starsUpdateIndex = 0;
        _starsUpdateRange = 10;
        _starsUpdateInterval = 5;
        _starsUpdateTimer = 0.0;
        
        
        [self createScreen];
        [self setIsTouchEnabled:YES];
        [self scheduleUpdate];
    
	}
	return self;
}


-(void) update:(float) dt {

    dt *= CC_CONTENT_SCALE_FACTOR();
    
	_starsUpdateTimer += dt;
    
	int stars_count = 150;
	if (_starsUpdateTimer > _starsUpdateInterval) {
		
		if (stars_count - _starsUpdateIndex < _starsUpdateRange) {
			_starsUpdateIndex = 0;
		} else if (_starsUpdateIndex + _starsUpdateRange > stars_count - 1) {
			_starsUpdateIndex += stars_count - _starsUpdateIndex - 1;
		} else {
			_starsUpdateIndex += _starsUpdateRange;
		}
		
		_starsUpdateTimer = 0;
		_starsUpdateInterval = ((float)rand() / RAND_MAX) * 5;
	}
	
	//update stars within update range
	Star * star;
	for (int i = _starsUpdateIndex; i < _starsUpdateIndex + _starsUpdateRange; i++) {
		if (i < stars_count) {
			CGPoint point = [_manager starPosition:i];
			int index = point.y * _manager.columns + point.x;
			if (index >= STARS_IN_POOL) index = STARS_IN_POOL - 1;
			
			//identify cell in array
			star = [_manager starFromPool:index];
			if (star.visible && !star.isBoost) [star update:dt * DT_RATE ];
		}
		
	}
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event {
    
    UITouch * touch = [touches anyObject];
    
    
    if (touch) {
	    
	    CGPoint tap = [_manager touchFromLocation:touch];
	    CGRect boundsPlay = _btnPlay.boundingBox;
        CGRect boundsHelp = _btnHelp.boundingBox;
        
        
        if (CGRectContainsPoint(boundsPlay, tap)) {
            CCScene * newScene = [CCTransitionFlipY transitionWithDuration:0.5f scene:[GameLayer scene] orientation:kOrientationUpOver];
            [[CCDirector sharedDirector] replaceScene:newScene];
            
        } else if (CGRectContainsPoint(boundsHelp, tap)) {
            /*CCScene * newScene = [CCTransitionFlipY transitionWithDuration:0.5f scene:[HelpLayer scene] orientation:kOrientationUpOver];
            [[CCDirector sharedDirector] replaceScene:newScene];
            */
        }
	}
}




-(void) createScreen {
	
    CCSprite * bg;
    if (_screenSize.height == 568) {
        bg = [CCSprite spriteWithFile:@"bg_dark-568h.jpg"];
    } else {
        bg = [CCSprite spriteWithFile:@"bg_dark.jpg"];
    }
    
    [bg setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.5f)];
    [self addChild:bg z:kBackground];
    
    _gameBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sprite_sheet.png" capacity:800];
    [self addChild:_gameBatchNode z:kMiddleground];
        
    CCSprite * ground = [CCSprite spriteWithSpriteFrameName:@"ground.png"];
    [ground setAnchorPoint:ccp(0,0)];
    [_gameBatchNode addChild:ground z:kForeground];
    
    //add moon
    CCSprite * moon = [CCSprite spriteWithSpriteFrameName:@"intro_moon.png"];
    [moon setPosition:ccp(_screenSize.width * 0.25f, _screenSize.height * 0.8f)];
    [_gameBatchNode addChild:moon z:kForeground];
    
    
    //add logo
    CCSprite * logo = [CCSprite spriteWithSpriteFrameName:@"label_logo.png"];
    [logo setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.55f)];
    [_gameBatchNode addChild:logo  z:kForeground];
    

    //add play button
    _btnPlay = [CCSprite spriteWithSpriteFrameName:@"label_play.png"];
    [_btnPlay setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.3f)];
    [_gameBatchNode addChild:_btnPlay  z:kForeground];
    
    _btnHelp = [CCSprite spriteWithSpriteFrameName:@"label_tutorial.png"];
    [_btnHelp setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.2f)];
    [_gameBatchNode addChild:_btnHelp z:kForeground];
    
    
    //add best score number
    int bestScore = _manager.bestScore;
    
    if (bestScore > 1) {
        NSString * score = [NSString stringWithFormat:@"Best Score: %i stars", bestScore];
        
        CCLabelBMFont * scoreLabel = [CCLabelBMFont labelWithString:score fntFile:@"font_score.fnt" width:_screenSize.width * 0.8f alignment:kCCTextAlignmentCenter];
        
        [scoreLabel setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.4f)];
        [self addChild:scoreLabel z:kForeground];
    }
    
    
   
    //add stars
    Star * star;
    //number of stars and boosts to add to this level
    int numStars = 150;
    
    int cnt = 0;
    int i = 0;
    
    int index;
    CGPoint starPosition;
    CGPoint position;
    
    while (cnt < numStars) {
        
        
        starPosition = [_manager starPosition:i];
        i++;
        
        //grab stars array index based on selected Grid Cell
        index = starPosition.y * _manager.columns + starPosition.x;
        
        if (index >= STARS_IN_POOL) {
            continue;
        }
    
        //grab position from selected Grid Cell
        position.x = (int) (starPosition.x * TILE * CC_CONTENT_SCALE_FACTOR());
        position.y = (int) (_screenSize.height - starPosition.y * TILE * CC_CONTENT_SCALE_FACTOR());
        
        
        //
        //don't use cells too close to moon perch
        
        if (fabs(position.x  - moon.position.x) < moon.boundingBox.size.width * 0.4f &&
            fabs(position.y - moon.position.y) < moon.boundingBox.size.width * 0.4f) {
            continue;
        }
        
        //CCLOG(@"POSITION X: %f,  Y: %f", position.x, position.y);
        
        //grab star from pool
        star = (Star *) [_manager starFromPool:index];
        if (star.parent) [star removeFromParentAndCleanup:NO];
        [star setValues:position boost:NO];
        star.opacity = 200;
        
        [_gameBatchNode addChild:star z:kMiddleground];
        star.visible = YES;
        
        cnt++;
    }
     
     
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// add layer as a child to scene
	[scene addChild: [MenuLayer create]];
	
	// return the scene
	return scene;
}

@end

