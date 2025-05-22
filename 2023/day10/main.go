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

func (g Grid) ConnectedPipeNeighbors(of Coord) []Cell {
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
	file := "test3"
	input := parse(file)
	part1 := IterateGrid(input)
	input.Print()
	fmt.Println(part1)

	input = parse(file)
	innerTiles := FindInside(input)
	input.Print()
	fmt.Println(innerTiles)

}

func ToCoords(cells []Cell) []Coord {
	var coords []Coord

	for _, cell := range cells {
		coords = append(coords, cell.coord)
	}

	return coords
}

func AllCoordsInCells(cells []Cell, coords []Coord) bool {
	coordMap := make(map[Coord]struct{})

	for _, cell := range cells {
		coordMap[cell.coord] = struct{}{}
	}

	for _, c := range coords {
		if _, exists := coordMap[c]; !exists {
			return false
		}
	}

	return true
}

func ReplaceStart(grid Grid, start Coord) Grid {

	neighbours := grid.ConnectedPipeNeighbors(start)

	if len(neighbours) != 2 {
		log.Fatalf("what")
	}

	up := []Coord{{x: start.x, y: start.y - 1}}
	down := []Coord{{x: start.x, y: start.y + 1}}
	left := []Coord{{x: start.x - 1, y: start.y}}
	right := []Coord{{x: start.x + 1, y: start.y}}

	return grid
}

func (g Grid) Width() int {
	return len(g.cells[0])
}

func (g Grid) Height() int {
	return len(g.cells)
}

func FindInside(grid Grid) int {
	inside := 0
	for y := 0; y < grid.Height(); y++ {
		for x := 0; x < grid.Width(); x++ {
			//for each cell
			contents := grid.Cell(x, y)

			if IsPipe(contents) {
				continue
			}

			walls := 0
			previousVert := "#"

			for curX := x; curX < grid.Width()-1; curX++ {
				current := grid.Cell(curX, y)
				next := grid.Cell(curX+1, y)

				if IsEndOfPipe(current, next, previousVert) {
					walls++
				}

				if VerticalPipe(current) {
					previousVert = current
				}
			}

			if walls > 0 && walls%2 == 1 {
				grid.Set(x, y, "I")
				inside++
				fmt.Print(walls)
			} else {
				fmt.Print(contents)
			}
		}
		fmt.Print("\n")
	}

	return inside
}

func IsEndOfPipe(current string, next string, prevVert string) bool {
	if prevVert == "F" && current == "7" {
		return false
	}
	if prevVert == "F" && current == "J" {
		return true
	}

	if prevVert == "L" && current == "J" {
		return false
	}

	if prevVert == "L" && current == "7" {
		return true
	}

	if VerticalPipe(current) && next != "-" {
		return true
	}

	return false
}

func VerticalPipe(p string) bool {
	if p == "|" || p == "F" || p == "J" || p == "7" || p == "L" {
		return true
	} else {
		return false
	}
}

func IsPipe(p string) bool {
	if p == "|" || p == "F" || p == "J" || p == "7" || p == "L" || p == "-" || p == "S" {
		return true
	} else {
		return false
	}
}

func IterateGrid(grid Grid) int {
	begin := FindStart(grid)

	toCheck := []Coord{begin}

	steps := 0
	for len(toCheck) > 0 {
		var newCoords []Coord
		for _, coord := range toCheck {
			grid.Set(coord.x, coord.y, strconv.Itoa(steps))
			neighbors := grid.ConnectedPipeNeighbors(coord)
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
