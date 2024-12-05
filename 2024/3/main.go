package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"regexp"
	"slices"
	"strconv"
)

//TIP <p>To run your code, right-click the code and select <b>Run</b>.</p> <p>Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.</p>

func main() {
	input := utils.ParseFile("input")

	pattern := `mul\((\d+),(\d+)\)`

	re := regexp.MustCompile(pattern)
	var matches [][]string
	for _, line := range input {
		muls := re.FindAllStringSubmatch(line, -1)
		matches = slices.Concat(matches, muls)
	}

	total := 0

	for _, m := range matches {
		i, _ := strconv.Atoi(m[1])
		j, _ := strconv.Atoi(m[2])
		total += i * j
	}
	log.Println(total)
}
