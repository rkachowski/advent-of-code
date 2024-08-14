package main

import (
	"reflect"
	"testing"
)

func TestFirstAndLastNumber(t *testing.T) {
	type args struct {
		line string
	}
	tests := []struct {
		name string
		args args
		want []string
	}{
		{"basic test", args{"1asdlkfjaslkdjfasljf2"}, []string{"1", "2"}},
		{"repeat ", args{"1asd6kfj6slkdj9asljf"}, []string{"1", "9"}},
		{"repeat ", args{"1asdlkfjaslkdjfasljf"}, []string{"1", "1"}},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := FirstAndLastNumber(tt.args.line); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("FirstAndLastNumber() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestParseFile(t *testing.T) {
	type args struct {
		path string
	}
	tests := []struct {
		name string
		args args
		want []string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ParseFile(tt.args.path); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ParseFile() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestNumberLiteral(t *testing.T) {
	type args struct {
		line string
	}
	tests := []struct {
		name string
		args args
		want []string
	}{
		{"overlapping", args{"2zbxzsthreefivefhdbhvjjxv6btwonef"}, []string{"2", "1"}},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := ExtractNumbers(tt.args.line); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ExtractNumbers() = %v, want %v", got, tt.want)
			}
		})
	}
}
