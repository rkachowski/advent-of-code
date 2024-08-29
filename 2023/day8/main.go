package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	instructions, moduleMap := parse("input")

	part1(instructions, moduleMap)
	part2(instructions, moduleMap)
}

func part2(instructions []string, moduleMap map[string][]string) {
	var locations []string

	for location, _ := range moduleMap {
		if location[2] == 'A' {
			locations = append(locations, location)
		}
	}

	index := 0
	steps := 0

	periods := make([]int, len(locations))
	for true {
		instr := instructions[index]

		for i := 0; i < len(locations); i++ {
			location := locations[i]
			nextOptions := moduleMap[location]
			if instr == "L" {
				locations[i] = nextOptions[0]
			} else if instr == "R" {
				locations[i] = nextOptions[1]
			}

			if locations[i][2] == 'Z' {
				periods[i] = steps + 1
			}
		}
		steps++
		index++

		if index == len(instructions) {
			index = 0
		}

		stopIterating := true
		for _, val := range periods {
			if val == 0 {
				stopIterating = false
			}
		}

		if stopIterating {
			break
		}
	}

	result := LCM(periods[0], periods[1], periods[2:]...)

	fmt.Println(result)
}

func GCD(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func LCM(a, b int, integers ...int) int {
	result := a * b / GCD(a, b)

	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}

	return result
}

func part1(instructions []string, moduleMap map[string][]string) {

	location := "AAA"
	index := 0
	steps := 0

	for location != "ZZZ" {
		instr := instructions[index]

		nextOptions := moduleMap[location]
		if instr == "L" {
			location = nextOptions[0]
		} else if instr == "R" {
			location = nextOptions[1]
		}

		index++
		if index == len(instructions) {
			index = 0
		}

		steps++
	}

	fmt.Println(steps)

}

func parse(s string) ([]string, map[string][]string) {
	file, err := os.Open(s)
	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}

	defer file.Close()

	buf := bufio.NewReader(file)
	scanner := bufio.NewScanner(buf)

	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	instructions := strings.Split(lines[0], "")
	modMap := make(map[string][]string)

	re := regexp.MustCompile(`(\w{3}) = \((\w{3}), (\w{3})\)`)
	for _, mod := range lines[2:] {
		matches := re.FindStringSubmatch(mod)

		modMap[matches[1]] = []string{matches[2], matches[3]}
	}

	return instructions, modMap
}
