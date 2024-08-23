//
//  Constants.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

struct Tabs {
    static let search = "magnifyingglass"
    static let favourites = "star.fill"
}

struct SFSymbols {
    static let location = "mappin.and.ellipse"
    static let logo = "gh-logo"
    static let avatarLogo = "avatar-placeholder"
    static let emptyState = "empty-state-logo"
}

struct InfoItems {
    static let repos = "folder"
    static let gists = "text.alignleft"
    static let followers = "heart"
    static let following = "person.2"
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.height, ScreenSize.width)
    static let minLength = min(ScreenSize.height, ScreenSize.width)
}

// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
struct DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale

    static let isIphoneSE            = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isIphone8Standard     = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isIphone8Zoomed       = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isIphone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isIphone8PlusZoomed   = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isIphoneX             = idiom == .phone && ScreenSize.maxLength == 821.0
    static let isIphoneXsMaxAndXr    = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isIpad                = idiom == .pad   && ScreenSize.maxLength >= 1024.0

    static func isIphoneXAspectRatio() -> Bool {
        return isIphoneX || isIphoneXsMaxAndXr
    }
}

// iOS 17.0
enum Images {
    static let logo = UIImage(resource: .ghLogo)
    static let avatarLogo = UIImage(resource: .avatarPlaceholder)
    static let emptyState = UIImage(resource: .emptyStateLogo)
}
