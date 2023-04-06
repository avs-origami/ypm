use std::{io::{self, Write}, process};

/// Print a list of packages to be installed and a confirmation prompt
pub fn confirm(packages: &[String]) {
    println!("\x1b[36mThe following packages will be installed:\x1b[0m");
    println!("\x1b[36m=========================================\x1b[0m");

    for package in packages {
        let ypm_pkg = crate::load_package(package);
        
        for dep in ypm_pkg.deps {
            let ypm_dep = crate::load_package(&dep);
            if ypm_dep.is_installed() {
                continue;
            }
            let spaces_len = 41 - format!("| ->  {} {}", ypm_dep.name, ypm_dep.version).len();
            let mut spaces = String::new();

            for _ in 1..spaces_len {
                spaces.push(' ');
            }

            spaces.push_str("\x1b[36m|");

            println!("\x1b[36m|\x1b[35m \x1b[33m->\x1b[35m  {} {}{}\x1b[0m", ypm_dep.name, ypm_dep.version, spaces)
        }
        let spaces_len = 41 - format!("| {} {}", ypm_pkg.name, ypm_pkg.version).len();
        let mut spaces = String::new();

        for _ in 1..spaces_len {
            spaces.push(' ');
        }

        spaces.push_str("\x1b[36m|");

        println!("\x1b[36m|\x1b[33m {} {}{}\x1b[0m", ypm_pkg.name, ypm_pkg.version, spaces);
    }

    println!("\x1b[36m=========================================\x1b[0m");

    print!("\x1b[36m Continue? [Y/n] ");
    io::stdout().flush().unwrap();

    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();

    match input.to_lowercase().trim() {
        "n" => process::exit(2),
        _ => (),
    }
}

/// Print a list of packages to be removed and a confirmation prompt
pub fn confirm_remove(packages: &[String]) {
    println!("\x1b[36mThe following packages will be removed:\x1b[0m");
    println!("\x1b[36m=========================================\x1b[0m");

    for package in packages {
        let ypm_pkg = crate::load_package(package);
        
        for dep in ypm_pkg.deps {
            let ypm_dep = crate::load_package(&dep);
            if ypm_dep.is_installed() {
                continue;
            }
            let spaces_len = 41 - format!("| ->  {} {}", ypm_dep.name, ypm_dep.version).len();
            let mut spaces = String::new();

            for _ in 1..spaces_len {
                spaces.push(' ');
            }

            spaces.push_str("\x1b[36m|");

            println!("\x1b[36m|\x1b[35m \x1b[33m->\x1b[35m  {} {}{}\x1b[0m", ypm_dep.name, ypm_dep.version, spaces)
        }
        let spaces_len = 41 - format!("| {} {}", ypm_pkg.name, ypm_pkg.version).len();
        let mut spaces = String::new();

        for _ in 1..spaces_len {
            spaces.push(' ');
        }

        spaces.push_str("\x1b[36m|");

        println!("\x1b[36m|\x1b[33m {} {}{}\x1b[0m", ypm_pkg.name, ypm_pkg.version, spaces);
    }

    println!("\x1b[36m=========================================\x1b[0m");

    print!("\x1b[36m Continue? [Y/n] ");
    io::stdout().flush().unwrap();

    let mut input = String::new();
    io::stdin().read_line(&mut input).unwrap();

    match input.to_lowercase().trim() {
        "n" => process::exit(2),
        _ => (),
    }
}