//
//  UserCreationSucceedView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 23.11.21.
//

import SwiftUI

struct UserCreationSucceedView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 150, height: 150, alignment: .center)
            
            Text("You successfuly created your account!\n Please wait until other features arrive.")
                .multilineTextAlignment(.center)
                .font(.headline)
        }.navigationBarBackButtonHidden(true)
    }
}

struct UserCreationSucceedView_Previews: PreviewProvider {
    static var previews: some View {
        UserCreationSucceedView()
    }
}
