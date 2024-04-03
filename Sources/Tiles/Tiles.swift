import SwiftUI

public protocol TileContext: ObservableObject {
    var rows: Int { get set }
    var columns: Int { get set }
    var forward: Bool { get set }
    var ascending: Bool { get set }
    var horizontal: Bool { get set }
    var spacing: Double { get set }
    var latchTiles: Bool { get set }
    var selectedTile: Int? { get set }
}

public struct Tiles<T : Tile, C : TileContext>: UIViewControllerRepresentable {
    public var tile: T.Type
    @ObservedObject public var tileContext: C
    
    public init(tile: T.Type, tileContext: C) {
        self.tile = tile
        self.tileContext = tileContext
    }
    
    public func makeUIViewController(context: Context) -> TileViewController<T> {
        TileViewController<T>(
            spacing: tileContext.spacing,
            horizontal: tileContext.horizontal,
            forward: tileContext.forward,
            ascending: tileContext.ascending,
            rows: tileContext.rows,
            columns: tileContext.columns,
            tileType: tile,
            latchTiles: tileContext.latchTiles,
            selectedTile: tileContext.selectedTile
        )
    }
    
    public func updateUIViewController(_ uiViewController: TileViewController<T>, context: Context) {
        uiViewController.spacing = tileContext.spacing
        uiViewController.latchTiles = tileContext.latchTiles
        uiViewController.selectedTile = tileContext.selectedTile
        uiViewController.update(
            rows: tileContext.rows,
            columns: tileContext.columns,
            horizontal: tileContext.horizontal,
            forward: tileContext.forward,
            ascending: tileContext.ascending
        )
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


