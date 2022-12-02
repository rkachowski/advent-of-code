use core::panic;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    let input = parse_input();

    let part1_score: i32 = input.iter().map(score_pt1).sum();
    println!("part 1 score {}", part1_score);

    let part2_score: i32 = input.iter().map(score_pt2).sum();
    println!("part 2 score {}", part2_score);
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn parse_input() -> Vec<(String, String)> {
    let mut result = Vec::new();

    if let Ok(lines) = read_lines("./input") {
        for line in lines {
            if let Ok(value) = line {
                let vals: Vec<&str> = value.split(" ").collect();

                result.push((vals[0].into(), vals[1].into()));
            }
        }
    }

    return result;
}

fn score_pt1(game: &(String, String)) -> i32 {
    match (game.0.as_str(), game.1.as_str()) {
        //draw
        ("A", "X") => 3 + 1,
        ("B", "Y") => 3 + 2,
        ("C", "Z") => 3 + 3,

        //win
        ("A", "Y") => 6 + 2,
        ("B", "Z") => 6 + 3,
        ("C", "X") => 6 + 1,

        //loss
        ("A", "Z") => 0 + 3,
        ("B", "X") => 0 + 1,
        ("C", "Y") => 0 + 2,

        (_, _) => panic!("wtf was that {:?}", game),
    }
}

fn score_pt2(game: &(String, String)) -> i32 {
    match (game.0.as_str(), game.1.as_str()) {
        ("A", "X") => 0 + 3,
        ("A", "Y") => 3 + 1,
        ("A", "Z") => 6 + 2,

        ("B", "X") => 0 + 1,
        ("B", "Y") => 3 + 2,
        ("B", "Z") => 6 + 3,

        ("C", "X") => 0 + 2,
        ("C", "Y") => 3 + 3,
        ("C", "Z") => 6 + 1,

        (_, _) => panic!("wtf was that {:?}", game),
    }
}
