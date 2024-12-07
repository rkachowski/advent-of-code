package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
	"strings"
)

func main() {
	input := utils.ParseFile("test2")
	grid := utils.GridFromInput(input)

	countXmas(grid)
	countMas(grid)
}

func countMas(grid *utils.Grid[string]) {
	mas := 0
	for x := 0; x < grid.Width; x++ {
		log.Printf("x: %v", x)
		for y := 0; y < grid.Height; y++ {
			log.Printf("y: %v", y)
			c := *grid.Get(x, y)
			if c == "M" {
				m1 := grid.Get(x+2, y)
				m2 := grid.Get(x, y+2)
				if (m1 != nil && *m1 == "M") || (m2 != nil && *m2 == "M") {
					mas += 1
				}
			}
		}
	}

	log.Printf("mas: %d", mas)
}

func countXmas(grid *utils.Grid[string]) {

	xmas := 0
	for x := 0; x < grid.Width; x++ {
		for y := 0; y < grid.Height; y++ {
			c := *grid.Get(x, y)
			if c == "X" {
				xmas += getXmases(x, y, grid)
			}
		}
	}

	log.Printf("xmas: %d", xmas)
}

func getXmases(x int, y int, grid *utils.Grid[string]) int {
	dirs := directions(x, y)
	xmases := 0
	for _, dir := range dirs {
		line := make([]string, 4)
		for _, coord := range dir {
			cell := grid.Get(coord[0], coord[1])

			if cell != nil {
				line = append(line, string(*cell))
			}
		}

		if strings.Join(line, "") == "XMAS" {
			xmases += 1
		}
	}

	return xmases
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
