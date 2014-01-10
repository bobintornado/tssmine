//
//  TSSUtility.m
//  tssmine
//
//  Created by Bob Cao on 9/1/14.
//  Copyright (c) 2014 Bob Cao. All rights reserved.
//

#import "TSSUtility.h"

@implementation TSSUtility

+ (void)likePhotoInBackground:(id)photo block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:@"ActivityLike"];
    [queryExistingLikes whereKey:@"snapPhoto" equalTo:photo];
    [queryExistingLikes whereKey:@"fromUser" equalTo:[PFUser currentUser]];
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
        [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
        [likeActivity setObject:[photo objectForKey:@"poster"] forKey:@"toUser"];
        [likeActivity setObject:photo forKey:@"snapPhoto"];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            if (succeeded && ![[[photo objectForKey:@"poster"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                //Push notification, implement later
                /* NSString *privateChannelName = [[photo objectForKey:kPAPPhotoUserKey] objectForKey:kPAPUserPrivateChannelKey];
                if (privateChannelName && privateChannelName.length != 0) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSString stringWithFormat:@"%@ likes your photo.", [PAPUtility firstNameForDisplayName:[[PFUser currentUser] objectForKey:kPAPUserDisplayNameKey]]], kAPNSAlertKey,
                                          kPAPPushPayloadPayloadTypeActivityKey, kPAPPushPayloadPayloadTypeKey,
                                          kPAPPushPayloadActivityLikeKey, kPAPPushPayloadActivityTypeKey,
                                          [[PFUser currentUser] objectId], kPAPPushPayloadFromUserObjectIdKey,
                                          [photo objectId], kPAPPushPayloadPhotoObjectIdKey,
                                          nil];
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannel:privateChannelName];
                    [push setData:data];
                    [push sendPushInBackground];
                }*/
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
@end
