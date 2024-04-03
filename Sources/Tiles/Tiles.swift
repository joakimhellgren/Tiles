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
        let vc = uiViewController
        
        if vc.spacing != tileContext.spacing {
            vc.spacing = tileContext.spacing
        }
        if vc.latchTiles != tileContext.latchTiles {
            vc.latchTiles = tileContext.latchTiles
        }
        if vc.selectedTile != tileContext.selectedTile {
            vc.selectedTile = tileContext.selectedTile
        }
        if vc.rows != tileContext.rows {
            vc.rows = tileContext.rows
        }
        if vc.columns != tileContext.columns {
            vc.columns = tileContext.columns
        }
        
        if vc.forward != tileContext.forward {
            vc.forward = tileContext.forward
        }
        
        if vc.ascending != tileContext.ascending {
            vc.ascending = tileContext.ascending
        }
        
        if vc.horizontal != tileContext.horizontal {
            vc.horizontal = tileContext.horizontal
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


