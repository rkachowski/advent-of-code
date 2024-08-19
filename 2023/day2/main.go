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

//TIP To run your code, right-click the code and select <b>Run</b>. Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.

func main() {
	input := parse("input")

	step1(input)
}

type Round struct {
	red   int
	green int
	blue  int
}

func step1(input []string) {
	var games [][]Round
	for _, line := range input {
		//split on game header
		cubeString := strings.Split(line, ":")[1]
		roundsStrings := strings.Split(cubeString, ";")

		var rounds []Round
		for _, roundString := range roundsStrings {
			blue := findMatches(roundString, `(\d+) blue`)
			red := findMatches(roundString, `(\d+) red`)
			green := findMatches(roundString, `(\d+) green`)

			rounds = append(rounds, Round{red: red, green: green, blue: blue})
		}

		games = append(games, rounds)
	}

	valid := 0
	for id, game := range games {
		if !anyInvalid(game, part1Invalid) {
			valid = valid + (id + 1)
		}
	}

	fmt.Printf("valid %d\n", valid)
}

type RoundComparator func(Round) bool

func anyInvalid(rounds []Round, comp RoundComparator) bool {
	for _, v := range rounds {
		if comp(v) {
			return true
		}
	}
	return false
}

func part1Invalid(round Round) bool {
	if round.red <= 12 && round.green <= 13 && round.blue <= 14 {
		return false
	} else {
		return true
	}
}

func findMatches(input string, pattern string) int {
	r, _ := regexp.Compile(pattern)
	matches := r.FindStringSubmatch(input)

	if len(matches) > 1 {
		val, err := strconv.Atoi(matches[1])
		if err != nil {
			log.Fatalf("Error converting %s to int", matches[1])
		}

		return val
	} else {
		return 0
	}

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

//TIP See GoLand help at <a href="https://www.jetbrains.com/help/go/">jetbrains.com/help/go/</a>.
// Also, you can try interactive lessons for GoLand by selecting 'Help | Learn IDE Features' from the main menu.
