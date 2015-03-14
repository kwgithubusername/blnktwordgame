//
//  HWGDefaultPreferences.m
//  StudyAid
//
//  Created by Woudini on 1/16/15.
//  Copyright (c) 2015 Hi Range. All rights reserved.
//

#import "HWGDefaultPreferences.h"


@implementation HWGDefaultPreferences

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)setSliderValueUsingInt:(int)value
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:StudyAidHiddenWordPercentagePrefKey];
}

-(int)getSliderValue
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:StudyAidHiddenWordPercentagePrefKey];
}

-(void)loadDefaults
{
    NSDictionary *defaultPercentage = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:10] forKey:StudyAidHiddenWordPercentagePrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPercentage];
    
    NSDictionary *defaultWordsToIgnore = [NSDictionary dictionaryWithObject:[self defaultWordsToIgnore] forKey:StudyAidWordsToIgnoreDPPrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultWordsToIgnore];
    
    NSDictionary *defaultCharsToTrim = [NSDictionary dictionaryWithObject:[self defaultCharactersToTrim] forKey:StudyAidCharactersToTrimDPPrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultCharsToTrim];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:[UIColor yellowColor]];
    NSDictionary *defaultHighlighterColor = [NSDictionary dictionaryWithObject:colorData forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultHighlighterColor];
}

- (NSArray *)articles
{
    return @[@"a",@"an",@"the"];
}

- (NSArray *)pronouns
{
    return @[@"I",@"me",@"you",@"theirs",@"their",@"mine",@"your",@"yours",@"he",@"she",@"it",@"they",@"them",@"him",@"her",@"his",@"hers",@"its",@"himself",@"herself",@"myself",@"yourself",@"itself",@"this",@"that",@"here",@"there",@"these",@"those",@"my",@"our",@"ours",@"we",@"us"];
}

- (NSArray *)prepositions
{
    return @[@"to",@"of",@"in",@"for",@"with",@"on",@"at",@"from",@"up",@"down",@"out",@"about",@"into",@"back",@"over",@"under",@"forward",@"after",@"before"];
}

- (NSArray *)conjunctions
{
    return @[@"and",@"or",@"if",@"but",@"as",@"by",@"then",@"so",@"because",@"since",@"also",@"first",@"next",@"finally",@"furthermore"];
}

#pragma mark Verb conjugation

- (NSArray *)verbBe
{
    return @[@"is",@"was",@"been",@"being",@"be",@"were",@"are"];
}

- (NSArray *)verbHave
{
    return @[@"has",@"have",@"had",@"having"]; //having is new
}

- (NSArray *)verbLike
{
    return @[@"like",@"likes",@"liked",@"liking",@"likings"];
}

- (NSArray *)verbDo
{
    return @[@"do",@"does",@"doing",@"done",@"did"];
}

- (NSArray *)verbGet
{
    return @[@"get",@"gets",@"getting",@"got",@"gotten"];
}

- (NSArray *)verbGo
{
    return @[@"go",@"went",@"going",@"gone",@"goes"]; //goes is new
}

- (NSArray *)verbMake
{
    return @[@"make",@"makes",@"making",@"made"];
}

- (NSArray *)verbKnow
{
    return @[@"know",@"knows",@"knew",@"known",@"knowing"];
}

- (NSArray *)verbTake
{
    return @[@"take",@"takes",@"taking",@"taken",@"took"]; //took is new
}

- (NSArray *)verbSee
{
    return @[@"see",@"sees",@"saw",@"seen",@"seeing"];
}

- (NSArray *)verbLook
{
    return @[@"look",@"looks",@"looking",@"looked"];
}

- (NSArray *)verbCome
{
    return @[@"come",@"comes",@"came",@"coming"];
}

- (NSArray *)verbThink
{
    return @[@"think",@"thinks",@"thought",@"thinking"];
}

- (NSArray *)verbUse
{
    return @[@"use",@"used",@"using",@"uses"];
}

- (NSArray *)verbWork
{
    return @[@"work",@"working",@"workings",@"worked",@"works"];
}

- (NSArray *)verbWant
{
    return @[@"wants",@"want",@"wanting",@"wanted"];
}

- (NSArray *)verbGive
{
    return @[@"give",@"giving",@"gave",@"given",@"gives"];
}

- (NSArray *)allVerbs
{
    NSMutableArray *allVerbsMutableArray = [[NSMutableArray alloc] init];
    [allVerbsMutableArray addObjectsFromArray:[self verbBe]];
    [allVerbsMutableArray addObjectsFromArray:[self verbCome]];
    [allVerbsMutableArray addObjectsFromArray:[self verbDo]];
    [allVerbsMutableArray addObjectsFromArray:[self verbGet]];
    [allVerbsMutableArray addObjectsFromArray:[self verbGive]];
    [allVerbsMutableArray addObjectsFromArray:[self verbGo]];
    [allVerbsMutableArray addObjectsFromArray:[self verbHave]];
    [allVerbsMutableArray addObjectsFromArray:[self verbKnow]];
    [allVerbsMutableArray addObjectsFromArray:[self verbLike]];
    [allVerbsMutableArray addObjectsFromArray:[self verbLook]];
    [allVerbsMutableArray addObjectsFromArray:[self verbMake]];
    [allVerbsMutableArray addObjectsFromArray:[self verbSee]];
    [allVerbsMutableArray addObjectsFromArray:[self verbTake]];
    [allVerbsMutableArray addObjectsFromArray:[self verbThink]];
    [allVerbsMutableArray addObjectsFromArray:[self verbUse]];
    [allVerbsMutableArray addObjectsFromArray:[self verbWant]];
    [allVerbsMutableArray addObjectsFromArray:[self verbWork]];
    return allVerbsMutableArray;
}

- (NSArray *)miscellaneous
{
    return @[@"will",
             @"can",@"such",@"not",
             @"all",@"no",@"none",@"would",
             @"just",
             @"people",@"good",@"better",@"best",@"some",@"could",@"many",@"most",@"any",@"few",@"several",
             @"other",@"others",@"than",@"now",@"today",@"today's",
             @"it's",
             @"even",@"well",@"way",@"ways",@"new",
             @"very"];
}

- (NSArray *)questions
{
    return @[@"what",@"who",@"when",@"where",@"why",@"which",@"how"];
}

- (NSArray *)defaultWordsToIgnore
{
    NSMutableArray *ignoredWords = [[NSMutableArray alloc] init];
    [ignoredWords addObjectsFromArray:[self pronouns]];
    [ignoredWords addObjectsFromArray:[self articles]];
    [ignoredWords addObjectsFromArray:[self prepositions]];
    [ignoredWords addObjectsFromArray:[self conjunctions]];
    [ignoredWords addObjectsFromArray:[self miscellaneous]];
    [ignoredWords addObjectsFromArray:[self questions]];
    [ignoredWords addObjectsFromArray:[self allVerbs]];
    
    // add prepositions
    //
    //NSArray *ignoredWordsToReturn = [[NSArray alloc] initWithArray:ignoredWords];
    //ignoredWordsToReturn = [ignoredWordsToReturn sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    // NSLog(@"Ignord words are %@", ignoredWordsToReturn);
    return ignoredWords;
}

- (NSArray *)defaultCharactersToTrim
{
    return @[@".",@",",@";",@":",@"?",@"!",@"(",@")",@"/",@"\\",@"<",@">",@"\"",@"'",@"{",@"}",@"[",@"]",@"-"];
}



@end
