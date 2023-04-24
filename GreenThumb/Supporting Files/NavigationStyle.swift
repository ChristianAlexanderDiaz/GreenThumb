//
//  NavigationStyle.swift
//  MyPIM
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

/*
 
 */

import SwiftUI

extension View {
   
    public func customNavigationViewStyle() -> some View {
       
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Device is an iPhone
            // Use single column navigation view for iPhone
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            // Device is an iPad
            return AnyView(GeometryReader { device in
                // iPad height > iPad width indicates portrait device orientation
                if device.size.height > device.size.width {
                    // Use single column navigation view for iPad in portrait device orientation
                    self.navigationViewStyle(StackNavigationViewStyle())
                } else {
                    // Use double column navigation view (Split View) for iPad in landscape device orientation
                    self.navigationViewStyle(DoubleColumnNavigationViewStyle())
                }
            })
        }
    }
 
}
