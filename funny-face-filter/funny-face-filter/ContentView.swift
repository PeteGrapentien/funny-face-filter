//
//  ContentView.swift
//  funny-face-filter
//
//  Created by Peter Grapentien on 9/25/24.
//

import SwiftUI

/*
    Display selected image and buttons here
 */

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
