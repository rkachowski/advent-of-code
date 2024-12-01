package main

import (
	"bufio"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	lines := parse("input")

	var left []int
	var right []int

	for _, line := range lines {
		parts := strings.Split(line, "   ")
		l, _ := strconv.Atoi(parts[0])
		r, _ := strconv.Atoi(parts[1])

		left = append(left, l)
		right = append(right, r)
	}

	sort.Ints(left)
	sort.Ints(right)

	var result []int
	for i, _ := range left {
		diff := left[i] - right[i]

		if diff < 0 {
			result = append(result, -diff)
		} else {
			result = append(result, diff)
		}
	}

	total := 0
	for _, r := range result {
		total += r
	}

	log.Print(total)

	similarity := make(map[int]int)

	for _, el := range left {
		c := count(el, right)
		similarity[el] = c * el
	}

	total = 0
	for _, r := range similarity {
		total += r
	}
	log.Print(total)
}

func count(val int, toCheck []int) int {
	result := 0
	for _, el := range toCheck {
		if el == val {
			result+= 1
		}

		if el > val {
			break
		}
	}

	return result
}

func parse(filename string)[]string {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatalf("Can't open file %v", err)
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines
}