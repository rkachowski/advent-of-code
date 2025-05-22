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
	input := utils.ParseFile("test")
	grid := utils.GridFromInput(input)

	visited := findVisitedSquares(grid)

	log.Printf("Visited: %v", len(visited))

	loops := 0
	for position, _ := range visited {
		if runGridWithObstacle(grid, position) {
			loops += 1
		}
	}
	log.Printf("Loops: %v", loops)
}

type VisitedCoord struct {
	x, y, dir int
}

func runGridWithObstacle(grid *utils.Grid[string], position Coord) bool {
	x, y := grid.FindIndex("^")
	pos := []int{x, y}
	dir := 0

	visited := map[VisitedCoord]bool{}
	for {
		//loop detection
		if detectLoop(visited, pos, dir) {
			return true
		}

		//step forward in that direction
		pos[0] += dirs[dir][0]
		pos[1] += dirs[dir][1]

		//check if the next step is outside
		next := []int{pos[0] + dirs[dir][0], pos[1] + dirs[dir][1]}

		//check if next is an obstacle, then turn
		for {
			if !grid.Inside(next[0], next[1]) {
				break // Exit if the next step is outside the grid
			}
			nextIsObstacle := next[0] == position.x && next[1] == position.y
			if *grid.Get(next[0], next[1]) == "#" || nextIsObstacle {
				dir++
				if dir >= len(dirs) {
					dir = 0
				}

				next = []int{pos[0] + dirs[dir][0], pos[1] + dirs[dir][1]}

				if *grid.Get(next[0], next[1]) == "#" || nextIsObstacle {
					continue
				} else {
					break
				}
			} else {
				break
			}
		}

		if !grid.Inside(next[0], next[1]) {
			break
		}
	}

	return false
}

func detectLoop(visited map[VisitedCoord]bool, pos []int, dir int) bool {
	coord := VisitedCoord{x: pos[0], y: pos[1], dir: dir}
	if visited[coord] {
		return true
	}
	visited[coord] = true
	return false
}

func findVisitedSquares(grid *utils.Grid[string]) map[Coord]bool {
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
	return visited
}
