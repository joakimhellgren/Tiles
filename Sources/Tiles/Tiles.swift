import SwiftUI

public struct Tiles<T: Tile>: UIViewControllerRepresentable {
    private let uiViewController: TileViewController<T>
    
    var rows: Int
    var columns: Int
    var forward: Bool
    var ascending: Bool
    var horizontal: Bool
    var spacing: Double
    var delegate: TileDelegate?
    
    public init(
        rows: Int = 5,
        columns: Int = 5,
        forward: Bool = true,
        ascending: Bool = true,
        horizontal: Bool = true,
        spacing: Double = 1.0,
        tile: T.Type = BasicTile.self,
        delegate: TileDelegate? = nil
    ) {
        self.rows = rows
        self.columns = columns
        self.forward = forward
        self.ascending = ascending
        self.horizontal = horizontal
        self.spacing = spacing
        self.delegate = delegate
        self.uiViewController = TileViewController(
            spacing: spacing,
            horizontal: horizontal,
            forward: forward,
            ascending: ascending,
            rows: rows,
            columns: columns,
            tileType: tile,
            delegate: delegate
        )
    }
    
    public func makeUIViewController(context: Context) -> TileViewController<T> {
        update(uiViewController)
        return uiViewController
    }
    
    public func updateUIViewController(_ uiViewController: TileViewController<T>, context: Context) {
        update(uiViewController)
    }
    
    private func update(_ uiViewController: TileViewController<T>) {
        uiViewController.tileDelegate = delegate
        uiViewController.spacing = spacing
        uiViewController.update(rows: rows, columns: columns, horizontal: horizontal, forward: forward, ascending: ascending)
    }
}


