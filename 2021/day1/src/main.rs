use std::fs::File;
use std::io::{BufRead, BufReader, Error};

fn main() {
    let input = get_input().unwrap();

    let result = calculate_result(&input);

    println!("part 1: {}", result);

    let mut buf = Vec::new();
    let mut scans = Vec::new();
    for i in input {
        buf.push(i);

        if buf.len() == 3 {
            let scan = buf.iter().sum::<i32>();
            scans.push(scan);
            buf.remove(0);
        } 
    }

    let result = calculate_result(&scans);
    println!("part 2: {}", result);
}

fn calculate_result(input: &Vec<i32>) -> i32 {
    let mut prev = -1;
    let mut result = 0;

    for i in input {
        if prev > 0 && i > &prev {
            result = result + 1;
        }

        prev = *i;
    }

    result
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
