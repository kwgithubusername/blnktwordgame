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

- (NSSet *)articles
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"a",@"an",@"the", nil];
    return set;
}

- (NSSet *)pronouns
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"I",@"me",@"you",@"theirs",@"their",@"mine",@"your",@"yours",@"he",@"she",@"it",@"they",@"them",@"him",@"her",@"his",@"hers",@"its",@"himself",@"herself",@"myself",@"yourself",@"itself",@"this",@"that",@"here",@"there",@"these",@"those",@"my",@"our",@"ours",@"we",@"us", nil];
    return set;
}

- (NSSet *)prepositions
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"to",@"of",@"in",@"for",@"with",@"on",@"at",@"from",@"up",@"down",@"out",@"about",@"into",@"back",@"over",@"under",@"forward",@"after",@"before", nil];
    return set;
}

- (NSSet *)conjunctions
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"and",@"or",@"if",@"but",@"as",@"by",@"then",@"so",@"because",@"since",@"also",@"first",@"next",@"finally",@"furthermore", nil];
    return set;
}

#pragma mark Verb conjugation

- (NSSet *)verbBe
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"is",@"was",@"been",@"being",@"be",@"were",@"are", nil];
    return set;
}

- (NSSet *)verbHave
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"has",@"have",@"had",@"having", nil];
    return set;
}

- (NSSet *)verbLike
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"like",@"likes",@"liked",@"liking",@"likings", nil];
    return set;
}

- (NSSet *)verbDo
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"do",@"does",@"doing",@"done",@"did", nil];
    return set;
}

- (NSSet *)verbGet
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"get",@"gets",@"getting",@"got",@"gotten", nil];
    return set;
}

- (NSSet *)verbGo
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"go",@"went",@"going",@"gone",@"goes", nil];
    return set;
}

- (NSSet *)verbMake
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"make",@"makes",@"making",@"made", nil];
    return set;
}

- (NSSet *)verbKnow
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"know",@"knows",@"knew",@"known",@"knowing", nil];
    return set;
}

- (NSSet *)verbTake
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"take",@"takes",@"taking",@"taken",@"took", nil];
    return set;
}

- (NSSet *)verbSee
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"see",@"sees",@"saw",@"seen",@"seeing", nil];
    return set;
}

- (NSSet *)verbLook
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"look",@"looks",@"looking",@"looked", nil];
    return set;
}

- (NSSet *)verbCome
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"come",@"comes",@"came",@"coming", nil];
    return set;
}

- (NSSet *)verbThink
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"think",@"thinks",@"thought",@"thinking", nil];
    return set;
}

- (NSSet *)verbUse
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"use",@"used",@"using",@"uses", nil];
    return set;
}

- (NSSet *)verbWork
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"work",@"working",@"workings",@"worked",@"works", nil];
    return set;
}

- (NSSet *)verbWant
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"wants",@"want",@"wanting",@"wanted", nil];
    return set;
}

- (NSSet *)verbGive
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"give",@"giving",@"gave",@"given",@"gives", nil];
    return set;
}

- (NSSet *)allVerbs
{
    NSMutableSet *allVerbsMutableSet = [[NSMutableSet alloc] init];
    [allVerbsMutableSet addObjectsFromArray:[[self verbBe] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbCome] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbDo] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbGet] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbGive] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbGo] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbHave] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbKnow] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbLike] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbLook] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbMake] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbSee] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbTake] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbThink] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbUse] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbWant] allObjects]];
    [allVerbsMutableSet addObjectsFromArray:[[self verbWork] allObjects]];
    return allVerbsMutableSet;
}

- (NSSet *)miscellaneous
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"will",
                  @"can",@"such",@"not",
                  @"all",@"no",@"none",@"would",
                  @"just",
                  @"people",@"good",@"better",@"best",@"some",@"could",@"many",@"most",@"any",@"few",@"several",
                  @"other",@"others",@"than",@"now",@"today",@"today's",
                  @"it's",
                  @"even",@"well",@"way",@"ways",@"new",
                  @"very", nil];
    return set;
}

- (NSSet *)questions
{
    NSSet *set = [[NSSet alloc] initWithObjects:@"what",@"who",@"when",@"where",@"why",@"which",@"how", nil];
    return set;
}

- (NSArray *)defaultWordsToIgnore
{
    NSMutableArray *ignoredWords = [[NSMutableArray alloc] init];
    [ignoredWords addObjectsFromArray:[[self pronouns] allObjects]];
    [ignoredWords addObjectsFromArray:[[self articles] allObjects]];
    [ignoredWords addObjectsFromArray:[[self prepositions]allObjects]];
    [ignoredWords addObjectsFromArray:[[self conjunctions]allObjects]];
    [ignoredWords addObjectsFromArray:[[self miscellaneous] allObjects]];
    [ignoredWords addObjectsFromArray:[[self questions] allObjects]];
    [ignoredWords addObjectsFromArray:[[self allVerbs]allObjects]];
    
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
