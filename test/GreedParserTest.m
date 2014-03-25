
//
//  GreedParserTest.m
//  Greed
//
//  Created by Todd Ditchendorf on 3/27/13.
//
//

#import "TDTestScaffold.h"
#import "PGParserFactory.h"
#import "PGParserGenVisitor.h"
#import "PGRootNode.h"
#import "GreedParser.h"

@interface GreedParserTest : XCTestCase
@property (nonatomic, retain) PGParserFactory *factory;
@property (nonatomic, retain) PGRootNode *root;
@property (nonatomic, retain) PGParserGenVisitor *visitor;
@property (nonatomic, retain) GreedParser *parser;
@end

@implementation GreedParserTest

- (void)setUp {
    self.factory = [PGParserFactory factory];
    _factory.collectTokenKinds = YES;

    NSError *err = nil;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"greed" ofType:@"grammar"];
    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    err = nil;
    self.root = (id)[_factory ASTFromGrammar:g error:&err];
    _root.grammarName = @"Greed";
    
    self.visitor = [[[PGParserGenVisitor alloc] init] autorelease];
    [_root visit:_visitor];
    
    self.parser = [[[GreedParser alloc] initWithDelegate:self] autorelease];

#if TD_EMIT
    path = [[NSString stringWithFormat:@"%s/test/GreedParser.h", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.interfaceOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }

    path = [[NSString stringWithFormat:@"%s/test/GreedParser.m", getenv("PWD")] stringByExpandingTildeInPath];
    err = nil;
    if (![_visitor.implementationOutputString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err]) {
        NSLog(@"%@", err);
    }
#endif
}

- (void)tearDown {
    self.factory = nil;
}

- (void)testACACA {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a C a C a" error:&err];
    
    //TDEqualObjects(TDAssembly(@"[a, C, a]a/C/a^"), [res description]);
    TDNil(res);
}

- (void)testACA {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"a C a" error:&err];
    
    
    //TDEqualObjects(TDAssembly(@"[a, C, a]a/C/a^"), [res description]);
    TDNil(res);
}

- (void)testBCBCB {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"b C b C b" error:&err];
    
    //TDEqualObjects(TDAssembly(@"[b, C, b]b/C/b^"), [res description]);
    TDNil(res);
}

- (void)testBCB {
    NSError *err = nil;
    PKAssembly *res = [_parser parseString:@"b C b" error:&err];
    
    //TDEqualObjects(TDAssembly(@"[b, C, b]b/C/b^"), [res description]);
    TDNil(res);
}

@end
