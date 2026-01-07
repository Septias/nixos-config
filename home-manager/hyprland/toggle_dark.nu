
let key = "/org/gnome/desktop/interface/color-scheme"

let current = (dconf read $key | str trim)

if $current == "'prefer-dark'" {
    dconf write $key "'prefer-light'"
} else {
    dconf write $key "'prefer-dark'"
}
