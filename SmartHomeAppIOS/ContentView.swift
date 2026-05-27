import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("BackgroundPrimary")
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(Color("AccentPrimary"))
                Text("Hello, world!")
                    .foregroundStyle(Color("TextPrimary"))
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
