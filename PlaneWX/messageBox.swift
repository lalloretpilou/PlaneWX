//
//  messageBox.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 04/10/2022.
//

import SwiftUI

struct messageBox: View {
    let title: String
    let description: String
    let icon: String
    let background: Color
    
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(.white)
            .bold()
            .font(Font.body)
            Divider()
                .foregroundColor(.white)
            Spacer()
            ScrollView(.vertical)
            {
                Text(description)
                    .font(Font.body)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(width: 300)
        .background(background)
        .cornerRadius(15)
    }
}

struct messageBox_Previews: PreviewProvider {
    static var previews: some View {
        messageBox(title: "", description: "", icon: "", background: .white)
    }
}
