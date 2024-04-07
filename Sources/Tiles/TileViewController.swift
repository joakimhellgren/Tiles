import UIKit

public class TileViewController<T: Tile>: UIViewController {
    public var canLatch: Bool {
        didSet { resetTiles() }
    }
    
    public var layout: TileLayout {
        didSet { scheduleLayoutUpdate() }
    }
    
    public var selectedTile: Int? {
        didSet { tiles.forEach { $0.isSelected = $0.index == selectedTile } }
    }
    
    private static var touchCapacity: Int { 10 }
    private var touches = NSMutableSet(capacity: Int(touchCapacity))
    private var isUpdatingLayout = false
    private var tiles: [T]
    
    private var touchIndices = [Int]() {
        didSet { tiles.forEach { $0.isPressed = touchIndices.contains($0.index) } }
    }
    
    private var latchIndices = [Int]() {
        didSet { tiles.forEach { $0.latch = latchIndices.contains($0.index) } }
    }
    
    public init(
        nibName nibNameOrNil: String? = nil,
        bundle nibBundleOrNil: Bundle? = nil,
        layout: TileLayout = TileLayout(),
        tile: T.Type = VibrantTile.self,
        canLatch: Bool = true,
        selectedTile: Int? = nil
    ) {
        self.layout = layout
        self.canLatch = canLatch
        self.selectedTile = selectedTile
        self.tiles = [T]()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        scheduleLayoutUpdate()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
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
    
    private func scheduleLayoutUpdate() {
        guard !isUpdatingLayout else { return }
        isUpdatingLayout = true
        
        DispatchQueue.main.async { [weak self] in
            self?.performLayoutUpdate()
            self?.isUpdatingLayout = false
        }
    }
    
    private func performLayoutUpdate() {
        view.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let rows = layout.rows
        let columns = layout.columns
        let spacing = layout.spacing
        
        let width = (view.frame.size.width - (spacing * CGFloat(rows - 1))) / CGFloat(rows)
        let height = (view.frame.size.height - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
        
        let size = CGSize(width: width, height: height)
        let offset = CGPoint(x: width + spacing, y: height + spacing)
        
        var position = CGPoint(x: 0.0, y: offset.y * CGFloat(columns - 1))
        
        var newFrames = [CGRect]()
        var newTiles = [T]()
        
        (0..<(columns*rows)).forEach { _ in
            let frame = CGRect(origin: position, size: size)
            
            position.x += offset.x
            position = (position.x >= view.frame.size.width) ? CGPoint(x: 0, y: position.y - offset.y) : position
            newFrames.append(frame)
        }
        
        (0..<(columns*rows)).forEach {
            let frame = newFrames[tileIndex(from: $0)]
            let tile = T(index: $0, frame: frame, latch: latchIndices.contains($0), isSelected: selectedTile == $0)
            newTiles.append(tile)
            view.addSubview(tile)
        }
        
        tiles = newTiles
    }
    
    private func updateIndices() {
        let rows = layout.rows
        let columns = layout.columns
        
        (0..<(columns*rows)).forEach { index in
            let i = tileIndex(from: index)
            let tile = tiles[index]
            tile.index = i
            tile.isPressed = touchIndices.contains(i)
            tile.latch = latchIndices.contains(i)
            tile.isSelected = i == selectedTile
        }
    }
    
    private func tileIndex(from index: Int) -> Int {
        let rows = layout.rows
        let columns = layout.columns
        let spacing = layout.spacing
        
        let horizontal = layout.horizontal
        let forward = layout.forward
        let ascending = layout.ascending
        
        var row = horizontal ? index % rows : index / columns
        row = forward ? row : rows - 1 - row
        
        var column = horizontal ? index / rows : index % columns
        column = ascending ? column : columns - 1 - column
        
        let i = column * rows + row
        return i
    }
    
    private func updateTouches() {
        let touches = touches.allObjects as! [UITouch]
        let locations = touches.map { $0.location(in: view) }
        
        var touchIndices = self.touchIndices
        tiles.forEach { tile in
            let isPressed = locations.first(where: {tile.frame.contains($0)}) != nil
            
            if canLatch && (!tile.isPressed && isPressed) {
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
    
    private func resetTiles() {
        tiles.forEach { tile in
            tile.isPressed = false
            tile.latch = false
        }
    }
}
