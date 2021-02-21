//
//  Constants.swift
//  InstagramCopy
//
//  Created by Stephan Dowless on 2/7/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import Firebase

// MARK: - Root References

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

// MARK: - Storage References

let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("Profile_Image")
let STORAGE_MESSAGE_IMAGES_REF = STORAGE_REF.child("Message_images")
let STORAGE_MESSAGE_VIDEO_REF = STORAGE_REF.child("Video_messages")
let STORAGE_POST_IMAGES_REF = STORAGE_REF.child("Post_images")
let STORAGE_BANNER_IMAGES_REF = STORAGE_REF.child("Banner_images")


// MARK: - Database References

let USER_REF = DB_REF.child("Users")

let USER_FOLLOWER_REF = DB_REF.child("User-followers")
let USER_FOLLOWING_REF = DB_REF.child("User-following")

let USER_BAG_REF = DB_REF.child("User-bag")

let POSTS_REF = DB_REF.child("posts")
let USER_POSTS_REF = DB_REF.child("User-posts")
let USER_POSTS_MESSAGE_REF = DB_REF.child("User-post-messages")

let STORE_REF = DB_REF.child("store")
let USER_STORE_REF = DB_REF.child("User-store-posts")
let ITEMS_REF = DB_REF.child("items")
let USER_ITEMS_REF = DB_REF.child("User-items")

let USER_FEED_REF = DB_REF.child("User-feed")

let USER_LIKES_REF = DB_REF.child("User-likes")
let POST_LIKES_REF = DB_REF.child("Post-likes")

let COMMENT_REF = DB_REF.child("Comments")

let NOTIFICATIONS_REF = DB_REF.child("notifications")

let MESSAGES_REF = DB_REF.child("messages")
let USER_MESSAGES_REF = DB_REF.child("User-messages")
let USER_MESSAGE_NOTIFICATIONS_REF = DB_REF.child("User-message-notifications")

let HASHTAG_POST_REF = DB_REF.child("hashtag-post")

// MARK: - Decoding Values
let LIKE_INT_VALUE = 0
let COMMENT_INT_VALUE = 1
let FOLLOW_INT_VALUE = 2
let COMMENT_MENTION_INT_VALUE = 3
let POST_MENTION_INT_VALUE = 4


//Change User Data

let USERNAME = 0
let FIRSTNAME = 1
let LASTNAME = 2
let BIO = 3
let DESCRIPTION = 4

var SIGN_UP_TOP_LABEL: String = "SIGN UP"
