package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
)

//TIP <p>To run your code, right-click the code and select <b>Run</b>.</p> <p>Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.</p>

func main() {
	lines := parseFile("input")
	reports := formatInput(lines)

	//part 1
	safeCount := 0
	for _, line := range reports {
		safe, _ := isSafe(line)
		if safe {
			safeCount++
		}
	}

	log.Printf("Part 1: %v", safeCount)

	//part 2
	safe2 := 0
	var recheck [][]int
	for _, line := range reports {
		_, problems := isSafe(line)
		if len(problems) < 1 {
			safe2++
		} else {
			recheck = append(recheck, line)
		}
	}

	//brute force lets go
	problemDampened := 0
	for _, line := range recheck {
		for i, _ := range line {
			// append modifies the underlying array aaahahahah what
			temp := append([]int{}, line[:i]...)
			test := append(temp, line[i+1:]...)
			safe, _ := isSafe(test)
			if safe {
				problemDampened++
				break
			}
		}
	}

	log.Printf("Part 2: %v", safe2+problemDampened)
}

func isSafe(report []int) (bool, []int) {
	decreasing := false
	var problemLevels []int
	for i, level := range report {
		if i == 0 {
			continue
		}

		if i == 1 {
			if report[0] > level {
				decreasing = true
			}
			if report[0] == level {
				problemLevels = append(problemLevels, level)
				continue
			}
			if invalidJump(report[0], level) {
				problemLevels = append(problemLevels, level)
				continue
			}
		}

		//check direction
		if decreasing {
			if report[i-1] <= level {
				problemLevels = append(problemLevels, level)
				continue
			}
		} else if report[i-1] >= level {
			problemLevels = append(problemLevels, level)
			continue
		}

		//check difference
		if invalidJump(report[i-1], level) {
			problemLevels = append(problemLevels, level)
			continue
		}
	}

	return len(problemLevels) == 0, problemLevels
}

func invalidJump(v1 int, v2 int) bool {
	diff := abs(v1, v2)
	if diff < 1 || diff > 3 {
		return true
	}
	return false
}
func abs(v1 int, v2 int) int {
	result := v1 - v2
	if result < 0 {
		result *= -1
	}
	return result
}

func formatInput(lines []string) [][]int {
	var output = make([][]int, len(lines))
	for i, line := range lines {
		parts := strings.Split(line, " ")
		numbers := make([]int, len(parts))
		for j, part := range parts {
			numbers[j], _ = strconv.Atoi(part)
		}

		output[i] = numbers
	}

	return output
}

func parseFile(filename string) []string {
	file, err := os.Open(filename)

	if err != nil {
		panic(err)
	}
	defer file.Close()
	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}
