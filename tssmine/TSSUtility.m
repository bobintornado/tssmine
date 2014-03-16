//
//  TSSUtility.m
//  tssmine
//
//  Created by Bob Cao on 9/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "TSSUtility.h"

@implementation TSSUtility

+ (void)thumbUpBuzzInBackground:(id)buzz block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *thumbUp = [PFObject objectWithClassName:@"ThumbUp"];
    [thumbUp setObject:[PFUser currentUser] forKey:@"fromUser"];
    [thumbUp setObject:buzz forKey:@"target"];
    
    [thumbUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded,error);
        }
    }];
}

+ (void)unThumbUpBuzzInBackground:(id)snap block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFQuery *queryExistingThumbUps = [PFQuery queryWithClassName:@"ThumbUp"];
    [queryExistingThumbUps whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [queryExistingThumbUps findObjectsInBackgroundWithBlock:^(NSArray *thumbUps, NSError *error) {
        if (!error) {
            for (PFObject *thumbUp in thumbUps) {
                [thumbUp delete];
            }
        }
        
        if (completionBlock) {
            completionBlock(YES,nil);
        }
    }];
}

+ (void)likeSnapInBackground:(id)buzz block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:@"ActivityLike"];
    //[queryExistingLikes whereKey:@"snapPhoto" equalTo:buzz];
    //[queryExistingLikes whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    //set caching implementation later
    //[queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *likes, NSError *error) {
        if (!error) {
            for (PFObject *like in likes) {
                [like delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:@"ActivityLike"];

        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            if (succeeded && ![[[buzz objectForKey:@"poster"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                
                //sending push notification
                //query matched user
                PFQuery *userQuery = [PFUser query];
                [userQuery whereKey:@"objectId" equalTo:[[buzz objectForKey:@"poster"] objectId]];
                
                //build the actual push notification target query
                PFQuery *pushQuery = [PFInstallation query];
                [pushQuery whereKey:@"user" matchesQuery:userQuery];
                
                // Send push notification to query
                PFPush *push = [[PFPush alloc] init];
                [push setQuery:pushQuery]; // Set our Installation query
                NSString *msg = [NSString stringWithFormat:@"%@ Has like your Snap %@",
                                 [[PFUser currentUser] objectForKey:@"username"], [buzz objectForKey:@"snapTitle"]];
                [push setMessage:msg];
                [push sendPushInBackground];
                NSLog(@"Push Sent");
            }
            
            // refresh cache
            /*implement refresh cache later
            PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
                            [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
                        } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }*/
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
            }];
            
            
        }];
};
             
    /*
     // like photo in Facebook if possible
     NSString *fbOpenGraphID = [photo objectForKey:kPAPPhotoOpenGraphIDKey];
     if (fbOpenGraphID && fbOpenGraphID.length > 0) {
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
     NSString *objectURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@", fbOpenGraphID];
     [params setObject:objectURL forKey:@"object"];
     [[PFFacebookUtils facebook] requestWithGraphPath:@"me/og.likes" andParams:params andHttpMethod:@"POST" andDelegate:nil];
     }
     */

+ (void)unlikeSnapInBackground:(id)snap block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:@"ActivityLike"];
    [queryExistingLikes whereKey:@"snapPhoto" equalTo:snap];
    [queryExistingLikes whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    //[queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            //PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:photo cachePolicy:kPFCachePolicyNetworkOnly];
//            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (!error) {
//                    
//                    NSMutableArray *likers = [NSMutableArray array];
//                    NSMutableArray *commenters = [NSMutableArray array];
//                    
//                    BOOL isLikedByCurrentUser = NO;
//                    
//                    for (PFObject *activity in objects) {
//                        if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
//                            [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
//                        } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment]) {
//                            [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
//                        }
//                        
//                        if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                            if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
//                                isLikedByCurrentUser = YES;
//                            }
//                        }
//                    }
//                    
//                    [[PAPCache sharedCache] setAttributesForPhoto:photo likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
//                }
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
//            }];
            
        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}

@end



