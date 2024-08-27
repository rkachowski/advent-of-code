package main

import (
	"bufio"
	"fmt"
	"math"
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
	part2(seeds, maps)
}

func (t Transform) Transform(i int) int {
	return i - t.source.start + t.destination
}

func (r Range) Contains(i int) bool {
	if i >= r.start && i <= r.end {
		return true
	}

	return false
}

// return (tranformed, untransformed) slices of ranges
func (t Transform) CollideWithRange(r Range) ([]Range, []Range) {
	//completely outside
	if r.end < t.source.start || r.start > t.source.end {
		return []Range{}, []Range{r}
	}

	//completely inside
	if t.source.Contains(r.start) && t.source.Contains(r.end) {
		newRange := Range{t.Transform(r.start), t.Transform(r.end)}
		return []Range{newRange}, []Range{}
	}

	//left occlusion
	if !t.source.Contains(r.start) && t.source.Contains(r.end) {
		newRange := Range{t.Transform(t.source.start), t.Transform(r.end)}
		prevRange := Range{r.start, t.source.start - 1}

		return []Range{newRange}, []Range{prevRange}
	}

	//right occlusion
	if t.source.Contains(r.start) && !t.source.Contains(r.end) {
		newRange := Range{t.Transform(r.start), t.Transform(t.source.end)}
		prevRange := Range{t.source.end + 1, r.end}

		return []Range{newRange}, []Range{prevRange}
	}

	//full occlusion
	if r.Contains(t.source.start) && r.Contains(t.source.end) {
		prevRange := Range{r.start, t.source.start - 1}
		postRange := Range{t.source.end + 1, r.end}
		newRange := Range{t.Transform(t.source.start), t.Transform(t.source.end)}

		return []Range{newRange}, []Range{prevRange, postRange}
	}

	return []Range{}, []Range{r}
}

func (m Mapper) CollideSeedRange(r Range) []Range {
	toProcess := []Range{r}
	var newRanges []Range

	for _, transform := range m.maps {
		var nextIter []Range
		for _, collider := range toProcess {
			//fmt.Printf("range %v transform %v\n", collider, transform)
			mapped, unmapped := transform.CollideWithRange(collider)
			//fmt.Printf("mapped %v unmapped %v\n", mapped, unmapped)
			if len(mapped) > 0 {
				newRanges = append(newRanges, mapped...)
				nextIter = append(nextIter, unmapped...)
			} else {
				nextIter = append(nextIter, unmapped...)
			}
		}

		toProcess = nextIter
	}

	result := append(toProcess, newRanges...)
	return result
}

func part2(seeds Seeds, mappers []Mapper) {
	chunks := slices.Chunk(seeds, 2)
	var seedRanges []Range
	for chunk := range chunks {
		seedRange := Range{chunk[0], chunk[0] + chunk[1] - 1}
		seedRanges = append(seedRanges, seedRange)
	}

	lowest := math.MaxInt

	for _, seedRange := range seedRanges {
		toProcess := []Range{seedRange}
		for _, mapper := range mappers {
			var output []Range
			//fmt.Printf("Mapping %s -> %v\n", mapper.name, toProcess)
			for _, p := range toProcess {
				result := mapper.CollideSeedRange(p)
				output = append(output, result...)
			}
			//fmt.Printf("Output %v\n", output)
			toProcess = output
		}

		for _, r := range toProcess {
			if r.start < lowest {
				lowest = r.start
			}
		}
	}

	fmt.Printf("part2 : %d\n", lowest)

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
	if mp.source.Contains(seed) {
		return mp.Transform(seed)
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
