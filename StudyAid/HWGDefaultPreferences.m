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

- (NSArray *)miscellaneous
{
    return @[@"is",@"was",@"been",@"being",@"be",@"were",@"are",@"has",@"have",@"had",@"will",@"like",@"likes",@"liked",@"liking",@"likings",@"can",@"such",@"not",@"do",@"does",@"doing",@"done",@"did",@"all",@"no",@"none",@"would",@"get",@"gets",@"getting",@"got",@"gotten",@"go",@"went",@"going",@"gone",@"make",@"makes",@"making",@"made",@"just",@"know",@"knows",@"knew",@"known",@"knowing",@"take",@"takes",@"taking",@"taken",@"people",@"good",@"better",@"best",@"some",@"could",@"many",@"most",@"any",@"few",@"several",@"see",@"sees",@"saw",@"seen",@"seeing",@"other",@"others",@"than",@"now",@"today",@"today's",@"look",@"looks",@"looking",@"looked",@"only",@"come",@"comes",@"came",@"coming",@"it's",@"think",@"thinks",@"thought",@"thinking",@"use",@"used",@"using",@"uses",@"work",@"working",@"workings",@"worked",@"works",@"even",@"well",@"way",@"ways",@"new",@"wants",@"want",@"wanting",@"wanted",@"give",@"giving"];
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
    
    // add prepositions
    //
    //NSArray *ignoredWordsToReturn = [[NSArray alloc] initWithArray:ignoredWords];
    //ignoredWordsToReturn = [ignoredWordsToReturn sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    // NSLog(@"Ignord words are %@", ignoredWordsToReturn);
    return ignoredWords;
}

- (NSArray *)defaultCharactersToTrim
{
    return @[@".",@",",@";",@":",@"?",@"!",@"(",@")",@"/",@"\\",@"<",@">",@"\"",@"'",@"{",@"}",@"[",@"]"];
}



@end
