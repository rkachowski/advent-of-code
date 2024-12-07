package main

import (
	"github.com/rkachowski/advent-of-code/2024/utils"
)

func main() {
	input := utils.ParseFile("test")
	grid := utils.GridFromInput(input)

	grid.Print()
}
