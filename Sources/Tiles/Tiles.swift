import SwiftUI

public protocol TileContext: ObservableObject {
    associatedtype T = Tile
    var tile: T.Type { get }
    var rows: Int { get set }
    var columns: Int { get set }
    var forward: Bool { get set }
    var ascending: Bool { get set }
    var horizontal: Bool { get set }
    var spacing: Double { get set }
    var latchTiles: Bool { get set }
    var selectedTile: Int? { get set }
}

public struct Tiles<T: Tile, C : TileContext>: UIViewControllerRepresentable where C.T == T {
    @ObservedObject public var tileContext: C
    
    public init(tileContext: C) {
        self.tileContext = tileContext
    }
    
    public func makeUIViewController(context: Context) -> TileViewController<T> {
        TileViewController<T>(
            tileLayout: TileLayout(
                horizontal: tileContext.horizontal,
                forward: tileContext.forward,
                ascending: tileContext.ascending,
                rows: tileContext.rows,
                columns: tileContext.columns,
                spacing: tileContext.spacing
            ),
            tileType: tileContext.tile,
            latchTiles: tileContext.latchTiles,
            selectedTile: tileContext.selectedTile
        )
    }
    
    public func updateUIViewController(_ uiViewController: TileViewController<T>, context: Context) {
        let layout = TileLayout(
            horizontal: tileContext.horizontal,
            forward: tileContext.forward,
            ascending: tileContext.ascending,
            rows: tileContext.rows,
            columns: tileContext.columns,
            spacing: tileContext.spacing
        )
        
        if uiViewController.tileLayout != layout {
            uiViewController.tileLayout = layout
        }
        
        if uiViewController.latchTiles != tileContext.latchTiles {
            uiViewController.latchTiles = tileContext.latchTiles
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


