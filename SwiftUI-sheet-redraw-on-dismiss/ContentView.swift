import SwiftUI

struct DismissingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        if #available(iOS 15.0, *) {
            print(Self._printChanges())
        } else {
            print("DismissingView: body draw")
        }
        return VStack {
            Button("Dismiss") { isPresented.toggle() }
            Text("Dismissing Sheet").padding()
        }.background(Color.white)
    }
}

struct PausableView: View {
    var isPaused: Bool
//    @Binding var isPaused: Bool
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    var body: some View {
        Text("Elapsed seconds: \(counter)")
            .onReceive(timer) { _ in
                counter += isPaused ? 0 : 1
            }
    }
}

struct ContentView: View {
    @State private var presentSheet = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            print(Self._printChanges())
        } else {
            print("ContentView: body draw")
        }
        return VStack{
            Button("Show Sheet") { presentSheet.toggle() }
            Text("The ContentView's body along with the .sheet() is being redrawn immediately after dismiss, if the @State property `presentSheet` is used anywhere else in the view - e.g. passed to `PausableView(isPaused:presentSheet)`.\n\nBut if the property is passed as a @Binding to `PausableView(isPaused:$presentSheet)`, the ContentView's body is not redrawn.").padding()
            PausableView(isPaused: presentSheet)
//            PausableView(isPaused: $presentSheet)
        }
        .sheet(isPresented: $presentSheet) {
            DismissingView(isPresented: $presentSheet)
                .background(BackgroundClearView()) // to see what's happening under the sheet
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 Make the .sheet() transparent, so we can see the scene behind.
 
 Idea from https://stackoverflow.com/questions/63745084/how-can-i-make-a-background-color-with-opacity-on-a-sheet-view
 */
struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
