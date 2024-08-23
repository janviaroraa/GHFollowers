//
//  FollowerView.swift
//  GHFollowers
//
//  Created by Janvi Arora on 23/08/24.
//

import SwiftUI

struct FollowerView: View {

    var follower: Follower

    var body: some View {
        VStack {
            // AsyncImage does all the downloading for us.
            AsyncImage(url: URL(string: follower.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("avatar-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(Circle())

            Text(follower.login ?? "")
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    FollowerView(follower: Follower(login: "janviaroraa", avatarUrl: ""))
}
