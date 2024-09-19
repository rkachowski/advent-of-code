package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

type Grid struct {
	cells [][]string
}

type Coord struct {
	x int
	y int
}

type Cell struct {
	coord    Coord
	contents string
}

func (g Grid) Print() {
	for y := 0; y < len(g.cells); y++ {
		for x := 0; x < len(g.cells[0]); x++ {
			fmt.Print(g.cells[y][x])
		}
		fmt.Print("\n")
	}
}

type CellMatcher func(contents string) bool

func (g Grid) FindCell(finder CellMatcher) (Coord, bool) {
	for y := 0; y < len(g.cells); y++ {
		for x := 0; x < len(g.cells[0]); x++ {
			if finder(g.cells[y][x]) {
				return Coord{x, y}, true
			}
		}
	}
	return Coord{-1, -1}, false
}

func (g Grid) Cell(x int, y int) string {
	return g.cells[y][x]
}

func (g Grid) Set(x int, y int, val string) {
	g.cells[y][x] = val
}

func (g Grid) Neighbors(of Coord) []Cell {
	var result []Cell
	//left
	if of.x > 0 {
		x := of.x - 1
		if g.Cell(x, of.y) == "-" || g.Cell(x, of.y) == "L" || g.Cell(x, of.y) == "F" {
			left := Cell{coord: Coord{x: x, y: of.y}, contents: g.Cell(x, of.y)}
			result = append(result, left)
		}
	}
	//right
	if of.x < len(g.cells[0])-1 {
		x := of.x + 1
		if g.Cell(x, of.y) == "-" || g.Cell(x, of.y) == "7" || g.Cell(x, of.y) == "J" {
			right := Cell{coord: Coord{x: x, y: of.y}, contents: g.Cell(x, of.y)}
			result = append(result, right)
		}
	}
	//up
	if of.y > 0 {
		y := of.y - 1
		if g.Cell(of.x, y) == "|" || g.Cell(of.x, y) == "F" || g.Cell(of.x, y) == "7" {
			up := Cell{coord: Coord{x: of.x, y: of.y - 1}, contents: g.Cell(of.x, of.y-1)}
			result = append(result, up)
		}
	}
	//down
	if of.y < len(g.cells)-1 {
		y := of.y + 1
		if g.Cell(of.x, y) == "|" || g.Cell(of.x, y) == "L" || g.Cell(of.x, y) == "J" {
			down := Cell{coord: Coord{x: of.x, y: y}, contents: g.Cell(of.x, y)}
			result = append(result, down)
		}
	}

	return result
}

func main() {
	input := parse("input")
	input.Print()

	part1 := IterateGrid(input)
	fmt.Println(part1)

}

func ToCoords(cells []Cell) []Coord {
	var coords []Coord

	for _, cell := range cells {
		coords = append(coords, cell.coord)
	}

	return coords
}

func IterateGrid(grid Grid) int {
	begin := FindStart(grid)

	toCheck := []Coord{begin}

	steps := 0
	for len(toCheck) > 0 {
		var newCoords []Coord
		for _, coord := range toCheck {
			grid.Set(coord.x, coord.y, strconv.Itoa(steps))
			neigbors := grid.Neighbors(coord)
			newCoords = append(newCoords, ToCoords(neigbors)...)
		}

		toCheck = newCoords
		steps++
	}

	return steps - 1
}

func FindStart(g Grid) Coord {
	start := func(s string) bool {
		if s == "S" {
			return true
		} else {
			return false
		}
	}

	sp, _ := g.FindCell(start)

	return sp
}

func parse(s string) Grid {
	file, err := os.Open(s)
	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}
	defer file.Close()

	buf := bufio.NewReader(file)
	scanner := bufio.NewScanner(buf)

	var cells [][]string
	for scanner.Scan() {
		line := scanner.Text()
		split := strings.Split(line, "")
		cells = append(cells, split)
	}

	return Grid{cells}
}
