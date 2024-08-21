package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
)

//TIP To run your code, right-click the code and select <b>Run</b>. Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.

type Game struct {
	winners []int
	numbers []int
}

func main() {
	input := parse("input")
	games := formatGames(input)

	part1(games)
}

func part1(games []Game) {
	total := 0

	for _, game := range games {
		gameTotal := 0
		for _, number := range game.numbers {
			if contains(game.winners, number) {
				gameTotal++
			}
		}

		if gameTotal > 0 {
			total = total + int(math.Pow(float64(2), float64(gameTotal-1)))
		}
	}

	println(total)
}

func contains(s []int, e int) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func formatGames(input []string) []Game {
	var games []Game

	for _, line := range input {
		gameStr := strings.Split(line, ":")[1]
		numbers := strings.Split(gameStr, "|")

		game := Game{winners: parseNumStr(numbers[0]), numbers: parseNumStr(numbers[1])}
		games = append(games, game)
	}

	return games
}

func parseNumStr(numberString string) []int {
	var numbers []int
	numberString = strings.TrimSpace(numberString)
	re := regexp.MustCompile(`\s+`)
	for _, str := range re.Split(numberString, -1) {
		num, _ := strconv.Atoi(str)
		numbers = append(numbers, num)
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
