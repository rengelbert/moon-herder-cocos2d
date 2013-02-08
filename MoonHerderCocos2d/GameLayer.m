//
//  GameLayer.m
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameLayer.h"
#import "MenuLayer.h"


@implementation GameLayer

+(GameLayer *) create {
	GameLayer * layer = [[[GameLayer alloc] initGame] autorelease];
	return layer;
}


-(id) initGame {
	self = [super init];
	if (self) {
		_screenSize = [[CCDirector sharedDirector] winSize];
		_manager = [GameManager sharedGameManager];
        [_manager reset];
		
		_starsCollected = NO;
		_sunRise = NO;
		_running = NO;
		
		_moonStartPoint = ccp(TILE * 4 * _manager.gameScale, _screenSize.height - TILE * 4 * _manager.gameScale);
        
		[self createGameScreen];
		
		[self reset];
		_running = YES;
		
		[self setIsTouchEnabled:YES];
		[self scheduleUpdate];
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bg.mp3" loop:YES];

	}
	
	return self;
}

-(void) reset {
	//reset sun
	[_sun setPosition:ccp(_screenSize.width * 0.5f, -_sun.radius)];
	_sun.nextPosition = ccp(_screenSize.width * 0.5f, -_sun.radius);
	
	_sun.visible = NO;
	[_sun reset];
	
	//reset moon and perch
	[_moon setPosition:_moonStartPoint];
	_moon.nextPosition = _moonStartPoint;
	[_moon reset];
	_moonPerch.opacity = 50;
	
	
	//clear all visible stars
	_starsCollected = NO;
	
	_drawLayer.startPoint = ccp(0,0);
	_drawLayer.touchPoint = ccp(0,0);
	
	_bgDark.opacity = 255;
	_bgLight.opacity = 0;
	_bgDark.visible = YES;
	_bgLight.visible = NO;
	
	_starsUpdateIndex = 0;
	_starsUpdateRange = 10;
	_starsUpdateInterval = 5;
	_starsUpdateTimer = 0.0;
	
	[self addStars];
	_gameState = kGameStatePlay;
}

-(void) update:(float) dt {
	if (_gameState == kGameStatePlay) {
        
		//if running game logic
		if (_running) {
            
            dt *= _manager.gameScale;
            
            [_manager update:dt];
            dt *= DT_RATE;
            
			//update elements
            [_moon update:dt];
            if (_sun.visible) {
                [_sun update:dt];
                if ([_sun checkCollisionWithMoon:_moon]) {
	                [[SimpleAudioEngine sharedEngine] playEffect:@"sun_hit.wav"];
                }
            }
            
			
			//check collision with lines, update, draw
			Line * line;
            int len = _manager.lines.count;
            BOOL collisionDetected = NO;
			
			for (int i = len-1; i >= 0; i--) {
                
				line = (Line *) [_manager.lines objectAtIndex:i];
                
				if (!collisionDetected && line.active) {
					if ([line collidesWithMoon:_moon]) {
						collisionDetected = YES;
                        [[SimpleAudioEngine sharedEngine] playEffect:@"line_hit.wav"];
                        [_lineHitParticles setPosition:line.collisionPoint];
                        [_lineHitParticles resetSystem];
					}
				}
                
				if (line.trashme) {
                    [_manager.lines removeObjectAtIndex:i];
				} else {
                    [line update:dt];
                }
			}
            [_moon place];
            
            //if moon off screen to the top, make screen darker as moons gets farther and farther away
            if (_moon.position.y > _screenSize.height) {
                if (!_sun.visible) {
                    float m_opacity = fabs((255 * (_moon.position.y - _screenSize.height))/_screenSize.height);
                    if (m_opacity > 200) m_opacity = 200;
                    if (!_sun.visible) _bgDark.opacity = 255 - m_opacity;
                }
            } else {
                if (!_sun.visible) {
                    if (_bgDark.opacity != 255) _bgDark.opacity = 255;
                }
            }
        
            
			//track collision with MOON and STAR (usign grid logic)
            float range = _moon.radius;
            float posX = _moon.position.x;
            float posY = _moon.position.y;
            
			//I decided to check 9 cells for precision sake
            [self clearStarAt:ccp(posX, posY)];
            [self clearStarAt:ccp(posX, posY + range)];
            [self clearStarAt:ccp(posX, posY - range)];
            [self clearStarAt:ccp(posX + range, posY)];
            [self clearStarAt:ccp(posX + range, posY + range)];
            [self clearStarAt:ccp(posX + range, posY - range)];
            [self clearStarAt:ccp(posX - range, posY)];
            [self clearStarAt:ccp(posX - range, posY - range)];
            [self clearStarAt:ccp(posX - range, posY + range)];
            
            
            
			//check timer
			if (_manager.time  <= 0.65f && !_sun.visible) {

				[[SimpleAudioEngine sharedEngine] playEffect:@"sun_rise.wav"];
                _sun.visible = YES;
				_sun.hasRisen = NO;
			} else if (_manager.time <= 0.25f && _sun.visible && !_sun.hasGrown) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"sun_grow.wav"];
                [_sun highNoon];
            } else if (_manager.time <= 0.0f) {
                //if you want game over once time runs out.
                //game;
            }
            
            if (_sun.visible) {
                if (!_bgLight.visible) {
                    _bgLight.visible = YES;
                }
                //when sun is added to screen, fade out dark bg
                if (_bgLight.opacity + 5  < 255) {
                    _bgLight.opacity +=  5;
                    _bgDark.opacity -= 5;
                } else {
                    _bgDark.visible = NO;
                    _bgDark.opacity = 255;
                   _bgLight.opacity = 255;
                }
                [_sun place];
			}
            
            //check power
            if (_manager.lineEnergy <= 0) {
                if (!_moon.isOff) {
                    [_moon turnOnOff:NO];
                }
            }
			
			//track collision between Moon and Moon's perch
			if (_starsCollected) {
                if (pow (_moonStartPoint.x - _moon.position.x, 2) +
                    pow (_moonStartPoint.y - _moon.position.y, 2) < _moon.squaredRadius) {
					[_moon setPosition:_moonStartPoint];
                    _moon.nextPosition = _moonStartPoint;
                    _moon.active = NO;
					[self newLevel];					
				}
			}
            
            if (_moon.position.y < _moon.radius && _moon.active ) {
                [_groundHitParticles setPosition:_moon.position];
                [_groundHitParticles resetSystem];
                [[SimpleAudioEngine sharedEngine] playEffect:@"ground_hit.wav"];
                _moon.active = NO;
                [self gameOver];
            }
            
            //make stars blink
            if (!_sun.visible) {
                _starsUpdateTimer += dt;
                int stars_count = _numStars;
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
                        if (star.visible && !star.isBoost) [star update:dt];
                    }
                    
                }
            }
            
		}
	}

}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_gameState != kGameStatePlay) return;
    
    UITouch * touch = [touches anyObject];
    
    if (touch) {
	    CGPoint tap = [_manager touchFromLocation:touch];
        _drawLayer.startPoint = tap;
    } 
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent*)event {
   

    if (_gameState != kGameStatePlay) return;
    
     UITouch * touch = [touches anyObject];
    
    
    if (touch) {
	    
	    CGPoint tap = [_manager touchFromLocation:touch];
        _drawLayer.touchPoint = tap;
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent*)event {
    
    UITouch * touch = [touches anyObject];
    
    
    if (touch) {
	    
	    CGPoint tap = [_manager touchFromLocation:touch];
        
        if (_gameState == kGameStatePlay) {
            
            int line_count = _manager.lines.count;
            
            //don't bother creating new lines if 10 on stage already, or if no power
            if (line_count > 10 || _manager.lineEnergy <= 0) {
                _drawLayer.startPoint = ccp(0,0);
                _drawLayer.touchPoint = ccp(0,0);
                return;
            }
            //don't bother with line if points aren't set on screen
            //and if start and end points are the same
            
            if (!CGPointEqualToPoint(_drawLayer.startPoint, ccp(0,0)) &&
                !CGPointEqualToPoint(_drawLayer.startPoint, tap)) {
                
                Line * line = [_manager lineFromPool];
                [line setValues:_drawLayer.startPoint end:tap];
                
                //check length of the line, if too short, get rid of it
                if (line.length < 40 * _manager.gameScale) {
                    _drawLayer.startPoint = ccp(0,0);
                    _drawLayer.touchPoint = ccp(0,0);
                    return;
                }
                [_manager.lines addObject:line];
                
                if (_manager.boosting) {
                    _manager.boosting = NO;
                    [_moon turnOnOff:_manager.lineEnergy > 0];
                }
                [_drawLayer setBlinking:YES];
                
                 //calculate the energy cost of the created line
                float cost = line.length * _manager.lineDecrement;
                 
                 //if more than one line on screen, then add that to the cost
                if (line_count > 1) cost *= line_count;
                
                 _manager.lineEnergy -= 0.003 * cost;
            }
            _drawLayer.startPoint = ccp(0,0);
            _drawLayer.touchPoint = ccp(0,0);
            
        } else if  (_gameState == kGameStateNewLevel) {
            //if showing New Level message, with TOUCH END, start new level
            
            CGRect bounds = _btnStart.boundingBox;
            if (CGRectContainsPoint(bounds, tap)) {
                [self clearLabels];
                
                [self reset];
            
            }
            
                //if showing Game Over message, with TOUCH END, track buttons
        } else if (_gameState == kGameStateGameOver){
            CGRect try_bounds = _btnTryAgain.boundingBox;
            CGRect menu_bounds = _btnMenu.boundingBox;
            
            if (CGRectContainsPoint(try_bounds, tap)) {
                [self clearLabels];
                [_manager reset];
                [self reset];
                
            } else if (CGRectContainsPoint(menu_bounds, tap)) {
                //clearLabels();
                [self clearLabels];
                //show menu
                CCScene * newScene = [CCTransitionFlipY transitionWithDuration:0.5f scene:[MenuLayer scene] orientation:kOrientationDownOver];
                [[CCDirector sharedDirector] replaceScene:newScene];
            }
        }
    }
}


-(void) newLevel {
	_gameState = kGameStateNewLevel;
    
    [_manager.lines removeAllObjects];
    [_manager setLevel:_manager.level + 1];
    
    
    _labelPoundKey.visible = YES;
    _labelMeridian.visible = YES;
    _btnStart.visible = YES;

    NSString * level = [NSString stringWithFormat:@"%i", _manager.level];
   
    [_levelLabel setString:level];
    _levelLabel.visible = YES;
    
    int totalScore = _manager.totalCollectedStars;
    
    if (totalScore > 1) {
        if (totalScore > _manager.bestScore && totalScore > 1) {
            [_manager setBestScore:totalScore];
            _labelBestScore.visible = YES;
        }
        
        NSString * score = [NSString stringWithFormat:@"score: %i stars", totalScore];

        [_scoreLabel setString:score];
        _scoreLabel.visible = YES;
    }

}


-(void) gameOver {
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    _gameState = kGameStateGameOver;
    [_manager.lines removeAllObjects];

    _labelGameOver.visible = YES;
    _btnTryAgain.visible = YES;
    _btnMenu.visible = YES;
    
    int totalScore = _manager.totalCollectedStars;
    
    if (totalScore > 1) {
        NSString * score = [NSString stringWithFormat:@"score: %i stars", totalScore];
        
        [_scoreLabel setString:score];
        _scoreLabel.visible = YES;
        
        if (totalScore > _manager.bestScore) {
            [_manager setBestScore:totalScore];
            _labelBestScore.visible = YES;
        }
    }
}

-(void) clearStarAt:(CGPoint) point {
	int col = (int) point.x / (TILE * _manager.gameScale);
	int row  = (int) (_screenSize.height - point.y) / (TILE * _manager.gameScale);
    
	if (row < 0 || col < 0 || row >= _manager.rows || col >= _manager.columns ||
        row * _manager.columns + col >= STARS_IN_POOL) {
		return;
	}
    
	//identify cell in array
	Star * star = [_manager starFromPool:row * _manager.columns + col];
    
    if (star.visible) {
        
        float diffx = _moon.position.x - star.position.x;
        float diffy = _moon.position.y - star.position.y;

        
        if ((diffx * diffx + diffy * diffy) <= _moon.squaredRadius) {
            
            int starsCollected = _manager.collectedStars;
            int totalStarsCollected = _manager.totalCollectedStars;
            
            starsCollected++;
            totalStarsCollected++;
            
            _manager.collectedStars = starsCollected;
            _manager.totalCollectedStars = totalStarsCollected;
            
            star.visible = NO;
            
            
            int totalStars = _manager.totalStars;
            
            //did we hit a boost?
            if (star.isBoost) {
                
				[_manager setBoosting:YES];
                
                if (starsCollected != totalStars) {
                    [_boostHitParticles setPosition:star.position];
                    [_boostHitParticles resetSystem];
                }
            }
            
            //if last star on screen, show particles, show Moon Perch...
            if (starsCollected == totalStars) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"last_star_hit.wav"];
                [_starHitParticles setPosition:star.position];
                [_starHitParticles resetSystem];
                _starsCollected = YES;

                if (_sun.visible) {
                    _moonPerch.opacity = 100;
                } else {
                    _moonPerch.opacity = 200;
                }
            } else {
                if (star.isBoost) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"boost_hit.wav"];
                } else {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"star_hit.wav"];
                }
            }
            
        }
	}
}


-(void) addStars {
Star * star;
    //number of stars and boosts to add to this level
    _numStars = _manager.totalStars;
    int numBoosts = _manager.boostNumber;
    

    int cnt = 0;
    int i = 0;

    int index;
    CGPoint starPosition;
    CGPoint position;
    
    
    while (cnt < _numStars) {
        
        starPosition = [_manager starPosition:i];
        i++;
        
        //grab stars array index based on selected Grid Cell
        index = starPosition.y * _manager.columns + starPosition.x;
        
        if (index >= STARS_IN_POOL) {
            continue;
        }
    
        //grab position from selected Grid Cell
        position.x = starPosition.x * TILE * _manager.gameScale; 
        position.y = _screenSize.height - starPosition.y * TILE * _manager.gameScale;
        
        //don't use cells too close to moon perch
        
        if (fabs(position.x  - _moonStartPoint.x) < _moon.radius * 2 &&
            fabs(position.y - _moonStartPoint.y) < _moon.radius * 2) {
            continue;
        }
         
        
        //grab star from pool
        star = (Star *) [_manager starFromPool:index];
        if (star.parent) [star removeFromParentAndCleanup:NO];
        
        
        //add boosts first, if any
        if ( cnt >= _numStars - numBoosts) {
            [star setValues:position boost:YES];
            
        } else {
            [star setValues:position boost:NO];
        }
        
        [_gameBatchNode addChild:star  z:kMiddleground];
        star.visible = YES;
        
        cnt++;
    }

}

-(void) createGameScreen {

    if (_screenSize.height == 568) {
        _bgLight = [CCSprite spriteWithFile:@"bg_light-568h.jpg"];
        _bgDark = [CCSprite spriteWithFile:@"bg_dark-568h.jpg"];
    } else {
        _bgLight = [CCSprite spriteWithFile:@"bg_light.jpg"];
        _bgDark = [CCSprite spriteWithFile:@"bg_dark.jpg"];
    }
    

    [_bgLight setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.5f)];
    [self addChild:_bgLight z:kBackground];
    _bgLight.visible = NO;
    _bgLight.opacity = 0;

    
    [_bgDark setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.5f)];
    [self addChild:_bgDark z:kBackground];
    
    _gameBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"sprite_sheet.png" capacity:800];
    [self addChild:_gameBatchNode z:kMiddleground];
    
    _moonPerch = [CCSprite spriteWithSpriteFrameName:@"moon_perch.png"];
   	[_moonPerch setPosition:_moonStartPoint];
    _moonPerch.opacity = 50;
    [_gameBatchNode addChild:_moonPerch z:kBackground];
    
    CCSprite * ground = [CCSprite spriteWithSpriteFrameName:@"ground.png" ];
    [ground setAnchorPoint:ccp(0,0)];
    [_gameBatchNode addChild:ground z:kForeground];
    
    _moon = [Moon create];
    _moon.position = _moonStartPoint;

    _moon.nextPosition = _moonStartPoint;
    [_gameBatchNode addChild:_moon z:kMiddleground];
    
    _sun = [Sun create];
    [_sun setPosition:ccp(_screenSize.width * 0.5, -_sun.radius)];
    _sun.nextPosition = ccp(_screenSize.width * 0.5, -_sun.radius);
    _sun.visible = NO;
    [_gameBatchNode addChild:_sun z:kMiddleground];
    
    _scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"font_score.fnt" width:_screenSize.width * 0.8f alignment:kCCTextAlignmentCenter];
    
    //CCLabelBMFont::create("", "font_score.fnt", );
    [_scoreLabel setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.48f)];
    [self addChild:_scoreLabel z:kForeground];
    _scoreLabel.visible = NO;
    
    _levelLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"font_level.fnt" width:_screenSize.width * 0.5f alignment:kCCTextAlignmentCenter];
    [_levelLabel setAnchorPoint:ccp(0,0)];
    [_levelLabel setPosition:ccp(_screenSize.width * 0.46f, _screenSize.height * 0.61f)];
    [self addChild:_levelLabel z:kForeground];
    _levelLabel.visible = NO;
    
    _boostHitParticles = [CCParticleSystemQuad particleWithFile:@"boost_hit.plist"];
    _lineHitParticles = [CCParticleSystemQuad particleWithFile:@"line_burst.plist"];
    _groundHitParticles = [CCParticleSystemQuad particleWithFile:@"off_screen.plist"];
    _starHitParticles  = [CCParticleSystemQuad particleWithFile:@"star_burst.plist"];
    
    _boostHitParticles.scale *= _manager.gameScale;
    _lineHitParticles.scale *= _manager.gameScale;
    _groundHitParticles.scale *= _manager.gameScale;
    _starHitParticles.scale *= _manager.gameScale;
    
    [_boostHitParticles stopSystem];
    [_lineHitParticles stopSystem];
    [_groundHitParticles stopSystem];
    [_starHitParticles stopSystem];
    
    [self addChild:_boostHitParticles];
    [self addChild:_lineHitParticles];
    [self addChild:_groundHitParticles];
    [self addChild:_starHitParticles];
    
    _drawLayer = [DrawLayer create];
    [self addChild:_drawLayer  z:kForeground];
   
    
    //create game over state
    _labelGameOver = [CCSprite spriteWithSpriteFrameName:@"label_game_over.png"];
    [_labelGameOver setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.65f)];
    _labelGameOver.visible = NO;
    [_gameBatchNode addChild:_labelGameOver z:kForeground];
    
     
    _labelBestScore = [CCSprite spriteWithSpriteFrameName:@"label_best_score.png"];
    [_labelBestScore setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.42f)];
    _labelBestScore.visible = NO;
    [_gameBatchNode addChild:_labelBestScore z:kForeground];
    
    _btnTryAgain = [CCSprite spriteWithSpriteFrameName:@"label_try_again.png"];
    [_btnTryAgain setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.26f)];
    _btnTryAgain.visible = NO;
    [_gameBatchNode addChild:_btnTryAgain z:kForeground];
    
    _btnMenu = [CCSprite spriteWithSpriteFrameName:@"label_menu.png"];
    [_btnMenu setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.15f)];
    _btnMenu.visible = NO;
    [_gameBatchNode addChild:_btnMenu z:kForeground];
     

    //create new level state
    _labelPoundKey = [CCSprite spriteWithSpriteFrameName:@"label_number.png"];
    [_labelPoundKey setPosition:ccp(_screenSize.width * 0.42f, _screenSize.height * 0.65f)];
    _labelPoundKey.visible = NO;
    [_gameBatchNode addChild:_labelPoundKey z:kForeground];
    
    _labelMeridian = [CCSprite spriteWithSpriteFrameName:@"label_meridian.png"];
    [_labelMeridian setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.55f)];
    _labelMeridian.visible = NO;
    [_gameBatchNode addChild:_labelMeridian z:kForeground];
    
    _btnStart = [CCSprite spriteWithSpriteFrameName:@"label_start.png"];
    [_btnStart setPosition:ccp(_screenSize.width * 0.5f, _screenSize.height * 0.2f)];
    _btnStart.visible = NO;
    [_gameBatchNode addChild:_btnStart z:kForeground];

}

-(void) clearLabels {
 _labelMeridian.visible = NO;
 _labelGameOver.visible = NO;
 _labelBestScore.visible = NO;
 _labelPoundKey.visible = NO;
 _btnTryAgain.visible = NO;
 _btnStart.visible = NO;
 _btnMenu.visible = NO;
 _scoreLabel.visible = NO;
 _levelLabel.visible = NO;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// add layer as a child to scene
	[scene addChild: [GameLayer create]];
	
	// return the scene
	return scene;
}

@end
