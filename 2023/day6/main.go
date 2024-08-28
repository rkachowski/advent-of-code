package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

//TIP To run your code, right-click the code and select <b>Run</b>. Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.

func main() {
	input := parse("input")
	part1(input)
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

//TIP See GoLand help at <a href="https://www.jetbrains.com/help/go/">jetbrains.com/help/go/</a>.
// Also, you can try interactive lessons for GoLand by selecting 'Help | Learn IDE Features' from the main menu.
