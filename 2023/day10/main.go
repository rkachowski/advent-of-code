package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

type Grid struct {
	cells [][]string
}

type Coord struct {
	x int
	y int
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

func main() {
	input := parse("input")
	input.Print()

	begin := FindStart(input)
	fmt.Printf("start - %v", begin)
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
