import SwiftUI

public struct Tiles<T: Tile>: UIViewControllerRepresentable {
    public var tile: T.Type
    public var canLatch: Bool
    public var layout: TileLayout
    public var selectedTile: Binding<Int?>
    
    public init(canLatch: Bool = true, layout: TileLayout = TileLayout(), selectedTile: Binding<Int?>, tile: T.Type) {
        self.canLatch = canLatch
        self.layout = layout
        self.selectedTile = selectedTile
        self.tile = tile
    }
    
    public func makeUIViewController(context: Context) -> TileViewController<T> {
        let vc = TileViewController<T>(layout: layout, tile: tile, canLatch: canLatch, selectedTile: selectedTile.wrappedValue)
        vc.delegate = context.coordinator
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: TileViewController<T>, context: Context) {
        if uiViewController.layout != layout {
            uiViewController.layout = layout
        }
        
        if uiViewController.canLatch != canLatch {
            uiViewController.canLatch = canLatch
        }
        
        if uiViewController.selectedTile != selectedTile.wrappedValue {
            uiViewController.selectedTile = selectedTile.wrappedValue
        }
    }
    
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, TileViewControllerDelegate {
        var parent: Tiles
        init(_ parent: Tiles) {
            self.parent = parent
        }
        
        public func didUpdateSelectedTile(_ selectedTile: Int) {
            self.parent.selectedTile.wrappedValue = selectedTile
        }
    }
}


