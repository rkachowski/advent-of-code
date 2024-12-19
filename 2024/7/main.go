package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"math"
	"strconv"
	"strings"
)

type StateSpaceGenerator struct {
	positions int
	states    int
	current   []int
	done      bool
}

func NewStateSpaceGenerator(positions, states int) *StateSpaceGenerator {
	return &StateSpaceGenerator{
		positions: positions,
		states:    states,
		current:   make([]int, positions),
		done:      false,
	}
}

func (gen *StateSpaceGenerator) Next() ([]int, bool) {
	if gen.done {
		return nil, false
	}

	// Return a copy of the current combination
	result := make([]int, len(gen.current))
	copy(result, gen.current)

	// Generate the next combination
	for i := len(gen.current) - 1; i >= 0; i-- {
		gen.current[i]++
		if gen.current[i] < gen.states {
			break
		}
		gen.current[i] = 0
		if i == 0 {
			gen.done = true
		}
	}

	return result, true
}

func main() {
	input := utils.ParseFile("input")

	values := map[uint64][]int{}

	values = extractInput(input)

	total := calcTotal(values, isPossiblePart1)

	log.Printf("Total possibles part 1: %v", total)

	total = calcTotal(values, isPossiblePart2)
	log.Printf("Total possibles part 2: %v", total)
}

type Validator func(targetVal uint64, calibs []int) bool

func calcTotal(values map[uint64][]int, validator Validator) uint64 {
	possibles := map[uint64][]int{}

	for v, calibs := range values {
		if validator(v, calibs) {
			possibles[v] = calibs
		}
	}

	total := uint64(0)
	for v, _ := range possibles {
		total += v
	}
	return total
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

func isPossiblePart2(targetVal uint64, calibs []int) bool {

	state := NewStateSpaceGenerator(len(calibs), 3)
	for !state.done {
		total := uint64(0)
		for j, calib := range calibs {
			if j == 0 {
				total = uint64(calib)
				continue
			}

			switch state.current[j] {
			case 0:
				total += uint64(calib)
			case 1:
				total *= uint64(calib)
			case 2:
				l := strconv.Itoa(int(total))
				r := strconv.Itoa(calib)
				combined, _ := strconv.Atoi(l + r)
				total = uint64(combined)
			}

		}

		if total == targetVal {
			return true
		}
		state.Next()
	}

	return false
}
