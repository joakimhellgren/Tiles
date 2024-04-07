import SwiftUI

public protocol TileContext: ObservableObject {
    associatedtype T = Tile
    var tile: T.Type { get }
    var canLatch: Bool { get set }
    var selectedTile: Int? { get set }
    var layout: TileLayout { get set }
}
