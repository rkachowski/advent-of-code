package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
	"log"
)

type Coord struct {
	x, y int
}

var dirs = [][]int{
	{0, -1},
	{1, 0},
	{0, 1},
	{-1, 0},
}

func main() {
	input := utils.ParseFile("input")
	grid := utils.GridFromInput(input)

	x, y := grid.FindIndex("^")
	pos := []int{x, y}
	dir := 0

	visited := map[Coord]bool{}
	for {
		visited[Coord{x: pos[0], y: pos[1]}] = true
		pos[0] += dirs[dir][0]
		pos[1] += dirs[dir][1]

		next := []int{pos[0] + dirs[dir][0], pos[1] + dirs[dir][1]}
		if grid.Inside(next[0], next[1]) && *grid.Get(next[0], next[1]) == "#" {
			dir++
			if dir >= len(dirs) {
				dir = 0
			}
		}

		if !grid.Inside(next[0], next[1]) {
			visited[Coord{x: pos[0], y: pos[1]}] = true
			break
		}
	}

	log.Printf("Visited: %v", len(visited))
}
