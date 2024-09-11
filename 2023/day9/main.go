package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	input := parse("input")
	part1(input)
}

func part1(input [][]int) {
	var nexts []int
	for _, line := range input {
		//for _, d := range line {
		//	fmt.Printf("%d ", d)
		//}
		//fmt.Printf("\n")
		next := runLine(line)
		nexts = append(nexts, next)
	}

	fmt.Printf("%d", sum(nexts))

}
func sum(line []int) int {
	sum := line[0]
	for _, n := range line[1:] {
		sum += n
	}

	return sum

}
func runLine(line []int) int {
	var diffs []int
	for i := 0; i < len(line)-1; i++ {
		cur := line[i]
		next := line[i+1]

		diffs = append(diffs, next-cur)
	}

	//for _, d := range diffs {
	//	fmt.Printf("%d ", d)
	//}
	//fmt.Printf("\n")

	if allZero(diffs) {
		return line[len(line)-1]
	} else {
		prevVal := runLine(diffs)
		nextVal := line[len(line)-1]
		//fmt.Printf("next val : %d prev val : %d \n ", nextVal, prevVal)
		return nextVal + prevVal
	}
}

func allZero(vals []int) bool {
	for _, val := range vals {
		if val != 0 {
			return false
		}
	}

	return true
}

func parse(s string) [][]int {
	file, err := os.Open(s)

	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}

	buf := bufio.NewReader(file)
	scanner := bufio.NewScanner(buf)

	var result [][]int
	for scanner.Scan() {
		text := scanner.Text()
		vals := strings.Split(text, " ")

		var line []int
		for _, val := range vals {
			output, err := strconv.Atoi(val)
			if err != nil {
				log.Fatalf("Error converting %v to int: %v", val, err)
			}
			line = append(line, output)
		}
		result = append(result, line)
	}

	return result
}
