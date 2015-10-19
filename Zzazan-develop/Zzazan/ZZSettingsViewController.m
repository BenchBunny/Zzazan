//
//  ZZSettingsViewController.m
//  Zzazan
//
//  Created by Yiming Jiang on 2/14/15.
//  Copyright (c) 2015 Yiming Jiang. All rights reserved.
//

#import "ZZSettingsViewController.h"
#import <Parse/Parse.h>
#import "ZZWelcomeViewController.h"
#import "EGOCache.h"
#import "ZZAboutZzazanViewController.h"

#define SettingsOptionsArray @[@[@"About Zzazan",@"Terms and Privacy"],@[@"Log out"]]

@interface ZZSettingsViewController ()

@end

@implementation ZZSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Settings"];
    
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SettingsOptionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 36;
    }
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    
    cell.textLabel.text = SettingsOptionsArray[indexPath.section][indexPath.row];
    if ([cell.textLabel.text isEqual:@"Log out"])
        cell.accessibilityLabel = @"log out";

    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Copperplate-Light" size:18];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [PFUser logOut];
        [[EGOCache globalCache] clearCache];
        ZZWelcomeViewController *welcomeViewController = [[ZZWelcomeViewController alloc] init];
        [self presentViewController:welcomeViewController animated:YES completion:nil];
    }
    else if (indexPath.section == 0 && indexPath.row == 0) {
        ZZAboutZZazanViewController *aboutVC = [[ZZAboutZZazanViewController alloc] init];
        [aboutVC setTitle:@"About ZZazan"];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}


@end
