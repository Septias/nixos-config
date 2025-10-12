
$env.config = {
  show_banner: false
  # rm.always_trash: true
};

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

# $env.config.shell_integration = {
#   osc2                   : true
#   osc7                   : true
#   osc8                   : true
#   osc9_9                 : true
#   osc133                 : true
#   osc633                 : true
#   reset_application_mode : true
# }

$env.config = {
  show_banner: false,
  completions: {
    case_sensitive: false
    quick: true           # set to false to prevent auto-selecting completions
    partial: true         # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: $carapace_completer
    }
  }
}
