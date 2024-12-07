package utils

import (
	"bufio"
	"fmt"
	"os"
)

func ParseFile(filename string) []string {
	file, err := os.Open(filename)

	if err != nil {
		panic(err)
	}
	defer file.Close()
	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}

type Grid[T any] struct {
	cells  [][]T
	Width  int
	Height int
	external func(x, y int) *T
}

func returnNil[T any](x, y int) *T{
	return nil
}

func (g *Grid[T]) Get(x, y int)(*T) {
	if (x < 0 || x >= g.Width || y < 0 || y >= g.Height) {
		return g.external(x, y)
	}
	return &g.cells[y][x]
}

func (g *Grid[T]) Put(x, y int,val  T) {
	g.cells[y][x] = val
}

func (g *Grid[T]) Print() {
	for _, row := range g.cells {
		for _, cell := range row {
			fmt.Printf("%v", cell)
		}
		fmt.Println()
	}
}

func NewGrid[T any](width, height int) *Grid[T] {
	cells := make([][]T, width)
	for i := range cells {
		cells[i] = make([]T, height)
	}

	return &Grid[T]{cells: cells, Width: width, Height: height, external: returnNil[T]}
}

func GridFromInput(input []string) *Grid[string] {
	height, width := len(input), len(input[0])

	grid := NewGrid[string](width, height)

	for y, line := range input {
		for x, cell := range line {
			grid.Put(x,y, string(cell))
		}
	}

	return grid
}