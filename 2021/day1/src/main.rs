use std::fs;
use std::fs::File;
use std::io::{BufRead, BufReader, Error, Write};

fn main() {
    let input = get_input().unwrap();

    let mut prev = -1;
    let mut result = 0;

    for i in input {
        if prev > 0 && i > prev {
            result = result + 1
        }

        prev = i;
    }

    println!("{}", result);
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
