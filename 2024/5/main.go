package main

import (
	"fmt"
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"slices"
	"sort"
	"strconv"
	"strings"
)

func main() {

	input := utils.ParseFile("input")

	rules, updates := parseRulesAndUpdates(input)

	validUpdates, invalidUpdates := findValidUpdates(updates, rules)

	//part1
	sum := sumMiddleValues(validUpdates)
	fmt.Println(sum)

	//part 2
	var reordered [][]string
	for _, update := range invalidUpdates {
		var validRules [][]string

		vals := map[string]bool{}
		for _, n := range update {
			vals[n] = true
		}

		for _, rule := range rules {
			if vals[rule[0]] && vals[rule[1]] {
				validRules = append(validRules, rule)
			}
		}

		// sort the update with the valid rules as a sorting operator
		sort.Slice(update, func(i, j int) bool {
			l := update[i]
			r := update[j]

			for _, rule := range validRules {
				if l == rule[0] && r == rule[1] {
					return true
				}
			}

			return false
		})

		reordered = append(reordered, update)
	}

	pt2 := sumMiddleValues(reordered)
	log.Println(pt2)
}

func sumMiddleValues(validUpdates [][]string) int {
	sum := 0
	for _, update := range validUpdates {
		middleVal := update[len(update)/2]
		m, _ := strconv.Atoi(middleVal)
		sum += m
	}
	return sum
}

func findValidUpdates(updates [][]string, rules [][]string) ([][]string, [][]string) {
	var validUpdates [][]string
	var invalidUpdates [][]string
	for _, update := range updates {
		valid := true
		for _, rule := range rules {
			l := slices.Index(update, rule[0])
			r := slices.Index(update, rule[1])

			if l >= 0 && r >= 0 && l > r {
				valid = false
				break
			}
		}

		if valid {
			validUpdates = append(validUpdates, update)
		} else {
			invalidUpdates = append(invalidUpdates, update)
		}
	}
	return validUpdates, invalidUpdates
}

func parseRulesAndUpdates(input []string) ([][]string, [][]string) {
	var rules [][]string
	var updates [][]string

	for _, line := range input {
		if strings.Index(line, "|") >= 0 {
			split := strings.Split(line, "|")
			rules = append(rules, split)
		}
		if strings.Index(line, ",") >= 0 {
			split := strings.Split(line, ",")
			updates = append(updates, split)
		}
	}
	return rules, updates
}
