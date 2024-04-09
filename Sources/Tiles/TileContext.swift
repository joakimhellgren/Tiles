import SwiftUI

public class TileContext<T: Tile>: ObservableObject {
    @Published public var canLatch: Bool
    @Published public var layout: TileLayout
    @Published public var tile: T.Type
    @Published public var selectedTile: Int?
    
    public init(
        layout: TileLayout = TileLayout(),
        canLatch: Bool = true,
        tile: T.Type = SolidTile.self,
        selectedTile: Int? = 0
    ) {
        self.layout = layout
        self.canLatch = canLatch
        self.tile = tile
        self.selectedTile = selectedTile
    }
    
    public func navigate(axis: Axis, forward: Bool) {
        guard let currentPos = selectedTile else { return }
           
        let rows = layout.rows
        let cols = layout.columns
        
        let len = rows * cols
           
        let offsetPos = axis == .horizontal ? 1 : cols
        var nextPos = currentPos + (forward ? offsetPos : -offsetPos)
           
        if axis == .horizontal {
            let currentRow = currentPos / cols
            let newRow = nextPos / cols
            if currentRow != newRow {
                nextPos += (newRow < currentRow) ? cols : -cols
            }
        }
           
        let quantizedPos = (nextPos < 0 ? (currentPos == 0 && axis == .horizontal ? nextPos + cols : nextPos + len) : nextPos >= len ? nextPos - len : nextPos) % len
        selectedTile = quantizedPos
    }
}
