import SwiftUI

public protocol TileContext: ObservableObject {
    var canLatch: Bool { get set }
    var layout: TileLayout { get set }
    var selectedTile: Int? { get set }
}


/*
 
 open func navigate(axis: Axis, forward: Bool) {
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
 */
