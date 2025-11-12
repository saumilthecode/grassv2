//
//  LaunchView.swift
//  grass
//
//  Created by hy loh on 24/11/22.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack{
            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                let scale = min(w, h)
                let titleSize = max(28, scale * 0.10)
                let subtitleSize = max(18, scale * 0.06)
                let barWidth = max(4, scale * 0.014)
                let barHeight = max(70, scale * 0.24)
                let hSpacing = max(8, scale * 0.026)
                let vSpacing: CGFloat = 6
                let outerPadding = max(16, scale * 0.05)
                let logoGreen = Color(red: 0.0, green: 0.278, blue: 0.227)

                ZStack {
                    Color.clear
                    HStack(spacing: hSpacing) {
                        Text("Grass")
                            .font(.system(size: titleSize, weight: .regular))
                            .foregroundColor(logoGreen)
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)

                        Rectangle()
                            .frame(width: barWidth, height: barHeight)
                            .foregroundColor(logoGreen)

                        VStack(alignment: .leading, spacing: vSpacing) {
                            Text("Personalise")
                            Text("Your Growing")
                            Text("Experience")
                        }
                        .font(.system(size: subtitleSize, weight: .regular))
                        .foregroundColor(logoGreen)
                        .minimumScaleFactor(0.5)
                    }
                    .padding(outerPadding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        
        
    }}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
