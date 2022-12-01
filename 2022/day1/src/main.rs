use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    let mut groups: Vec<Vec<i32>> = Vec::new();

    if let Ok(lines) = read_lines("./input") {
        let mut group = Vec::new();

        for line in lines {
            if let Ok(value) = line {
                if value.chars().count() < 1 {
                    groups.push(group.clone());
                    group = Vec::new();
                } else {
                    let val = value.parse().unwrap();
                    group.push(val);
                }
            }
        }
    }

    let max: i32 = groups.iter().map(|g| g.iter().sum()).max().unwrap();
    println!("part1 {}", max);

    let mut top: Vec<i32> = groups.iter().map(|g| g.iter().sum()).collect();
    top.sort();
    top.reverse();

    let count = top[0] + top[1] + top[2];

    println!("part2 {}", count);
}

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
