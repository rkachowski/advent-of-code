package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"math"
	"strconv"
	"strings"
)

func main() {
	input := utils.ParseFile("input")

	values := map[uint64][]int{}

	values = extractInput(input)

	possibles := map[uint64][]int{}

	for v, calibs := range values {
		if isPossiblePart1(v, calibs) {
			possibles[v] = calibs
		}
	}

	total := uint64(0)
	for v, _ := range possibles {
		total += v
	}

	log.Printf("Total possibles: %v", total)
}

func extractInput(input []string) map[uint64][]int {
	result := map[uint64][]int{}

	for _, line := range input {
		parts := strings.Split(line, ": ")
		goal, _ := strconv.ParseUint(parts[0], 10, 64)

		calibrations := []int{}
		for _, c := range strings.Split(parts[1], " ") {
			calibration, _ := strconv.Atoi(c)
			calibrations = append(calibrations, calibration)
		}
		result[goal] = calibrations
	}

	return result
}

func isPossiblePart1(targetVal uint64, calibs []int) bool {
	maxPerms := int(math.Pow(2, float64(len(calibs))))

	i := 0
	for i < maxPerms {
		total := uint64(0)
		for j, calib := range calibs {
			if j == 0 {
				total = uint64(calib)
				continue
			}
			//early exit if too large
			if total > targetVal {
				break
			}
			if (i & (1 << j)) != 0 {
				total += uint64(calib)
			} else {
				total *= uint64(calib)
			}
		}

		if total == targetVal {
			return true
		}
		i++
	}

	return false
}
