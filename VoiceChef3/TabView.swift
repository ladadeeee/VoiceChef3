//
//  TabView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/12/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView(selection: .constant(0)) {
            CategoryGridView()
                .tabItem {
                    Label("Recipes", systemImage: "book.closed")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
