//
//  NavigationBaseView.swift
//  Jamjam
//
//  Created by 권형일 on 6/5/25.
//

import SwiftUI

struct NavigationBaseView: View {
    @State private var navRouter = NavigationCore()
    @State private var tabCapsule = MainTabBarCapsule()
    @State var isNeedUserInfoLoadCapsule = IsNeedUserInfoLoadCapsule()
    
    var body: some View {
        NavigationStack(path: $navRouter.path) {
            AisleView()
                .navigationDestination(for: NavigationDestinationPath.self) { view in
                    navRouter.destinationNavigate(to: view)
                }
                .preferredColorScheme(.light)
        }
        .environment(navRouter)
        .environment(tabCapsule)
        .environment(isNeedUserInfoLoadCapsule)
    }
}
