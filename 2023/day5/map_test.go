package main

import "testing"

func TestCollideRangeWithMapLeftOcclusion(t *testing.T) {
	testRange := Range{0, 10}
	testMap := []int{20, 5, 5}

	mapped, unmapped := CollideRangeWithMap(testRange, testMap)

	if len(mapped) != 1 {
		t.Fatalf("should be one remapped range")
	}

	if !(mapped[0].start == 20 && mapped[0].end == 25) {
		t.Fatalf("didn't remap new map correctly")
	}

	if unmapped[0].start != 0 || unmapped[0].end != 5 {
		t.Fatalf("didn't adjust previous map correctly")
	}
}

func TestCollideRangeWithMapInsideOcclusion(t *testing.T) {
	testRange := Range{8, 9}
	testMap := []int{20, 5, 5}

	mapped, unmapped := CollideRangeWithMap(testRange, testMap)

	if len(mapped) != 1 {
		t.Fatalf("should be one remapped range")
	}

	if len(unmapped) != 0 {
		t.Fatalf("should be no unmapped ranges")
	}

	if !(mapped[0].start == 23 && mapped[0].end == 24) {
		t.Fatalf("didn't remap new map correctly - %v", mapped[0])
	}
}

func TestCollideRangeWithMapRightOcclusion(t *testing.T) {
	testRange := Range{0, 15}
	testMap := []int{20, 5, 5}

	mapped, unmapped := CollideRangeWithMap(testRange, testMap)

	if len(mapped) != 1 {
		t.Fatalf("should be one remapped range - was %d", len(mapped))
	}

	if !(mapped[0].start == 20 && mapped[0].end == 24) {
		t.Fatalf("didn't remap new map correctly")
	}

	if unmapped[0].start != 0 || unmapped[0].end != 4 {
		t.Fatalf("didn't adjust previous map correctly")
	}
	if unmapped[1].start != 10 || unmapped[1].end != 15 {
		t.Fatalf("didn't adjust previous map correctly")
	}
}

func TestCollideRangeWithMapFullOcclusion(t *testing.T) {
	testRange := Range{0, 15}
	testMap := []int{20, 5, 5}

	mapped, unmapped := CollideRangeWithMap(testRange, testMap)

	if len(mapped) != 1 {
		t.Fatalf("should be one remapped range - was %d", len(mapped))
	}
	if len(unmapped) != 2 {
		t.Fatalf("should be 2 unmapped ranges with endpoints adjusted")
	}

	if !(mapped[0].start == 20 && mapped[0].end == 24) {
		t.Fatalf("didn't remap new map correctly %v", mapped[0])
	}

	if unmapped[0].start != 0 || unmapped[0].end != 4 {
		t.Fatalf("didn't adjust previous map correctly")
	}
	if unmapped[1].start != 10 || unmapped[1].end != 15 {
		t.Fatalf("didn't adjust previous map correctly")
	}
}
