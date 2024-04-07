# Tiles - Swift Multi Touch Controller
<p><img src="https://img.shields.io/badge/iOS-14.0+-blue.svg"/></p>
<svg><img src="https://cdn.glitch.global/3f78c00c-cde8-40cf-bf59-1d274881b8e9/Tiles_Logotype_V2.svg?v=1711907257234"/></svg>
Tiles takes inspiration from many different concepts within the realm of music production and electro-acoustic composition techniques.
Tiles is primarily catered towards music production, but it is not bound to a musical context, so you could use Tiles for whatever you want.

Some common use cases for Tiles:
*Update - 2024-04-07 - Example use cases will be added as separate branches to this repository on 1.2.0 release.
- "MPC"-style grid for finger drumming.
- Interactive sequencer in any shape or form. 
- Canvas for drawing with multiple fingers.
- Slider(s).

<img src="https://cdn.glitch.global/3f78c00c-cde8-40cf-bf59-1d274881b8e9/Screenshot%202024-04-02%20at%2010.18.32.png?v=1712045952476">

## Installation
1. Select File -> Add Packages...
2. Click the `+` icon on the bottom left of the Collections sidebar on the left.
3. Choose `Add Swift Package Collection` from the pop-up menu.
4. In the `Add Package Collection` dialog box, enter `https://github.com/joakimhellgren/Tiles.git` as the URL and click the "Load" button.

## How to use

```swift

import Tiles
import SwiftUI

// Create a model for properties which will be used by 'Tiles':
class GridContext<T: Tile>: ObservableObject, TileContext {
    @Published var canLatch: Bool
    @Published var layout: TileLayout
    @Published var tile: T.Type
    @Published var selectedTile: Int?
    
    init(
        layout: TileLayout = TileLayout(),
        canLatch: Bool = true,
        tile: T.Type = VibrantTile.self,
        selectedTile: Int? = 0
    ) {
        self.layout = layout
        self.canLatch = canLatch
        self.tile = tile
        self.selectedTile = selectedTile
    }
}

// next, use your model to initialize 'Tiles' within your view:
struct ContentView: View {
    @StateObject var context = GridContext() 
    var body: some View {
        VStack {
            // Add these components to try out different layouts:
            Toggle("Forward", isOn: $gridContext.layout.forward)
            Toggle("Ascending", isOn: $gridContext.layout.ascending)
            Toggle("Horizontal", isOn: $gridContext.layout.horizontal)
            Stepper("Rows", value: $gridContext.layout.rows, in: 1...16)
            Stepper("Columns", value: $gridContext.layout.columns, in: 1...16)
            
            // Initialize 'Tiles' with your model: 
            Tiles(gridContext)
        }
    }
}

```
