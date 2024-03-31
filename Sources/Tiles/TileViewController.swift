import UIKit

public class TileViewController<T: Tile>: UIViewController {
    private static var touchCapacity: Int { 10 }
    
    private var touches = NSMutableSet(capacity: Int(touchCapacity))
    private var tiles: [T]
    
    public var horizontal: Bool
    public var forward: Bool
    public var ascending: Bool
    
    public var spacing: CGFloat
    
    public var rows: Int
    public var columns: Int
    public weak var tileDelegate: TileDelegate?
    
    public init(
        nibName nibNameOrNil: String? = nil,
        bundle nibBundleOrNil: Bundle? = nil,
        spacing: CGFloat = 1.0,
        horizontal: Bool = true,
        forward: Bool = true,
        ascending: Bool = true,
        rows: Int = 5,
        columns: Int = 5,
        tileType: T.Type,
        delegate: TileDelegate? = nil
    ) {
        self.horizontal = horizontal
        self.rows = horizontal ? rows : columns
        self.columns = horizontal ? columns : rows
        self.forward = horizontal ? forward : !ascending
        self.ascending = horizontal ? ascending : forward
        self.spacing = spacing
        self.tiles = [T]()
        self.tileDelegate = delegate
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        draw()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.add($0) }
        updateTiles()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.add($0) }
        updateTiles()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.remove($0) }
        updateTiles()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.remove($0) }
        updateTiles()
    }
}

extension TileViewController {
    public func update(rows: Int, columns: Int, horizontal: Bool, forward: Bool, ascending: Bool) {
        let rows = max(1, rows)
        let columns = max(1, columns)
        
        self.horizontal = horizontal
        
        self.rows = horizontal ? rows : columns
        self.columns = horizontal ? columns : rows
        
        self.forward = horizontal ? forward : !ascending
        self.ascending = horizontal ? ascending : forward
        
        viewDidLayoutSubviews()
    }
    
    private func draw() {
        let width = tileSize(in: view.frame.size.width, with: horizontal ? rows : columns, spacing: spacing)
        let height = tileSize(in: view.frame.size.height, with: horizontal ? columns : rows, spacing: spacing)
        
        let offset = CGPoint(x: width + spacing, y: height + spacing)
        var position = CGPoint(x: 0.0, y: horizontal ? offset.y * CGFloat(columns - 1) : 0)
        
        let tmpTiles = tiles
        
        view.subviews.forEach { $0.removeFromSuperview() }
        tiles.removeAll()
        
        for index in 0..<(rows*columns) {
            let tileRect = CGRect(
                origin: position,
                size: CGSize(width: width, height: height)
            )
            
            let tileIndex = tileIndex(from: index)
            
            let isPressed = tmpTiles.first(where: { $0.index == tileIndex })?.isPressed ?? false
            let latch = tmpTiles.first(where: { $0.index == tileIndex })?.latch ?? false
            let tile = T(frame: tileRect, index: tileIndex, isPressed: isPressed, latch: latch, delegate: tileDelegate)
            
            tilePosition(&position, in: view.frame, with: offset)
            tiles.append(tile)
            
            view.addSubview(tile)
        }
    }
    
    private func tilePosition(_ position: inout CGPoint, in frame: CGRect, with offset: CGPoint) {
        position.x += offset.x
        
        if position.x >= frame.size.width {
            position = CGPoint(
                x: 0,
                y: horizontal ? position.y - offset.y : position.y + offset.y
            )
        }
    }
    
    private func tileIndex(from index: Int) -> Int {
        var row = horizontal ? index % rows : index / columns
        row = forward ? row : rows - 1 - row
        
        var column = horizontal ? index / rows : index % columns
        column = ascending ? column : columns - 1 - column
        
        let i = column * rows + row
        return i
    }
    
    private func tileSize(in size: CGFloat, with division: Int, spacing: CGFloat) -> CGFloat {
        (size - (spacing * CGFloat(division - 1))) / CGFloat(division)
    }
    
    private func updateTiles() {
        let touches = touches.allObjects as! [UITouch]
        let locations = touches.map { $0.location(in: view) }
        
        tiles.forEach { tile in
            let isPressed = locations.first(where: {tile.frame.contains($0)}) != nil
            
            if !tile.isPressed && isPressed {
                tile.latch.toggle()
            }
            
            tile.isPressed = isPressed
        }
    }
}
