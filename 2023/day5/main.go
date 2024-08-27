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
	maps []Transform
}

type Transform struct {
	source      Range
	destination int
}

type Seeds []int

type Range struct {
	start int
	end   int
}

func main() {

	input := parse("input")
	groups := extractGroups(input)
	seeds, maps := parseGroupData(groups)

	part1(seeds, maps)
	//part2(seeds, maps)
}

//func part2(seeds Seeds, mappers []Mapper) {
//	chunks := slices.Chunk(seeds, 2)
//	var seedRanges []Range
//	for chunk := range chunks {
//		seedRange := Range{chunk[0], chunk[0] + chunk[1] - 1}
//		seedRanges = append(seedRanges, seedRange)
//	}
//
//	lowest := math.MaxInt
//
//	for _, seedRange := range seedRanges {
//		collidableRanges := []Range{seedRange}
//		for _, mapper := range mappers {
//
//			//collide each range with each map
//			//iterate over each map in the mapper
//			//remapped values don't get retried
//			var newRanges []Range
//			for _, transform := range mapper.maps {
//				for _, collider := range collidableRanges {
//					mapped, unmapped := CollideRangeWithMap(collider, transform)
//					newRanges = append(newRanges, mapped...)
//					collidableRanges = unmapped
//				}
//			}
//
//			collidableRanges = append(collidableRanges, newRanges...)
//		}
//
//		for _, r := range collidableRanges {
//			if r.start < lowest {
//				lowest = r.start
//			}
//		}
//	}
//
//	fmt.Printf("part2 : %d\n", lowest)
//
//}

// return (remapped ranges), (unremapped ranges)
func CollideRangeWithMap(ranger Range, mapper []int) ([]Range, []Range) {
	//completely outside
	if ranger.end < mapper[1] || ranger.start > mapper[1]+mapper[2]-1 {
		return []Range{}, []Range{ranger}
	}

	//completely inside
	if ranger.start >= mapper[1] && ranger.end <= mapper[1]+mapper[2]-1 {

		newRange := Range{mapper[0] + ranger.start - mapper[1], mapper[0] + ranger.end - mapper[1] - 1}
		return []Range{newRange}, []Range{}
	}

	//left occlusion
	if ranger.start < mapper[1] && ranger.end > mapper[1] && ranger.end <= mapper[1]+mapper[2] {

		newRange := Range{mapper[0], mapper[0] + (ranger.end - mapper[1])}
		prevRange := Range{ranger.start, mapper[1]}

		return []Range{newRange}, []Range{prevRange}
	}

	//right occlusion
	if ranger.start >= mapper[1] && ranger.start < mapper[1]+mapper[2] && ranger.end > mapper[1]+mapper[2] {

		newRange := Range{mapper[0] + (ranger.start - mapper[1]), mapper[0] + mapper[2]}
		prevRange := Range{mapper[1] + mapper[2], ranger.end}

		return []Range{newRange}, []Range{prevRange}
	}

	//full occlusion
	if ranger.start <= mapper[1] && ranger.end >= mapper[1]+mapper[2]-1 {
		return []Range{Range{mapper[0], mapper[0] + mapper[2] - 1}}, []Range{Range{ranger.start, mapper[1] - 1}, Range{mapper[1] + mapper[2], ranger.end}}
	}

	return []Range{}, []Range{ranger}
}

func part1(seeds Seeds, maps []Mapper) {
	final := runSeeds(seeds, maps)

	low := slices.Min(final)
	println("part1 :", low)
}

func runSeeds(seeds Seeds, maps []Mapper) []int {
	var final []int
	for _, seed := range seeds {
		for _, m := range maps {
			for _, mp := range m.maps {
				result := mapVal(seed, mp)
				if result != seed {
					seed = result
					break
				}
			}
		}

		final = append(final, seed)
	}
	return final
}

func mapVal(seed int, mp Transform) int {
	if seed >= mp.source.start && seed <= (mp.source.end) {
		return seed - mp.source.start + mp.destination
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
		group := Mapper{maps: make([]Transform, len(m)-1)}

		group.name = strings.Split(m[0], " ")[0]

		for s, sets := range m[1:] {
			numStrs := strings.Split(sets, " ")
			nums := make([]int, len(numStrs))
			for i, str := range numStrs {
				nums[i], _ = strconv.Atoi(str)
			}

			group.maps[s] = Transform{source: Range{nums[1], nums[1] + nums[2] - 1}, destination: nums[0]}
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
