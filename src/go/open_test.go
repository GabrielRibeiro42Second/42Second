package main

import (
	"path/filepath"
	"testing"
)

func TestOpenCommandUsesTermosStart(t *testing.T) {
	got := openCommand("/opt/termos", "/home/u/Projetos/app")
	want := []string{filepath.Join("/opt/termos", "bin", "termos"), "start", "/home/u/Projetos/app"}

	if !equal(got, want) {
		t.Fatalf("openCommand = %v, want %v", got, want)
	}
}

func TestOpenCommandFallsBackToPathLookup(t *testing.T) {
	got := openCommand("", "/home/u/Projetos/app")
	want := []string{"termos", "start", "/home/u/Projetos/app"}

	if !equal(got, want) {
		t.Fatalf("openCommand = %v, want %v", got, want)
	}
}
