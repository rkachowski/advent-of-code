package main

import (
	"fmt"
	"slices"
	"testing"
)

func TestFailures(t *testing.T) {
	var tests = []struct {
		testRange            Range
		testMapper           Mapper
		expectedOutputLength int
		expectedOutput       []Range
	}{
		{Range{1, 10}, makeMapper(5, 7, 20, "testmap"), 3, makeOutput(1, 4, 8, 10, 20, 22)},
		{Range{1, 10}, makeMapper(5, 10, 20, "testmap"), 2, makeOutput(1, 4, 20, 25)},
		{Range{1, 10}, makeMapper(0, 5, 20, "testmap"), 2, makeOutput(6, 10, 21, 25)},
		{Range{1, 10}, makeMapper(11, 15, 20, "testmap"), 1, makeOutput()},
		{Range{1, 10}, makeMapper(-5, -1, 20, "testmap"), 1, makeOutput()},
	}
	for i, tt := range tests {
		testname := fmt.Sprintf("Test Collisions %d", i)
		t.Run(testname, func(t *testing.T) {
			output := tt.testMapper.CollideSeedRange(tt.testRange)
			if len(output) != tt.expectedOutputLength {
				t.Errorf("got %v, expected length %d", output, tt.expectedOutputLength)
			}

			if len(tt.expectedOutput) > 0 {
				for i, expected := range tt.expectedOutput {
					if output[i] != expected {
						t.Errorf("got %v, expected %v", output, tt.expectedOutput)
					}
				}
			}
		})
	}
}

func makeRange(start, end int) Range {
	return Range{start, end}
}

func makeMapper(start, end, destination int, name string) Mapper {
	return Mapper{name, []Transform{Transform{makeRange(start, end), destination}}}
}

func makeOutput(vals ...int) []Range {
	chunks := slices.Chunk(vals, 2)
	var output []Range
	for chunk := range chunks {
		output = append(output, makeRange(chunk[0], chunk[1]))
	}

	return output
}
