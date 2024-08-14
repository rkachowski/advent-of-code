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
