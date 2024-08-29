package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
)

//TIP To run your code, right-click the code and select <b>Run</b>. Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.

func main() {
	instructions, moduleMap := parse("input")

	part1(instructions, moduleMap)
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

		fmt.Printf("Matches %#v\n", matches)
		modMap[matches[1]] = []string{matches[2], matches[3]}
	}

	return instructions, modMap
}
