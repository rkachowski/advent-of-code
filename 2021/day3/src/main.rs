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

fn calculate_common_bits(length: usize, numbers: &Vec<u32>) -> Vec<u32> {
    let mut result = vec![0; length];

    for i in 0..result.len() {
        for num in numbers.iter() {
            if num & (1 << i) != 0 {
                result[length - 1 - i] += 1;
            }
        }
    }

    result
        .iter()
        .map(|&x| {
            if 0 == &numbers.len() % 2 && x == &numbers.len() / 2 {
                1
            } else if x > &numbers.len() / 2 {
                1
            } else {
                0
            }
        })
        .collect()
}

fn main() {
    let input = get_input("input").unwrap();
    let numbers = input
        .iter()
        .map(|s| u32::from_str_radix(s, 2).unwrap())
        .collect::<Vec<u32>>();

    let bitsize = input.first().unwrap().len();

    let result = calculate_common_bits(bitsize, &numbers);

    let gamma_str = result
        .iter()
        .map(|x| x.to_string())
        .collect::<Vec<String>>()
        .join("");

    let gamma = u32::from_str_radix(&gamma_str, 2).unwrap();
    let mut mask = 0;
    for i in 0..bitsize {
        mask |= 1 << i;
    }

    let eps = !gamma & mask; // only care about the last `bitsize` bits

    println!("gamma str: {:?}", gamma_str);
    println!("gamma: {:?}", gamma);
    println!("eps: {:?}", eps);

    println!("part 1 - {:?}", gamma * eps);

    let oxygen = part_2(&numbers, bitsize, 0, false);
    let co2 = part_2(&numbers, bitsize, 0, true);

    println!("part 2 - {:?}", oxygen[0] * co2[0]);
}

fn part_2(numbers: &Vec<u32>, bitsize: usize, bit: usize, invert: bool) -> Vec<u32> {
    let common_bits = if invert {
        calculate_common_bits(bitsize, &numbers)
            .iter()
            .map(|&x| if x == 1 { 0 } else { 1 })
            .collect::<Vec<u32>>()
    } else {
        calculate_common_bits(bitsize, &numbers)
    };

    let test_mask = 1 << (bitsize - 1 - bit);

    let matches = numbers
        .iter()
        .copied()
        .filter(|x| (*x & test_mask) >> (bitsize - 1 - bit) == common_bits[bit])
        .collect::<Vec<u32>>();

    if matches.len() <= 1 {
        matches
    } else {
        part_2(&matches, bitsize, bit + 1, invert)
    }
}
