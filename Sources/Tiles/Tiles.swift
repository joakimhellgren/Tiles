import SwiftUI

public struct Tiles<T: Tile>: UIViewControllerRepresentable {
    @ObservedObject public var tileContext: TileContext<T>
    
    public init(_ tileContext: TileContext<T>) {
        self.tileContext = tileContext
    }
    
    public func makeUIViewController(context: Context) -> TileViewController<T> {
        TileViewController<T>(
            layout: tileContext.layout,
            tile: tileContext.tile,
            canLatch: tileContext.canLatch,
            selectedTile: tileContext.selectedTile
        )
    }
    
    public func updateUIViewController(_ uiViewController: TileViewController<T>, context: Context) {
        if uiViewController.layout != tileContext.layout {
            uiViewController.layout = tileContext.layout
        }
        
        if uiViewController.canLatch != tileContext.canLatch {
            uiViewController.canLatch = tileContext.canLatch
        }
        
        if uiViewController.selectedTile != tileContext.selectedTile {
            uiViewController.selectedTile = tileContext.selectedTile
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject {
        var parent: Tiles
        init(_ parent: Tiles) {
            self.parent = parent
        }
    }
}


