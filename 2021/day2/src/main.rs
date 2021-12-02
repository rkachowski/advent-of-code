use std::fs::File;
use std::io::{BufRead, BufReader, Error};

fn get_input() -> Result<Vec<String>, Error> {
    let input = File::open("input")?;
    let buffered = BufReader::new(input);

    let mut result = Vec::new();

    for line in buffered.lines() {
        let line = line?;
        result.push(line);
    }

    Ok(result)
}

fn parse(input: (&str, i32)) -> (i32, i32) {
    let (direction, inc) = input;
    match direction {
        "forward" => (inc, 0),
        "up" => (0, -inc),
        "down" => (0, inc),
        _ => (0, 0),
    }
}

fn main() {
    let input = get_input().unwrap();
    let steps = input
        .iter()
        .map(|s| s.split_whitespace().collect::<Vec<&str>>())
        .map(|splits| (splits[0], splits[1].parse::<i32>().unwrap()))
        .collect::<Vec<(&str, i32)>>();

    let increments = steps.iter().map(|s| parse(*s)).collect::<Vec<(i32, i32)>>();

    let position = increments
        .iter()
        .fold((0,0), |acc, inc| (acc.0 + inc.0, acc.1 + inc.1));

    println!("part1: {}", position.0 * position.1);

    let position = increments
        .iter()
        .fold((0,0,0), |acc, inc| (acc.0 + inc.0, acc.1 + (inc.0 * acc.2), acc.2 + inc.1));

    println!("part2: {}", position.0 * position.1);
}
