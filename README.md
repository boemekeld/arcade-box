# arcade-box
A Parametric Wall Arcade Box designed in OpenSCAD for 3D printing. Fully customizable layout and dimensions.

## Main Features
* **Resizable Grid**: Define the number of buttons in any grid (e.g., 3×2, 3×3, 3×1, 4×4, etc.).
* **Custom Button Size**: Set button diameter (default 30.1 mm) and height (default 22 mm).
* **Mechanical Locking Lid**: Secure lid with integrated latch; mount on a wall using double‑sided tape or screws (optional).
* **ESP32 Support**: Optional holder for an ESP32 board with a 18650 battery.
* **USB‑C Port Cutout**: Optional opening for a USB‑C connector.

## Configuration Parameters
| Parameter                            | Description                                      | Default               |
| ------------------------------------ | ------------------------------------------------ | --------------------- |
| `Border`                             | Thickness of the outer frame                     | —                     |
| `Buttons_Padding`                    | Distance between adjacent buttons                | 4 mm                  |
| `Padding_Between_Buttons_and_Border` | Space between buttons and the border             | `Buttons_Padding × 3` |
| `RoundedBorder_Radius`               | Radius for rounded corners (0 for square edges)  | 5 mm                  |
| `Height`                             | Override the automatically calculated box height | Auto‑calculated       |
| `USBC_Width`                         | Width of the USB‑C cutout                        | 14 mm                 |
| `USBC_Height`                        | Height of the USB‑C cutout                       | 6 mm                  |
| `USBC_Padding`                       | Distance of USB‑C cutout from the border         | 8 mm                  |
| `Support_Width`                      | Width of the ESP32 support bracket               | 94 mm                 |
| `Support_Height`                     | Height of the ESP32 support bracket              | 2 mm                  |
| `Support_Depth`                      | Depth of the ESP32 support bracket               | 32 mm                 |

## Requirements
* [OpenSCAD](https://www.openscad.org/)

## Usage
1. Open `arcade_box.scad` in OpenSCAD.
2. Modify the parameters at the top of the file to suit your design.
3. Preview with **F5**, render with **F6**.
4. Export the resulting model as STL and 3D‑print.
