//
//  ContentView.swift
//  Shared
//
//  Created by Dillon Nys on 5/15/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        if let user = viewModel.user {
            Text("User: \(user)")
        } else if let error = viewModel.error {
            Text("Error: \(error.localizedDescription)")
        } else {
            Button("Login") {
                viewModel.login()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
