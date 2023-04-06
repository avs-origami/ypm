/*!
 * YPM, the Yocto Package Manager.
*/

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut opts = ypm::Options::new();

    if args.len() < 2 {
        println!("No options specified.");
        ypm::print_help();
        std::process::exit(1)
    }

    if args[1].chars().nth(0).unwrap() == '-' && args[1].chars().nth(1).unwrap() != '-' {
        for opt in args[1].chars() {
            match opt {
                'h' => ypm::print_help(),
                'g' => ypm::generate_package(&args),
                'i' => ypm::install_all(&args[2..], &mut opts),
                'd' => ypm::download_all(&args[2..]),
                'r' => ypm::remove_all(&args[2..]),
                'c' => ypm::clear_cache(),
                'o' => opts.set_offline(),
                'e' => opts.exit_on_fail(),
                _ => ypm::print_help(),
            }
        }
    } else if &args[1][0..2] == "--" {
        match &args[1][2..] {
            "help" => ypm::print_help(),
            "generate" => ypm::generate_package(&args),
            _ => (),
        }
    }
}
