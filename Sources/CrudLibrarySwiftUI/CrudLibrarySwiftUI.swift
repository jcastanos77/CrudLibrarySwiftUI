// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

@available(iOS 14.0.0, *)
public struct SplashCalculadora: View {
    
    public init() {}
    
    @State var pushView = false
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        
        NavigationView {
            Text("CRUD SwiftUI").foregroundColor(.blue).bold()
                .font(Font.system(size: 30))
                .onReceive(timer){ _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }else{
                        pushView.toggle()
                        self.timer.upstream.connect().cancel()
                    }
                }.fullScreenCover(isPresented: $pushView) {
                    TaskListView(presenter: TaskListPresenter())
                }
        }}
}

@available(iOS 14.0.0, *)
struct ContentView_preview: PreviewProvider {
    static var previews: some View {
        TaskListView(presenter: TaskListPresenter())
    }
}
