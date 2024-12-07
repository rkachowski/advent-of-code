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
	countMas(grid)
}

func countMas(grid *utils.Grid[string]) {
	mas := 0
	for x := 0; x < grid.Width; x++ {
		for y := 0; y < grid.Height; y++ {
			c := *grid.Get(x, y)
			if c == "M" {
				m1 := grid.Get(x+2, y)
				m2 := grid.Get(x, y+2)
				if m1 != nil && *m1 == "M" {
					//up
					a := grid.Get(x+1, y-1)
					s1 := grid.Get(x, y-2)
					s2 := grid.Get(x+2, y-2)

					if validAS(a, s1, s2) {
						mas++
					}

					//down
					a = grid.Get(x+1, y+1)
					s1 = grid.Get(x, y+2)
					s2 = grid.Get(x+2, y+2)

					if validAS(a, s1, s2) {
						mas++
					}
				}

				if m2 != nil && *m2 == "M" {
					//left
					a := grid.Get(x-1, y+1)
					s1 := grid.Get(x-2, y)
					s2 := grid.Get(x-2, y+2)

					if validAS(a, s1, s2) {
						mas++
					}

					//right
					a = grid.Get(x+1, y+1)
					s1 = grid.Get(x+2, y)
					s2 = grid.Get(x+2, y+2)

					if validAS(a, s1, s2) {
						mas++
					}
				}
			}
		}
	}

	log.Printf("mas: %d", mas)
}

func validAS(a *string, s1 *string, s2 *string) bool {
	if a != nil && *a == "A" && s1 != nil && *s1 == "S" && s2 != nil && *s2 == "S" {
		return true
	}
	return false
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
