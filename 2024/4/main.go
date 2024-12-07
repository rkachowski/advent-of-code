package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"strings"
)

func main() {
	input := utils.ParseFile("input")
	grid := utils.GridFromInput(input)

	countXmas(grid)
}

func countXmas(grid *utils.Grid[string]) {

	xmas := 0
	for x := 0; x < grid.Width; x++ {
		for y := 0; y < grid.Height; y++ {
			c := *grid.Get(x, y)
			if c == "X" {
				//get all directions
				xmases := getXmases(x, y, grid)
				xmas += len(xmases)
			}
		}
	}

	log.Printf("xmas: %d", xmas)
}

func getXmases(x int, y int, grid *utils.Grid[string]) []string {
	dirs := directions(x, y)
	var potentialXmases [][]string
	for _, dir := range dirs {
		var line []string
		for _, coord := range dir {
			cell := grid.Get(coord[0], coord[1])

			if cell != nil {
				line = append(line, *cell)
			}
		}

		potentialXmases = append(potentialXmases, line)
	}

	var actualXmas []string
	for _, line := range potentialXmases {
		str := strings.Join(line, "")
		if str == "XMAS" {
			actualXmas = append(actualXmas, str)
		}
	}

	return actualXmas
}

func directions(x, y int) [][][]int {
	forwards := [][]int{
		{x, y},
		{x + 1, y},
		{x + 2, y},
		{x + 3, y},
	}
	backwards := [][]int{
		{x, y},
		{x - 1, y},
		{x - 2, y},
		{x - 3, y},
	}
	up := [][]int{
		{x, y},
		{x, y - 1},
		{x, y - 2},
		{x, y - 3},
	}
	down := [][]int{
		{x, y},
		{x, y + 1},
		{x, y + 2},
		{x, y + 3},
	}
	dr := [][]int{
		{x, y},
		{x + 1, y + 1},
		{x + 2, y + 2},
		{x + 3, y + 3},
	}
	dl := [][]int{
		{x, y},
		{x - 1, y + 1},
		{x - 2, y + 2},
		{x - 3, y + 3},
	}
	ur := [][]int{
		{x, y},
		{x + 1, y - 1},
		{x + 2, y - 2},
		{x + 3, y - 3},
	}
	ul := [][]int{
		{x, y},
		{x - 1, y - 1},
		{x - 2, y - 2},
		{x - 3, y - 3},
	}

	return [][][]int{forwards, backwards, up, down, ur, ul, dl, dr}
}
