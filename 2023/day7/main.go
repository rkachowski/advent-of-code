package main

import (
	"bufio"
	"fmt"
	"log"
	"maps"
	"os"
	"regexp"
	"slices"
	"sort"
	"strconv"
	"strings"
)

type Hand struct {
	cards []string
	bid   int
}

type score int

const (
	HIGH_CARD score = iota + 1
	ONE_PAIR
	TWO_PAIR
	THREE_OF_A_KIND
	FULL_HOUSE
	FOUR_OF_A_KIND
	FIVE_OF_A_KIND
)

type Hands []Hand

func (hs Hands) Less(i, j int) bool {
	first := hs[i]
	second := hs[j]

	for card, _ := range first.cards {
		firstCard := first.cards[card]
		secondCard := second.cards[card]

		if firstCard == secondCard {
			continue
		}
		if val(firstCard) < val(secondCard) {
			return true
		} else {
			return false
		}
	}

	return false
}

func (hs Hands) Swap(i, j int) {
	hs[i], hs[j] = hs[j], hs[i]
}

func (hs Hands) Len() int {
	return len(hs)
}

func val(s string) int {
	cardVals := []string{"2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"}
	return slices.Index(cardVals, s)
}
func val2(s string) int {
	cardVals := []string{"J", "2", "3", "4", "5", "6", "7", "8", "9", "T", "Q", "K", "A"}
	return slices.Index(cardVals, s)
}
func main() {
	input := parse("input")

	part1(input)
	part2(input)
}

func part1(input []Hand) {
	handsToScore := map[score]Hands{}

	for _, card := range input {
		score := ScoreHand(card)

		handsToScore[score] = append(handsToScore[score], card)
	}

	var ranked []Hands
	for i := HIGH_CARD; i <= FIVE_OF_A_KIND; i++ {
		hands := handsToScore[i]
		if hands != nil {
			sort.Sort(hands)
			ranked = append(ranked, hands)
		}
	}

	var flattened Hands
	for _, h := range ranked {
		flattened = append(flattened, h...)
	}

	total := 0
	for i, hand := range flattened {
		total += (i + 1) * hand.bid
	}

	fmt.Printf("%d\n", total)
}

func part2(input []Hand) {
	handsToScore := map[score]Hands{}

	for _, card := range input {
		score := ScoreHand2(card)

		handsToScore[score] = append(handsToScore[score], card)
	}

	var ranked []Hands
	for i := HIGH_CARD; i <= FIVE_OF_A_KIND; i++ {
		hands := handsToScore[i]
		if hands != nil {
			slices.SortFunc(hands, part2Sort)
			ranked = append(ranked, hands)
		}
	}

	var flattened Hands
	for _, h := range ranked {
		flattened = append(flattened, h...)
	}

	total := 0
	for i, hand := range flattened {
		total += (i + 1) * hand.bid
	}

	fmt.Printf("%d\n", total)
}

func part2Sort(first Hand, second Hand) int {
	for card, _ := range first.cards {
		firstCard := first.cards[card]
		secondCard := second.cards[card]

		if firstCard == secondCard {
			continue
		}
		if val2(firstCard) < val2(secondCard) {
			return -1
		} else {
			return 1
		}
	}

	return 0
}

func ScoreHand(hand Hand) score {
	entries := CountEntries(hand.cards)

	vals := slices.Collect(maps.Values(entries))
	slices.Sort(vals)
	slices.Reverse(vals)

	if slices.Compare(vals, []int{5}) == 0 {
		return FIVE_OF_A_KIND
	}
	if slices.Compare(vals, []int{4, 1}) == 0 {
		return FOUR_OF_A_KIND
	}
	if slices.Compare(vals, []int{3, 2}) == 0 {
		return FULL_HOUSE
	}
	if slices.Compare(vals, []int{3, 1, 1}) == 0 {
		return THREE_OF_A_KIND
	}
	if slices.Compare(vals, []int{2, 2, 1}) == 0 {
		return TWO_PAIR
	}
	if slices.Compare(vals, []int{2, 1, 1, 1}) == 0 {
		return ONE_PAIR
	}

	return HIGH_CARD
}

func ScoreHand2(hand Hand) score {
	entries := CountEntries(hand.cards)

	vals := slices.Collect(maps.Values(entries))
	slices.Sort(vals)
	slices.Reverse(vals)

	if slices.Compare(vals, []int{5}) == 0 {
		return FIVE_OF_A_KIND
	}
	if slices.Compare(vals, []int{4, 1}) == 0 {
		if entries["J"] >= 1 {
			return FIVE_OF_A_KIND
		}

		return FOUR_OF_A_KIND
	}
	if slices.Compare(vals, []int{3, 2}) == 0 {
		if entries["J"] >= 2 {
			return FIVE_OF_A_KIND
		}
		return FULL_HOUSE
	}
	if slices.Compare(vals, []int{3, 1, 1}) == 0 {
		if entries["J"] > 0 {
			return FOUR_OF_A_KIND
		}

		return THREE_OF_A_KIND
	}
	if slices.Compare(vals, []int{2, 2, 1}) == 0 {
		if entries["J"] == 2 {
			return FOUR_OF_A_KIND
		}

		if entries["J"] == 1 {
			return FULL_HOUSE
		}

		return TWO_PAIR
	}
	if slices.Compare(vals, []int{2, 1, 1, 1}) == 0 {
		if entries["J"] == 2 || entries["J"] == 1 {
			return THREE_OF_A_KIND
		}
		return ONE_PAIR
	}

	if entries["J"] == 1 {
		return ONE_PAIR
	} else {
		return HIGH_CARD
	}
}

func CountEntries(e []string) map[string]int {
	result := map[string]int{}

	for _, card := range e {
		result[card]++
	}

	return result
}

func parse(s string) []Hand {

	file, err := os.Open(s)
	if err != nil {
		log.Fatalf("Error opening file: %v", err)
	}
	defer file.Close()

	buf := bufio.NewReader(file)

	scanner := bufio.NewScanner(buf)

	var hands []Hand
	regex := regexp.MustCompile(`(\w+) (\d+)`)
	for scanner.Scan() {
		line := scanner.Text()
		matches := regex.FindStringSubmatch(line)
		bid, _ := strconv.Atoi(matches[2])
		cards := strings.Split(matches[1], "")
		hand := Hand{cards, bid}
		hands = append(hands, hand)
	}

	return hands

}
