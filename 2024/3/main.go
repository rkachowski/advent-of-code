package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

//TIP <p>To run your code, right-click the code and select <b>Run</b>.</p> <p>Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.</p>

func main() {
	input := utils.ParseFile("input")

	flattened := strings.Join(input, "")
	total := extractMuls(flattened)
	log.Println(total)

	matches := extractEverything(flattened)
	var validMuls [][]string
	enabled := true
	for _, m := range matches {
		if m[0] == "don't()" {
			enabled = false
		} else if m[0] == "do()" {
			enabled = true
		} else if enabled == true {
			validMuls = append(validMuls, m)
		}
	}

	part2 := sumMuls(validMuls)

	log.Println(part2)
}

func extractMuls(input string) int {
	pattern := `mul\((\d+),(\d+)\)`

	re := regexp.MustCompile(pattern)
	var matches [][]string
	muls := re.FindAllStringSubmatch(input, -1)
	matches = slices.Concat(matches, muls)

	return sumMuls(matches)
}

func sumMuls(matches [][]string) int {
	total := 0
	for _, m := range matches {
		i, _ := strconv.Atoi(m[1])
		j, _ := strconv.Atoi(m[2])
		total += i * j
	}
	return total
}

func extractEverything(input string) [][]string {
	pattern := `mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)`

	re := regexp.MustCompile(pattern)
	matches := re.FindAllStringSubmatch(input, -1)

	return matches
}
