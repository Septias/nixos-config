
let primary = "eDP-1"
let secondary = "DP-1"

let workspaces = (
    hyprctl workspaces -j
    | from json
    | where id > 1
    | sort-by id
    | get id
)


if ($workspaces | is-empty) {
    exit 0
}

# first workspace → e-DP1
hyprctl dispatch moveworkspacetomonitor 1 $primary

# remaining workspaces → DP-1
$workspaces | each {|ws|
    hyprctl dispatch moveworkspacetomonitor $ws $secondary
}
