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
	lines := ParseFile("input")

	Part1(lines)
	Part2("input")
}

func Part2(file string) {
	lines := ParseFile(file)
	var numbers []int
	for _, line := range lines {
		matches := ExtractNumbers(line)

		if matches == nil {
			continue
		}

		result, err := MapToNumbers(matches)
		if err != nil {
			fmt.Println("Error:", err)
		}

		numbers = append(numbers, result)
	}

	sum := SumArray(numbers)

	log.Printf("part 2 result is %d", sum)
}

func Part1(lines []string) {
	var numbers []int
	for _, line := range lines {
		matches := FirstAndLastNumber(line)
		result, err := MapToNumbers(matches)
		if err != nil {
			fmt.Println("Error:", err)
		}

		numbers = append(numbers, result)
	}

	sum := SumArray(numbers)

	log.Printf("part 1 result is %d", sum)
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

	if len(matches) > 0 {
		return []string{matches[0], matches[len(matches)-1]}
	}
	panic(fmt.Sprintf("Invalid input %s found %d", line, len(matches)))
}

func ExtractNumbers(line string) []string {
	var result []string
	substrings := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

	n := len(line)

	for i := 0; i < n; i++ {
		for _, substr := range substrings {
			// Check if the substring can be found starting from index i
			if strings.HasPrefix(line[i:], substr) {
				result = append(result, convertStringToNumber(substr))
			}
		}
	}

	return []string{result[0], result[len(result)-1]}
}

func convertStringToNumber(word string) string {
	numberMap := map[string]string{
		"one":   "1",
		"two":   "2",
		"three": "3",
		"four":  "4",
		"five":  "5",
		"six":   "6",
		"seven": "7",
		"eight": "8",
		"nine":  "9",
	}

	word = strings.ToLower(word)
	if value, exists := numberMap[word]; exists {
		return value
	}

	return word
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
