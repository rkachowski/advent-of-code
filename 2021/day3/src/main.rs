use std::fs::File;
use std::io::{BufRead, BufReader, Error};

fn get_input(file: &str) -> Result<Vec<String>, Error> {
    let input = File::open(file)?;
    let buffered = BufReader::new(input);

    let mut result = Vec::new();

    for line in buffered.lines() {
        let line = line?;
        result.push(line);
    }

    Ok(result)
}

fn main() {
    let input = get_input("input").unwrap();
    let numbers = input
        .iter()
        .map(|s| u32::from_str_radix(s, 2).unwrap())
        .collect::<Vec<u32>>();

    let mut result = vec![0; input.first().unwrap().len()];

    for i in 0..result.len() {
        for num in numbers.iter() {
            if num & (1 << i) != 0 {
                result[i] += 1;
            }
        }
    }

    let half_size = numbers.len() / 2;
    println!("{:?}", half_size);
    let gamma_str = result
        .iter()
        .rev() // reverse because we iterate from left to right in the result calculation step
        .map(|x| if x > &half_size { "1" } else { "0" })
        .collect::<Vec<&str>>()
        .join("");

    let gamma = u32::from_str_radix(&gamma_str, 2).unwrap();
    let eps = !gamma & 0b1111_1111_1111; // only care about the last 12 bits

    println!("gamma str: {:?}", gamma_str);
    println!("gamma: {:?}", gamma);
    println!("eps: {:?}", eps);

    println!("{:?}", gamma * eps);
}
