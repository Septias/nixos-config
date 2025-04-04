use abi_stable::std_types::{ROption, RString, RVec};
use anyrun_plugin::*;
use serde::Deserialize;
use std::{fs, process::Command};
use urlencoding::encode;

#[derive(Deserialize, Debug)]
struct Config {
    prefix: String,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            prefix: "gh".to_string(),
        }
    }
}

#[init]
fn init(config_dir: RString) -> Config {
    match fs::read_to_string(format!("{}/gh.ron", config_dir)) {
        Ok(content) => ron::from_str(&content).unwrap_or_default(),
        Err(_) => Config::default(),
    }
}

#[info]
fn info() -> PluginInfo {
    PluginInfo {
        name: "Github Search".into(),
        icon: "help-about".into(),
    }
}

#[get_matches]
fn get_matches(input: RString, config: &Config) -> RVec<Match> {
    if !input.starts_with(&config.prefix) {
        RVec::new()
    } else {
        vec![Match {
            title: input.trim_start_matches(&config.prefix).into(),
            description: ROption::RSome("Search your Repositories".into()),
            use_pango: false,
            icon: ROption::RNone,
            id: ROption::RNone,
        }]
        .into()
    }
}

#[handler]
fn handler(selection: Match, config: &Config) -> HandleResult {
    if let Err(why) = Command::new("sh")
        .arg("-c")
        .arg(format!(
            "xdg-open https://{}",
            &encode(&selection.title.to_string())
        ))
        .spawn()
    {
        println!("Failed to perform websearch: {}", why);
    }

    HandleResult::Close
}
