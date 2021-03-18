//
//  ButtonStyles.swift
//  coreDataRelationships
//
//  Created by Richard Long on 18/03/2021.
//

import Foundation
import SwiftUI

struct BigBoldSlimline: ButtonStyle {
   var colour: Color = .blue
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         //   Text("Start 5 Minute Countdown")
         .padding(12)
         .background(colour.opacity(0.8))
         .foregroundColor(Color.white)
         .cornerRadius(10)

         .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 2)
         .padding([.horizontal])
         .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      //.padding(.top, 5)
   }
}
