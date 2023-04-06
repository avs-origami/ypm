use std::{env, fs, path::Path, process::{self, Command, ExitStatus}, os::unix::process::ExitStatusExt};

mod user;

const PKG_DIR: &str = "pkg";
const DL_CACHE: &str = "cache";
const REPO_DIR: &str = "repo";

/// Struct to store information about the package.
#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct YpmPkg {
    name: String,
    version: String,
    repo: String,
    source: String,
    is_group: bool,
    no_source: bool,
    deps: Vec<String>,
    mkdeps: Vec<String>,
    extras: Vec<String>,
}

impl YpmPkg {
    /// Check if the package is installed
    pub fn is_installed(&self) -> bool {
        if Path::new(&format!("{}/{}/{}", ypm_root(), PKG_DIR, self.name)).exists() {
            return true;
        } else {
            return false;
        }
    }
}

/// Struct to store options
pub struct Options {
    offline: bool,
    exit_on_fail: bool,
}

impl Options {
    pub fn new() -> Options{
        Options {
            offline: false,
            exit_on_fail: false,
        }
    }

    pub fn set_offline(&mut self) {
        self.offline = true;
    }

    pub fn exit_on_fail(&mut self) {
        self.exit_on_fail = true;
    }
}

/// Display help to the terminal.
pub fn print_help() {
    if Path::new("helpfile.txt").exists() {
        let helpfile = fs::read_to_string("helpfile.txt").expect("Couldn't read helpfile.");
        println!("{helpfile}");
    } else if Path::new("/etc/ypm/helpfile.txt").exists() {
        let helpfile = fs::read_to_string("/etc/ypm/helpfile.txt").expect("Couldn't read helpfile.");
        println!("{helpfile}");
    } else {
        eprintln!("Couldn't locate helpfile. It may have been moved or deleted.")
    }
    
}

/// Generate a package template from the command line.
pub fn generate_package(args: &Vec<String>) {
    if args.len() < 11 {
        eprintln!("Not enough arguments.");
        print_help();
        process::exit(1);
    }

    let package = YpmPkg {
        name: String::from(&*args[2]),
        version: String::from(&*args[3]),
        repo: String::from(&*args[4]),
        source: String::from(&*args[5]),
        is_group: false,
        no_source: match &args[6][..] {
            "true" | "t" | "yes" | "y" => true,
            _ => false,
        },
        deps: string_to_vec(&*args[8]),
        mkdeps: string_to_vec(&*args[9]),
        extras: string_to_vec(&*args[10]),
    };
    
    let pkg_dir = format!("{}/{}/{}/{}", ypm_root(), REPO_DIR, &package.repo, &package.name);

    fs::create_dir(&pkg_dir).expect("Failed to create package directory.");

    let package_file = format!("{}/package.ron", &pkg_dir);    // TODO: fix this directory to be in repo
    let build_script = format!("{}/build.sh", &pkg_dir);
    let install_script = format!("{}/install/install.sh", &pkg_dir);
    let ron_config = ron::ser::PrettyConfig::new().indentor("\t".to_owned());

    fs::write(&package_file, ron::ser::to_string_pretty(&package, ron_config).unwrap()).expect("Couldn't create package.ron");
    fs::write(&build_script, "#!/bin/bash\n./configure --prefix=/usr\n\nmake\nmake DESTDIR=$1 install\n").expect("Couldn't create build.sh");

    let editor: String = if env::var("EDITOR").is_ok() {
        env::var("EDITOR").unwrap()
    } else {
        String::from("vim")
    };

    Command::new(&editor).arg(&build_script).status().expect("Failed to open editor.");

    let has_install = match &args[7][..] {
        "true" | "t" | "yes" | "y" => true,
        _ => false,
    };

    if has_install {
        fs::create_dir(format!("{}/install", &pkg_dir)).expect("Failed to create package install directory.");
        fs::write(&install_script, "#!/bin/bash").expect("Couldn't create install.sh");
        Command::new(&editor).arg(&install_script).status().expect("Failed to open editor.");
    }
}

/// Load a package.
pub fn load_package(name: &str) -> YpmPkg {
    let pkg_ron = if Path::new(&format!("{}/{}/core/{}", ypm_root(), REPO_DIR, name)[..]).exists() {
        format!("{}/{}/core/{}/package.ron", ypm_root(), REPO_DIR, name)
    } else {
        format!("{}/{}/extra/{}/package.ron", ypm_root(), REPO_DIR, name)
    };

    let pkg_str = &fs::read_to_string(pkg_ron).expect("Failed to read package.ron")[..];
    let pkg: YpmPkg = ron::de::from_str(&pkg_str).unwrap();
    return pkg;
}

/// Download a package source
pub fn download_package(package: &YpmPkg) {
    let pkg_src_dest = format!("{}/{}/{}-{}.tar.xz", ypm_root(), DL_CACHE, package.name, package.version);
    let pkg_dl_unfin = format!("{}.unfinished", &pkg_src_dest);

    if ! Path::new(&pkg_src_dest).exists() {
        fs::write(&pkg_dl_unfin, "Unfinished download.").expect("Failed to create unfinished download file.");
        Command::new("wget").arg(&package.source).arg("-O").arg(&pkg_src_dest).status().expect("Failed to download package source.");
        fs::remove_file(&pkg_dl_unfin).expect("Failed to remove unfinished download file.");
    } else if Path::new(&pkg_dl_unfin).exists() {
        Command::new("wget").arg(&package.source).arg("-O").arg(&pkg_src_dest).status().expect("Failed to download package source.");
        fs::remove_file(&pkg_dl_unfin).expect("Failed to remove unfinished download file.");
    }
}

/// Download package extras
pub fn download_extras(package: &YpmPkg) {
    for url in &package.extras {
        let file = Path::new(&url).file_name().unwrap().to_str().unwrap();
        let pkg_src_dest = format!("{}/{}/{}", ypm_root(), DL_CACHE, &file);
        let pkg_dl_unfin = format!("{}.unfinished", &pkg_src_dest);

        if ! Path::new(&pkg_src_dest).exists() {
            fs::write(&pkg_dl_unfin, "Unfinished download.").expect("Failed to create unfinished download file.");
            Command::new("wget").arg(&url).arg("-O").arg(&pkg_src_dest).status().expect("Failed to download package source.");
            fs::remove_file(&pkg_dl_unfin).expect("Failed to remove unfinished download file.");
        } else if Path::new(&pkg_dl_unfin).exists() {
            Command::new("wget").arg(&url).arg("-O").arg(&pkg_src_dest).status().expect("Failed to download package source.");
            fs::remove_file(&pkg_dl_unfin).expect("Failed to remove unfinished download file.");
        }
    }
}

/// Download all packages and extras
pub fn download_all(packages: &[String]) {
    for package in packages {
        let ypm_pkg = load_package(&package[..]);
        if ! ypm_pkg.no_source {
            download_package(&ypm_pkg);
            download_extras(&ypm_pkg);
        }
    }
}

/// Build a package
pub fn build_package(package: &YpmPkg) -> ExitStatus {
    println!("\x1b[32mBuilding package");

    let pkg_src_dest = format!("{}/{}/{}-{}.tar.xz", ypm_root(), DL_CACHE, package.name, package.version);
    let pkg_src_dir = format!("{}/{}/{}-{}", ypm_root(), DL_CACHE, package.name, package.version);
    let pkg_install_dir = format!("{}/{}/{}", ypm_root(), PKG_DIR, package.name);

    if ! package.no_source {
        if ! Path::new(&pkg_src_dir).exists() {
            fs::create_dir(&pkg_src_dir).expect("Failed to create package src dir");
        }

        Command::new("tar")
            .arg("-xf").arg(&pkg_src_dest)
            .arg("-C").arg(&pkg_src_dir)
            .arg("--strip-components").arg("1")
            .status()
            .expect("Something broke.");
    

        env::set_current_dir(&pkg_src_dir).expect("Failed to cd.");
        Command::new("pwd").status().expect("Failed to pwd");
        println!("\x1b[0m");

        Command::new("mkdir").arg("-pv").arg(&pkg_install_dir).status().expect("Failed to make package install dir.");
    }
    
    println!("\x1b[0m");

    exec_script(package, &pkg_install_dir, "build.sh")
}

/// Install a package
pub fn install_package(package: &YpmPkg) -> ExitStatus{
    println!("\x1b[32mInstalling package");

    let pkg_install_dir = format!("{}/{}/{}", ypm_root(), PKG_DIR, package.name);

    Command::new("pwd").status().expect("Failed to pwd");
    println!("\x1b[0m");

    let install_status = if Path::new(&format!("{}/{}/{}/{}/install/install.sh", ypm_root(), REPO_DIR, &package.repo, &package.name)).exists() {
        exec_script(package, &pkg_install_dir, "install/install.sh")
    } else {
        ExitStatus::from_raw(0)
    };

    if ! install_status.success() {
        return install_status;
    }

    fs::write("ypm_symlink.sh", format!("cp -sRf {}/* /", &pkg_install_dir)).expect("Failed to create temporary symlink script.");
    let link_status = Command::new("bash").arg("-e").arg("ypm_symlink.sh").status().expect("Failed to link files to rootfs.");
    fs::remove_file("ypm_symlink.sh").expect("Failed to remove temporary symlink script.");

    if ! link_status.success() {
        return link_status;
    }

    let post_status = {
        if Path::new(&format!("{}/{}/{}/{}/install/post.sh", ypm_root(), REPO_DIR, &package.repo, &package.name)).exists() {
            exec_script(package, &pkg_install_dir, "install/post.sh")
        } else {
            ExitStatus::from_raw(0)
        }
    };

    if ! post_status.success() {
        return post_status;
    }

    return ExitStatus::from_raw(0);
}

/// Install all dependencies
pub fn install_deps(package: &YpmPkg) -> ExitStatus {
    download_all(&package.deps);
    for dependency in &package.deps {
        let dep = load_package(&dependency[..]);
        if ! dep.is_installed() {
            let dep_status = install_deps(&dep);
            if ! dep_status.success() {
                println!("\x1b[31mFailed to install dependencies of dependency\x1b[0m");
                return dep_status;
            }

            let build_status = build_package(&dep);
            if ! build_status.success() {
                println!("\x1b[31mFailed to build dependency\x1b[0m");
                return build_status;
            }

            let install_status = if build_status.success() {
                install_package(&dep)
            } else {
                ExitStatus::from_raw(0)
            };
            
            if ! install_status.success() {
                println!("\x1b[31mFailed to install dependency\x1b[0m");
                return install_status;
            }
        }
    }

    return ExitStatus::from_raw(0);
}

/// Install all specified packages
pub fn install_all(packages: &[String], opts: &mut Options) {
    user::confirm(&packages);
    
    if ! opts.offline {
        download_all(packages);
    }

    let mut pass: Vec<YpmPkg> = Vec::new();
    let mut fail: Vec<YpmPkg> = Vec::new();
    
    for package in packages {
        let ypm_pkg = load_package(&package[..]);

        let dep_status = install_deps(&ypm_pkg);
        if ! dep_status.success() {
            println!("\x1b[31mFailed to install dependencies\x1b[0m");
            fail.push(ypm_pkg);
            continue;
        }

        let build_status = build_package(&ypm_pkg);
        if ! build_status.success() {
            println!("\x1b[31mFailed to build package\x1b[0m");
        }

        let install_status = if build_status.success() {
            install_package(&ypm_pkg)
        } else {
            ExitStatus::from_raw(0)
        };
        
        if ! install_status.success() {
            println!("\x1b[31mFailed to install package\x1b[0m");
        }

        if opts.exit_on_fail && (! build_status.success() || ! install_status.success()) {
            break;
        } else if ! build_status.success() || ! install_status.success() {
            fail.push(ypm_pkg);
        } else {
            pass.push(ypm_pkg);
        }
    }

    println!("\n\x1b[32mSuccessful packages:\n====================");
    for package in pass {
        println!("{} {}", package.name, package.version);
    }

    println!("\n\x1b[31mFailed packages:\n================");
    for package in fail {
        println!("{} {}", package.name, package.version);
    }

    println!("\x1b[0m")
}

/// Remove a package
pub fn remove_package(package: &YpmPkg) {

    let pkg_install_dir = format!("{}/{}/{}", ypm_root(), PKG_DIR, package.name);
    let pkg_cache_dir = format!("{}/{}/{}-{}", ypm_root(), DL_CACHE, package.name, package.version);

    if Path::new(&format!("{}/{}/{}/{}/remove.sh", ypm_root(), REPO_DIR, &package.repo, &package.name)).exists() {
        exec_script(package, &pkg_install_dir, "remove.sh");
    }

    if package.is_installed() {
        fs::remove_dir_all(&pkg_install_dir).expect("Failed to uninstall package.");
    }
    
    if Path::new(&pkg_cache_dir).exists() {
        fs::remove_dir_all(&pkg_cache_dir).expect("Failed to remove package cache.");
    }
}

/// Remove all specified packages
pub fn remove_all(packages: &[String]) {
    user::confirm_remove(packages);
    for package in packages {
        let ypm_pkg = load_package(&package[..]);
        remove_package(&ypm_pkg);
    }
}

/// Clear the package cache
pub fn clear_cache() {
    fs::remove_dir_all(format!("{}/{}", ypm_root(), DL_CACHE)).expect("Failed to remove package cache");
    fs::create_dir(format!("{}/{}", ypm_root(), DL_CACHE)).expect("Failed to recreate package cache");
}

pub fn ypm_root() -> String {
    env::var("YPM_ROOT").unwrap_or("/etc/ypm".to_string())
}

/// Convert a comma separated &str to Vec<String>
fn string_to_vec(s: &str) -> Vec<String> {
    if s == "" {
        return Vec::new();
    }
    
    let s: String = s.chars().filter(|c| !c.is_whitespace()).collect();
    let s = s.split(",");
    let mut v = Vec::new();

    for i in s {
        v.push(String::from(i));
    }

    return v;
}

/// Execute a script in the package's repo directory.
pub fn exec_script(package: &YpmPkg, pkg_install_dir: &str, script: &str) -> ExitStatus {
    Command::new("bash")
        .arg("-e")
        .arg(format!("{}/{}/{}/{}/{}", ypm_root(), REPO_DIR, &package.repo, &package.name, script))
        .arg(&pkg_install_dir)
        .status()
        .expect(&format!("Failed to execute {}", script))
}