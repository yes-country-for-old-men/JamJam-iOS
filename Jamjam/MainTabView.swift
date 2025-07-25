//
//  MainTabView.swift
//  Jamjam
//
//  Created by 권형일 on 6/5/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(MainTabBarCapsule.self) var mainTabBarCapsule
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        @Bindable var mainTabBarCapsule = mainTabBarCapsule
        
        ZStack {
            TabView(selection: $mainTabBarCapsule.selectedTab) {
                HomeView()
                    .tag(MainTab.home)
                
                RegisterServiceNavigateView()
                    .tag(MainTab.write)
                
                ChatListView()
                    .tag(MainTab.chat)
                
                ProfileView()
                    .tag(MainTab.profile)
            }
            
            VStack {
                Spacer()
                
                MainTabBar(isCategoryView: false)
                    .offset(y: 97)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(NavigationCore())
        .environment(MainTabBarCapsule())
}
