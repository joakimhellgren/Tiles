import UIKit

public struct TileLayout: Equatable {
    var horizontal: Bool
    var forward: Bool
    var ascending: Bool
    
    public init(
        horizontal: Bool = true, forward: Bool = true, ascending: Bool = true
    ) {
        self.horizontal = horizontal
        self.forward = forward
        self.ascending = ascending
    }
}

public class TileViewController<T: Tile>: UIViewController {
    private static var touchCapacity: Int { 10 }
    public var touches = NSMutableSet(capacity: Int(touchCapacity))
    
    private var isUpdatingLayout = false
    
    private func scheduleLayoutUpdate() {
        guard !isUpdatingLayout else { return }
        isUpdatingLayout = true
        
        DispatchQueue.main.async { [weak self] in
            self?.performLayoutUpdate()
            self?.isUpdatingLayout = false
        }
    }
    
    private func performLayoutUpdate() {
        view.subviews.forEach { $0.removeFromSuperview() }
        updateFrames()
        updateTiles()
        updateIndices()
        tiles.forEach { view.addSubview($0) }
    }
    
    public var rows: Int {
        didSet {
            scheduleLayoutUpdate()
        }
    }
    public var columns: Int {
        didSet {
            scheduleLayoutUpdate()
        }
    }
    public var spacing: Double {
        didSet {
            print("spacing updated")
        }
    }
    public var tileLayout: TileLayout {
        didSet {
            print("layout updated")
            DispatchQueue.main.async { [weak self] in
                self?.updateIndices()
            }
        }
    }
    var touchIndices = [Int]() {
        didSet {
            
            tiles.forEach {
                $0.isPressed = touchIndices.contains($0.index)
            }
        }
    }
    
    public var tiles = [T]()
    public var latchTiles: Bool = true
    var latchIndices = [Int]() {
        didSet {
            tiles.forEach {
                $0.latch = latchIndices.contains($0.index)
            }
        }
    }
    
    public var selectedTile: Int? {
        didSet {
            tiles.forEach {
                $0.isSelected = $0.index == selectedTile
            }
        }
    }
    
    

    public init(
        nibName nibNameOrNil: String? = nil,
        bundle nibBundleOrNil: Bundle? = nil,
        tileLayout: TileLayout = TileLayout(),
        tileType: T.Type,
        latchTiles: Bool = true,
        selectedTile: Int? = nil,
        rows: Int = 4,
        columns: Int = 4,
        spacing: Double = 1.0
    ) {
        self.tileLayout = tileLayout
        self.latchTiles = latchTiles
        self.selectedTile = selectedTile
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        updateFrames()
        updateTiles()
        updateIndices()
        updateView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.add($0) }
        updateTouches()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.add($0) }
        updateTouches()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.remove($0) }
        updateTouches()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { self.touches.remove($0) }
        updateTouches()
    }
    
    private var frames = [CGRect]()
    private func updateFrames() {
        let width = (view.frame.size.width - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
        let height = (view.frame.size.height - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
        
        let size = CGSize(width: width, height: height)
        let offset = CGPoint(x: width + spacing, y: height + spacing)
        
        var position = CGPoint(x: 0.0, y: offset.y * CGFloat(columns - 1))
        
        var newFrames = [CGRect]()
        (0..<(columns*rows)).forEach { _ in
            let frame = CGRect(origin: position, size: size)
            tilePosition(&position, in: view.frame, with: offset)
            newFrames.append(frame)
        }
        
        frames = newFrames
    }
    
    private func updateTiles() {
        if !tiles.isEmpty {
            tiles.removeAll()
        }
        
        var newTiles = [T]()
        (0..<(columns*rows)).forEach {
            let frame = frames[tileIndex(from: $0)]
            let tile = T(frame: frame, index: $0, isSelected: selectedTile == $0)
            newTiles.append(tile)
        }
        
        tiles = newTiles
    }
    
    private func updateIndices() {
        (0..<(columns*rows)).forEach { index in
            let i = tileIndex(from: index)
            let tile = tiles[index]
            tile.index = i
            tile.isPressed = touchIndices.contains(i)
            tile.latch = latchIndices.contains(i)
            tile.isSelected = i == selectedTile
        }
    }
    
    public func updateView() {
        tiles.forEach { view.addSubview($0) }
    }
    
    public func tilePosition(_ position: inout CGPoint, in frame: CGRect, with offset: CGPoint) {
        position.x += offset.x
        
        if position.x >= frame.size.width {
            position = CGPoint(
                x: 0,
                y: position.y - offset.y
            )
        }
    }
    
    private func tileIndex(from index: Int) -> Int {
        let horizontal = tileLayout.horizontal
        let forward = horizontal ? tileLayout.forward : !tileLayout.ascending
        let ascending = horizontal ? !tileLayout.ascending : tileLayout.forward
        
        var row = horizontal ? index % rows : index / columns
        row = forward ? row : rows - 1 - row
        
        var column = horizontal ? index / rows : index % columns
        column = ascending ? column : columns - 1 - column
        
        let i = column * rows + row
        return i
    }
    
    public func tileSize(in size: CGFloat, with division: Int, spacing: CGFloat) -> CGFloat {
        (size - (spacing * CGFloat(division - 1))) / CGFloat(division)
    }
    
    public func updateTouches() {
        let touches = touches.allObjects as! [UITouch]
        let locations = touches.map { $0.location(in: view) }
        
        var touchIndices = self.touchIndices
        tiles.forEach { tile in
            let isPressed = locations.first(where: {tile.frame.contains($0)}) != nil
            
            if latchTiles && (!tile.isPressed && isPressed) {
                if latchIndices.contains(tile.index) {
                    latchIndices.removeAll(where: {$0 == tile.index})
                } else {
                    latchIndices.append(tile.index)
                }
            }
            
            if isPressed && !touchIndices.contains(tile.index) {
                touchIndices.append(tile.index)
            } else if !isPressed {
                touchIndices.removeAll(where: {$0 == tile.index})
            }
        }
        
        self.touchIndices = touchIndices
    }
    
    public func resetTiles() {
        tiles.forEach { tile in
            tile.isPressed = false
            tile.latch = false
        }
    }
}
