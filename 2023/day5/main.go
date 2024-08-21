package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

type Mapper struct {
	name string
	maps [][]int
}

type Seeds []int

func main() {

	input := parse("input")
	groups := extractGroups(input)
	seeds, maps := parseGroupData(groups)

	final := runSeeds(seeds, maps)

	low := slices.Min(final)
	println("part1 :", low)
}

func runSeeds(seeds Seeds, maps []Mapper) []int {
	var final []int
	for _, seed := range seeds {
		//fmt.Printf("--- seed: %d\n", seed)
		for _, m := range maps {
			for _, mp := range m.maps {
				result := mapVal(seed, mp)
				if result != seed {
					seed = result
					break
				}
			}
			//fmt.Printf("%s: %d\n", m.name, seed)
		}

		final = append(final, seed)
	}
	return final
}

func mapVal(seed int, mp []int) int {
	if seed >= mp[1] && seed < (mp[1]+mp[2]) {
		return seed - mp[1] + mp[0]
	}
	return seed
}

func parseGroupData(groups [][]string) (Seeds, []Mapper) {
	seedList, mapGroups := groups[0], groups[1:]

	seeds := strings.Split(seedList[0], ":")[1]
	seeds = strings.Trim(seeds, " ")
	var outputSeeds Seeds
	for _, seed := range strings.Split(seeds, " ") {
		s, _ := strconv.Atoi(seed)
		outputSeeds = append(outputSeeds, s)
	}

	var outputMaps []Mapper
	for _, m := range mapGroups {
		group := Mapper{maps: make([][]int, len(m)-1)}

		group.name = strings.Split(m[0], " ")[0]

		for s, sets := range m[1:] {
			numStrs := strings.Split(sets, " ")
			nums := make([]int, len(numStrs))
			for i, str := range numStrs {
				nums[i], _ = strconv.Atoi(str)
			}

			group.maps[s] = nums
		}

		outputMaps = append(outputMaps, group)
	}

	return outputSeeds, outputMaps
}

func extractGroups(input []string) [][]string {
	var groups [][]string
	var currentGroup []string
	for _, line := range input {
		match, _ := regexp.Match(`^\s?$`, []byte(line))
		if !match {
			currentGroup = append(currentGroup, line)
		} else {
			groups = append(groups, currentGroup)
			currentGroup = []string{}
		}
	}

	groups = append(groups, currentGroup)
	return groups
}

func parse(s string) []string {

	file, err := os.Open(s)
	if err != nil {
		fmt.Println(err)
		return nil
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines
}
