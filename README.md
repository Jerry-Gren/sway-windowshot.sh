# sway-windowshot

A robust script for pixel-perfect focused window screenshots on Sway/wlroots.

## The Problem

Standard screenshot tools often fail in complex wlroots environments, especially with HiDPI scaling, mixed layouts (horizontal/vertical splits), and custom bars like Waybar. This script solves common issues such as:
- Capturing the wrong window or only a portion of the screen.
- Incorrectly calculating window position in nested layouts.
- Failing to include the window's title bar.
- Being offset incorrectly by top bars like Waybar.

## Dependencies

* `sway` (or other wlroots-based compositor with `swaymsg`)
* `grim`
* `swappy`
* `jq`

## Installation

1.  Place the `sway-windowshot.sh` script in a suitable directory, for example `~/.config/sway/scripts/`.

2.  Make the script executable:

    ```bash
    chmod +x ~/.config/sway/scripts/sway-windowshot.sh
    ```

## Usage

### Basic Binding

Bind a shortcut to this script in your Sway config file (`~/.config/sway/config`).

```
# Example binding for Alt+PrintScreen
bindsym Mod1+Print exec ~/.config/sway/scripts/sway-windowshot.sh
```

### Finding Your Key Name

Many keyboards, especially on laptops, have special function keys (like a dedicated screenshot key) that don't correspond to standard names like `Print`. If a simple binding doesn't work, you need to find the key's real name or code. Here are two methods to do that.

---

#### Method 1: Using `wev` (Recommended First)
This method finds the "keysym," which is the name Sway prefers.

1.  **Install `wev`**:
    
    ```bash
    # On Debian, Ubuntu
    sudo apt install wev
    
    # On Fedora
    sudo dnf install wev
    
    # On Arch Linux
    sudo pacman -S wev
    ```

2.  **Run `wev` in a terminal**:
    
    ```bash
    wev
    ```

3.  A small blank window will appear. **Click on this window** to make sure it's focused.
    

4.  **Press the key** you want to use for screenshots (without holding `Fn`).
    

5.  Look at the terminal output. You are looking for the `sym:` line and the name that follows it in quotes.
    
    ```
    # Example Output
    ...
    keysyms [
      (keysym 0xff67, "XF86Screenshot"),
    ]
    ...
    ```
    In this example, the key name is **`XF86Screenshot`**. Yours might be `F12`, `Insert`, etc.

6.  Use this name with `bindsym` in your Sway config:
    
    ```
    bindsym XF86Screenshot exec ~/.config/sway/scripts/sway-windowshot.sh
    ```

---

#### Method 2: Using `libinput` (For Low-Level Codes)
If `wev` doesn't give a clear result, this method finds the raw "keycode," which Sway can also bind.

1.  **Install `libinput`**:
    
    ```bash
    # On Debian, Ubuntu
    sudo apt install libinput-tools
    
    # On Fedora
    sudo dnf install libinput-utils
    
    # On Arch Linux
    sudo pacman -S libinput
    ```

2.  **Run the debug tool** (requires `sudo`):
    
    ```bash
    sudo libinput debug-events
    ```

3.  It will list your input devices. **Enter the number** for your keyboard and press Enter.
    

4.  **Press the key** you want to use.
    

5.  Look for a `KEYBOARD_KEY` event and the number in the parentheses.
    
    ```
    # Example Output
    -event6   KEYBOARD_KEY      +1.33s      KEY_SCREENSHOT (210) pressed
    ```
    In this example, the keycode is **`210`**.

6.  Use this number with `bindcode` in your Sway config:
    
    ```
    bindcode 210 exec ~/.config/sway/scripts/sway-windowshot.sh
    ```

> **Note:** Some keyboards send a hardwired key combination (like `Super+Shift+S`). If you see multiple key events for a single press, you should bind your command to that final key combination directly in Sway.

## License

This project is licensed under the MIT License.

## Contributing

Bug reports, feature requests, and pull requests are welcome! Please feel free to open an issue to discuss your ideas.
