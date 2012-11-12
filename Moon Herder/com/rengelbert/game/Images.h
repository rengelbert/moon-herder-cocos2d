//
//  Images.h
//  MoonHerder
//
//  Created by Roger Engelbert on 10/9/12.
//  Copyright Done With Computers 2012. All rights reserved.
//	
#import "Game.h"
#import "cocos2d.h"

@interface Images : NSObject {
    
    Game * _game;
    int _imagesLoaded;
    NSArray * _images;
    BOOL _loaded;
}

@property BOOL loaded;

-(id) initWithGame:(Game *) game;

-(CCSprite *) getSkin:(NSString *) name;
-(CCTexture2D *) getTexture:(NSString *) name;
-(CCSpriteFrame *) getSpriteFrame:(NSString *) name;
-(void) imageLoaded;
-(void) loadImage;



@end
