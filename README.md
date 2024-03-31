# Tiles - Swift Multi Touch Controller
<p><img src="https://img.shields.io/badge/iOS-14.0+-blue.svg"/></p>
<svg><img src="https://cdn.glitch.global/3f78c00c-cde8-40cf-bf59-1d274881b8e9/Tiles_Logotype_V2.svg?v=1711907257234"/></svg>
Responsive and customizable multi touch grid written in Swift inspired by "Akai MPC", "Ableton Push" & "Monome Grid".

## Installation
1. Select File -> Add Packages...
2. Click the `+` icon on the bottom left of the Collections sidebar on the left.
3. Choose `Add Swift Package Collection` from the pop-up menu.
4. In the `Add Package Collection` dialog box, enter `https://github.com/joakimhellgren/MPC.git` as the URL and click the "Load" button.

## Usage

### Basic example
```swift
import Tiles
import SwiftUI

struct ContentView: View {
    var body: some View {
        Tiles()
    }
}
```

### Styling example

```swift
import Tiles
import SwiftUI

// A custom implementation of the `Tile` class (included in the package by default):

open class BasicTile: Tile {
    open lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "\(index)"
        label.textColor = color.luminance > 0.6 ? .black : .white
        label.frame = CGRect(x: 5, y: 5, width: frame.width, height: 20)
        return label
    }()
    
    required public init(
        frame: CGRect,
        index: Int,
        isPressed: Bool = false,
        latch: Bool = false,
        delegate: TileDelegate? = nil
    ) {
        super.init(frame: frame, index: index, isPressed: isPressed, latch: latch, delegate: delegate)
        self.backgroundColor = color
        self.addSubview(label)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var color: UIColor {
        isPressed ? .label : latch ? .link : .separator
    }
    
    override open func didPress(_ isPressed: Bool) {
        backgroundColor = color
        label.textColor = color.luminance > 0.6 ? .black : .white
    }
}


// You must provide Tiles with your custom implementation as one of it's arguments:

struct ContentView: View {
    var body: some View {
        Tiles(tile: MyGridTile.self)
    }
}
```

### Advanced example
The Grid can be resized, realigned, and freely modified without compromising the state of visible tiles.
Please note however that when a tile is no longer visible, it's state will be discarded.

```swift
import SwiftUI
import Tiles

@Observable
class GridContext {
    var rows: Int
    var columns: Int
    var horizontal: Bool
    var forward: Bool
    var ascending: Bool
    var spacing: CGFloat
    
    init(
        rows: Int = 4,
        columns: Int = 4,
        horizontal: Bool = true,
        forward: Bool = true,
        ascending: Bool = true,
        spacing: CGFloat = 1.0
    ) {
        self.rows = rows
        self.columns = columns
        self.horizontal = horizontal
        self.forward = forward
        self.ascending = ascending
        self.spacing = spacing
    }
}

extension GridContext: TileDelegate {
    func didPressTile(at index: Int, isPressed: Bool) {
        
    }
    
    func didLatchTile(at index: Int, isLatched: Bool) {
        
    }
}

struct ContentView: View {
    @State private var gridContext = GridContext()
    var body: some View {
        VStack {
            Toggle(
                gridContext.horizontal ? "Horizontal" : "Vertical",
                isOn: $gridContext.horizontal
            )
            Toggle(
                gridContext.forward ? "Forward" : "Reverse",
                isOn: $gridContext.forward
            )
            Toggle(
                gridContext.ascending ? "Ascending" : "Descending",
                isOn: $gridContext.ascending
            )
            Stepper(
                "Rows: \(gridContext.rows)",
                value: $gridContext.rows,
                in: 1...99
            )
            Stepper(
                "Columns: \(gridContext.columns)",
                value: $gridContext.columns,
                in: 1...99
            )
            Tiles(
                rows: gridContext.rows,
                columns: gridContext.columns,
                forward: gridContext.forward, 
                ascending: gridContext.ascending,
                horizontal: gridContext.horizontal, 
                spacing: gridContext.spacing,
                delegate: gridContext
            )
            .padding()
        }
    }
}
