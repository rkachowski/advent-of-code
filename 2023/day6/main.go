package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	input := parse("input")
	part1(input)
	part2(input)
}

func part1(input [][]int) {
	var totals []int
	for i := 0; i < len(input[0]); i++ {
		time := input[0][i]
		distance := input[1][i]

		winners := 0
		for t := 0; t < time; t++ {
			if t*(time-t) > distance {
				winners++
			}
		}

		totals = append(totals, winners)
		fmt.Printf("%d winning combinations with %d %d\n", winners, time, distance)
	}

	total := 1

	for i := 0; i < len(totals); i++ {
		total *= totals[i]
	}

	fmt.Println(total)
}

func part2(input [][]int) {
	time := joinInts(input[0])
	distance := joinInts(input[1])

	winners := 0
	for t := 0; t < time; t++ {
		if t*(time-t) > distance {
			winners++
		}
	}

	fmt.Printf("%d winning combinations with %d %d\n", winners, time, distance)
}

func joinInts(input []int) int {
	var strNumbers []string
	for _, num := range input {
		strNumbers = append(strNumbers, strconv.Itoa(num))
	}

	// Join all string elements to form a single string
	joinedString := strings.Join(strNumbers, "")

	// Convert the joined string back to an integer
	result, err := strconv.Atoi(joinedString)

	if err != nil {
		log.Fatalf("Error converting %s to int", joinedString)
	}

	return result
}

func parse(j string) [][]int {

	file, err := os.Open(j)
	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}
	defer file.Close()

	var scanner *bufio.Scanner
	scanner = bufio.NewScanner(file)

	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	var numbers [][]int

	for _, line := range lines {
		var row []int

		regex := regexp.MustCompile(`\d+`)
		for _, num := range regex.FindAllString(line, -1) {
			atoi, _ := strconv.Atoi(num)

			row = append(row, atoi)
		}

		numbers = append(numbers, row)
	}

	return numbers
}
