//
//  Protocols.swift
//  InstagramCopy
//
//  Created by Gino Sesia on 05/06/2020.
//  Copyright © 2020 Gino Sesia. All rights reserved.
//

protocol FeedCellDelegate {
    func handleUsernameTapped(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool)
    func handleCommentTapped(for cell: FeedCell)
    func handleImageTapped(for cell: FeedCell)
    func handleConfigureLikeButton(for cell: FeedCell)
}


protocol DiscoverCellDelegate {
    func handleUsernameTapped(for cell: DiscoverCell)
    func handleOptionsTapped(for cell: DiscoverCell)
    func handleLikeTapped(for cell: DiscoverCell, isDoubleTap: Bool)
    func handleCommentTapped(for cell: DiscoverCell)
    func handleImageTapped(for cell: DiscoverCell)
    func handleConfigureLikeButton(for cell: DiscoverCell)
}
protocol ShopVCDelegate {
    func handlePurchaceTapped(for cell: ShopCell)
}

protocol SettingsLauncherDelegate: class {
    func settingDidSelected(setting: Setting)
}

protocol ShopSettingsLauncherDelegate: class {
    func settingDidSelected(setting: Setting)
}

protocol ItemConfirmationDelegate: class {
    func sendConfirmationAlert(item: Item)
}

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: ProfileHeader)
    func setUserStats(for header: ProfileHeader)
    func handleFollowersTapped(for header: ProfileHeader)
    func handleFollowingTapped(for header: ProfileHeader)
}

protocol UserStoreHeaderDelegate {
    func handleAddItemTapped(for header: StoreHeader)
}

protocol ChatCellSettingsDelegate {
    func handleOptionsTapped(for cell: ChatCell)
}

protocol HomeControllerDeligate {
    func handleMenuToggle(for header: FeedVC)
}

protocol SearchCellDelegate {
    func handleSearchFollow(for cell: SearchUserCell)
}


protocol NotificationCellDelegate {
    func handleFollowTapped(for cell: ShopCell)
    func handlePostTapped(for cell: ShopCell)
}


protocol CommentInputAccesoryViewDelegate {
    func didSubmit(for comment: String)
}

protocol FollowCellDelegate {
    func handleFollow(for cell: FollowLikeCell)
}

protocol Printable {
    var description: String { get }
}
