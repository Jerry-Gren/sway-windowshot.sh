#!/bin/sh

for cmd in swaymsg jq grim swappy; do
    if ! command -v "$cmd" >/dev/null; then
        # In Sway, notifications are a user-friendly way to show errors.
        swaynag -t error -m "Error: Command '$cmd' not found. Please install it to use this script."
        exit 1
    fi
done

IPC_CMD=${IPC_CMD:-swaymsg}

# Find the full JSON object for the currently focused application window.
FOCUSED_WINDOW=$($IPC_CMD -t get_tree | jq '.. | select(.pid? and .focused?)')

# If no focused window is found, exit.
if [ -z "$FOCUSED_WINDOW" ]; then
    exit 0
fi

# Extract the absolute coordinates of the content area (rect) and the
# dimensions of the title bar (deco_rect). .rect is our reliable anchor.
RECT=$(echo "$FOCUSED_WINDOW" | jq '.rect')
DECO_RECT=$(echo "$FOCUSED_WINDOW" | jq '.deco_rect')

# Get individual values. We only need the height from deco_rect.
RX=$(echo "$RECT" | jq -r .x)
RY=$(echo "$RECT" | jq -r .y)
RW=$(echo "$RECT" | jq -r .width)
RH=$(echo "$RECT" | jq -r .height)
DH=$(echo "$DECO_RECT" | jq -r .height)

# The final X and Width are taken directly from the content area's absolute rect.
X=$RX
W=$RW

# The final Y is calculated by taking the content area's absolute Y
# and shifting it UP by the height of the title bar.
Y=$((RY - DH))

# The final Height is the sum of the content's height and the title bar's height.
H=$((RH + DH))

# Construct the final geometry string for grim.
GEOMETRY="$X,$Y ${W}x${H}"

# Take the screenshot using the calculated absolute geometry.
grim -g "$GEOMETRY" - | swappy -f -
