# Define your primary monitor name
let primary = "eDP-1"

# Get all monitors in JSON format
let monitors = (hyprctl monitors -j | from json)

# Find the secondary monitor name (the first one that isn't primary)
let secondary = (
    $monitors 
    | where name != $primary 
    | get 0?.name
)

# Get workspaces (excluding ID 1 and sorting)
let workspaces = (
    hyprctl workspaces -j 
    | from json 
    | where id > 1 
    | sort-by id 
    | get id
)

# Safety check: if no secondary monitor is found, we can't move things to it
if ($secondary == null) {
    print "No secondary monitor found. Moving workspace 1 to primary and exiting."
    hyprctl dispatch moveworkspacetomonitor 1 $primary
    exit 0
}

if ($workspaces | is-empty) {
    hyprctl dispatch moveworkspacetomonitor 1 $primary
    exit 0
}

# Move workspace 1 to primary
hyprctl dispatch moveworkspacetomonitor 1 $primary

# Move all other workspaces to the detected secondary monitor
$workspaces | each {|ws|
    hyprctl dispatch moveworkspacetomonitor $ws $secondary
}
