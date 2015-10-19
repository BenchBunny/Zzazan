//
//  IntegrationTestCases.m
//  Integration Tests with KIFTestCase
//
//  Created by Brian Nickel on 12/18/12.
//
//

#import <KIF/KIF.h>
#import "KIFUITestActor+EXAddition.h"

@interface IntegrationTestCases : KIFTestCase

@end

@implementation IntegrationTestCases

- (void)testThatUserCanSuccessfullyLogIn
{
    [tester reset];
    [tester goToLoginPage];
    [tester enterText:@"KIFTEST1" intoViewWithAccessibilityLabel:@"name"];
    [tester enterText:@"123" intoViewWithAccessibilityLabel:@"password"];
    [tester tapViewWithAccessibilityLabel:@"login"];
    [tester tapViewWithAccessibilityLabel:@"me"];
    [tester tapViewWithAccessibilityLabel:@"setting"];
    [tester tapViewWithAccessibilityLabel:@"log out"];
    
    // Verify that the login succeeded
    
}


- (void)testSendRequest
{
    [tester reset];
    [tester goToLoginPage];
    [tester enterText:@"KIFTEST1" intoViewWithAccessibilityLabel:@"name"];
    [tester enterText:@"123" intoViewWithAccessibilityLabel:@"password"];
    [tester tapViewWithAccessibilityLabel:@"login"];
    [tester tapViewWithAccessibilityLabel: @"contact tab"];
    [tester tapViewWithAccessibilityLabel: @"addfriend"];
    [tester enterText:@"qsder1" intoViewWithAccessibilityLabel:@"searchbar"];
    [tester tapViewWithAccessibilityLabel:@"qsder1"];
    [tester waitForViewWithAccessibilityLabel:@"addsuccess"];
    
}

-(void)testAcceptRequest
{
    [tester reset];
    [tester tapViewWithAccessibilityLabel:@"me"];
    [tester tapViewWithAccessibilityLabel:@"setting"];
    [tester tapViewWithAccessibilityLabel:@"log out"];

    [tester goToLoginPage];

    [tester enterText:@"qsder1" intoViewWithAccessibilityLabel:@"name"];
    [tester enterText:@"123" intoViewWithAccessibilityLabel:@"password"];
    [tester tapViewWithAccessibilityLabel:@"login"];
    [tester tapViewWithAccessibilityLabel: @"contact tab"];
    [tester tapViewWithAccessibilityLabel: @"acceptfriend"];
    [tester tapViewWithAccessibilityLabel:@"KIFTEST1"];
    [tester waitForViewWithAccessibilityLabel:@"acceptsuccess"];
}

-(void)testFailedLogin
{
    [tester reset];
    [tester tapViewWithAccessibilityLabel:@"me"];
    [tester tapViewWithAccessibilityLabel:@"setting"];
    [tester tapViewWithAccessibilityLabel:@"log out"];

    [tester goToLoginPage];
    
    [tester enterText:@"qsder" intoViewWithAccessibilityLabel:@"name"];
    [tester enterText:@"12" intoViewWithAccessibilityLabel:@"password"];
    [tester tapViewWithAccessibilityLabel:@"login"];
    
    // Verify that the login succeeded
    //[tester waitForViewWithAccessibilityLabel:@"invalid"];
    //    [tester waitForViewWithAccessibilityLabel:@"invalid"];
    
    
}


@end
