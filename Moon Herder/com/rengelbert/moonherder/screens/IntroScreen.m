//
//  IntroScreen.m
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "IntroScreen.h"
#import "MoonHerderData.h"
#import "MoonHerderGame.h"
#import "Star.h"
#import "NumberSprite.h"
#import "NSMutableArray+Shuffle.h"

// IntroScreen implementation
@implementation IntroScreen


-(void) create {
    
    
	if (_container == nil) {
        
        [self initScreen];
      
        [_container addChild:_bgDark];
        [_sprites addChild:_ground];
        
        [_container addChild:_sprites];
        [_container addChild:_menu];
        
         
	} else {
        [_menu removeAllChildrenWithCleanup:NO];
    }
    
    //add moon
    CCSprite * moon = [_game.images getSkin:@"intro_moon.png"];
    [moon setPosition:ccp(80 * _game.screen_ratio, 400 * _game.screen_ratio)];
    
    [_menu addChild:moon];
    //********* INTRO SCREEN ******************
    //add logo
    CCSprite * logo = [_game.images getSkin:@"label_logo.png"];
    [logo setPosition:ccp(_game.screenWidth * 0.5, _game.screenHeight * 0.55)];
    [_menu addChild:logo];
    
    //add play button
    _play = [_game.images getSkin:@"label_play.png"];
    [_play setPosition:ccp(_game.screenWidth * 0.5, _game.screenHeight * 0.3)];
    _tutorial = [_game.images getSkin:@"label_tutorial.png"];
    [_tutorial setPosition:ccp(_game.screenWidth * 0.5, _play.position.y - _play.textureRect.size.height * 2)];
    [_menu addChild:_play];
    [_menu addChild:_tutorial];

    //add best score number
    int bestScore = [_game.gameData getValue:BEST_SCORE];
    
    if (bestScore != 0) {
        //add best score
        CCSprite * best = [_game.images getSkin:@"label_best.png"];
        [best setPosition:ccp(logo.position.x - logo.textureRect.size.width * 0.5f + best.textureRect.size.width * 0.5f,
                              logo.position.y - logo.textureRect.size.height * 0.5f - best.textureRect.size.height)];
        [_menu addChild:best];
        
        NumberSprite * number = [[[NumberSprite alloc] initWithGame:_game withBatch:_menu at:ccp(best.position.x + best.textureRect.size.width * 0.65f, best.position.y) withFrameName:@"numbers_small_"] autorelease];
        [number showValue:bestScore];
        
        CCSprite * stars = [_game.images getSkin:@"label_stars.png"];
        [stars setPosition:ccp(number.x + number.width * 1.2 + stars.textureRect.size.width * 0.5f, number.y)];
        [_menu addChild:stars ];
    }
    

    
    [_game addChild:self];
	[self addStars];
    
    
    _run = YES;
    
}

-(void) processTouchEnd:(CGPoint) touch {
    
    CGRect play = _play.boundingBox;
    CGRect tutorial = _tutorial.boundingBox;
    
    if (CGRectContainsPoint(tutorial, touch)) {
        [_game setScreenWithName:@"HelpScreen"];
    } else  if (CGRectContainsPoint(play, touch)) {
        [_game setScreenWithName:@"GameScreen"];
    }
    
}



@end
