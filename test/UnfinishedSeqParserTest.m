
//
//  UnfinishedSeqParserTest.m
//  UnfinishedSeq
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "UnfinishedSeqParser.h"

@interface UnfinishedSeqParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) UnfinishedSeqParser *parser;
@end

@implementation UnfinishedSeqParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"unfinished_seq" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"UnfinishedSeq";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[UnfinishedSeqParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/UnfinishedSeqParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/UnfinishedSeqParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testAB {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b" error:&err];
    
    //TDEqualObjects(TDAssembly(@"[a, b]a/b^"), [res description]);
    TDNil(res);
}

- (void)testABA {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a b a" error:&err];
    
    TDEqualObjects(TDAssembly(@"[a, b, a]a/b/a^"), [res description]);
}

@end
