use std::fs::File;
use std::io::{BufRead, BufReader, Error};

fn main() {
    let input = get_input().unwrap();

    let result = calculate_result(&input);

    println!("part 1: {}", result);

    let mut scans = Vec::new();

    for w in input.windows(3) {
        let sum = w.iter().sum();
        scans.push(sum);
    }

    let result = calculate_result(&scans);
    println!("part 2: {}", result);
}

fn calculate_result(input: &Vec<i32>) -> i32 {
    input
        .windows(2)
        .fold(0, |acc, w| if w[1] > w[0] { acc + 1 } else { acc })
}

fn get_input() -> Result<Vec<i32>, Error> {
    let input = File::open("input")?;
    let buffered = BufReader::new(input);

    let mut result = Vec::new();

    for line in buffered.lines() {
        let line = line?;
        result.push(line.parse::<i32>().unwrap());
    }

    Ok(result)
}
