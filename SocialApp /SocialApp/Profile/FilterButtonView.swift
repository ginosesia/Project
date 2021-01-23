//
//  FilterButtonView.swift
//  SocialApp
//
//  Created by Gino Sesia on 20/01/2021.
//  Copyright © 2021 Gino Sesia. All rights reserved.
//

import SwiftUI

enum ProfileFilterOptions: Int, CaseIterable {
    case pictures
    case videos
    case posts
    
    var title: String {
        switch self {
        case .pictures: return "Pictures"
        case .videos: return "Videos"
        case .posts: return "Posts"
        
        }
    }
}

struct FilterButtonView: View {
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(ProfileFilterOptions.allCases.count)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(ProfileFilterOptions.allCases, id: \.self) { options in
                    Text(options.title)
                }
            }
            Rectangle()
                .frame(width: underlineWidth, height: 3)
                .foregroundColor(.blue)
                .animation(.spring())
        }
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView()
    }
}
