public struct TileLayout: Equatable {
    public var horizontal: Bool
    public var forward: Bool
    public var ascending: Bool
    public var rows: Int
    public var columns: Int
    public var spacing: Double
    
    public init(
        horizontal: Bool = true, 
        forward: Bool = true,
        ascending: Bool = true,
        rows: Int = 4, 
        columns: Int = 4,
        spacing: Double = 1.0
    ) {
        self.horizontal = horizontal
        self.forward = horizontal ? forward : !ascending
        self.ascending = horizontal ? ascending : forward
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
    }
}
