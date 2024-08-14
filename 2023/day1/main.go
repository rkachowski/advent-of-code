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

func main() {
	log.Println("yo fuck this")

	lines := ParseFile("input")

	var numbers []int

	for _, line := range lines {
		fmt.Println(line)
		matches := FirstAndLastNumber(line)
		result, err := MapToNumbers(matches)
		if err != nil {
			fmt.Println("Error:", err)
		} else {
			fmt.Println("Resulting number:", result)
		}

		numbers = append(numbers, result)
	}

	sum := SumArray(numbers)

	log.Printf("result is %d", sum)
}

func ParseFile(path string) []string {
	file, err := os.Open(path)
	if err != nil {
		fmt.Println("Error:", err)
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

func FirstAndLastNumber(line string) []string {
	pattern := `\d`
	re, err := regexp.Compile(pattern)
	if err != nil {
		fmt.Println("Error compiling regex:", err)
		return nil
	}
	matches := re.FindAllString(line, -1)
	fmt.Printf("%v", matches)

	if len(matches) > 0 {
		return []string{matches[0], matches[len(matches)-1]}
	}
	panic(fmt.Sprintf("Invalid input %s found %d", line, len(matches)))
}

func MapToNumbers(numbers []string) (int, error) {
	concatenated := strings.Join(numbers, "")

	number, err := strconv.Atoi(concatenated)
	if err != nil {
		return 0, err
	}

	return number, nil
}

func SumArray(numbers []int) int {
	sum := 0
	for _, number := range numbers {
		sum += number
	}
	return sum
}
