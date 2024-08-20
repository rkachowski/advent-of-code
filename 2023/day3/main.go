package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type Number struct {
	start int
	line  int
	end   int
	val   string
}
type Symbol struct {
	start int
	line  int
	val   string
}

type Coord struct {
	x int
	y int
}

func main() {
	input := parse("input")

	numbers := extractNumbers(input)
	//symbols := extractSymbols(input)
	var validNumbers []int
	for _, number := range numbers {
		if validNumber(number, input) {
			val, err := strconv.Atoi(number.val)
			if err != nil {
				fmt.Println(err)
			}
			validNumbers = append(validNumbers, val)
		}
	}

	fmt.Println(sum(validNumbers))
}

func sum(numbers []int) int {
	total := 0
	for _, number := range numbers {
		total += number
	}

	return total
}

func validNumber(number Number, input []string) bool {
	coords := coordsForNumber(number, Coord{len(input[0]), len(input)})

	for _, coord := range coords {
		char := string(input[coord.y][coord.x])
		symbol, _ := regexp.MatchString(`[^\w.]`, char)
		if symbol {
			return true
		}
	}

	return false
}

func coordsForNumber(number Number, max Coord) []Coord {
	var coords []Coord
	for y := number.line - 1; y <= number.line+1; y++ {
		if y < 0 || y >= max.y {
			continue
		}

		for x := number.start - 1; x < number.end+1; x++ {
			if x < 0 || x > max.x {
				continue
			}

			coords = append(coords, Coord{x, y})
		}
	}

	return coords
}
func extractSymbols(input []string) []Symbol {
	var symbols []Symbol

	for y, line := range input {

		for i := 0; i < len(line); i++ {
			char := string(line[i])

			symbol, _ := regexp.MatchString(`[^\w.]`, char)
			if symbol {
				newSymbol := Symbol{line: y, start: i, val: char}
				symbols = append(symbols, newSymbol)
			}
		}
	}

	return symbols
}

func extractNumbers(input []string) []Number {
	var numbers []Number

	for y, line := range input {
		var currentNumber Number
		found := false

		for i := 0; i < len(line); i++ {
			char := string(line[i])

			numeric, _ := regexp.MatchString(`\d`, char)
			if numeric {
				if !found {
					found = true
					currentNumber = Number{start: i, line: y, val: char}
				} else {
					currentNumber.val += char
				}

				if i == len(line)-1 {
					found = false
					currentNumber.end = i
					numbers = append(numbers, currentNumber)
				}
			} else {
				if found {
					found = false
					currentNumber.end = i
					numbers = append(numbers, currentNumber)
				}
			}
		}

	}
	return numbers
}

func parse(path string) []string {
	file, err := os.Open(path)
	if err != nil {
		fmt.Println(err)
		return nil
	}

	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines
}
