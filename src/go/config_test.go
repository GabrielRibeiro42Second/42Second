package main

import (
	"os"
	"path/filepath"
	"testing"
)

func writeConfig(t *testing.T, content string) string {
	t.Helper()
	path := filepath.Join(t.TempDir(), "termos.conf")
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatal(err)
	}
	return path
}

func TestLoadConfigReadsRootsAndDepth(t *testing.T) {
	path := writeConfig(t, `
editor=nvim
project_roots=/home/u/Projetos,/home/u/templates
max_depth=3
`)

	cfg, err := LoadConfig(path)
	if err != nil {
		t.Fatal(err)
	}

	if got, want := cfg.Roots, []string{"/home/u/Projetos", "/home/u/templates"}; !equal(got, want) {
		t.Fatalf("Roots = %v, want %v", got, want)
	}
	if cfg.MaxDepth != 3 {
		t.Fatalf("MaxDepth = %d, want 3", cfg.MaxDepth)
	}
}

func TestLoadConfigExpandsHomeInRoots(t *testing.T) {
	home, err := os.UserHomeDir()
	if err != nil {
		t.Skip("no home")
	}
	path := writeConfig(t, "project_roots=$HOME/Projetos,~/templates\n")

	cfg, err := LoadConfig(path)
	if err != nil {
		t.Fatal(err)
	}

	if cfg.Roots[0] != filepath.Join(home, "Projetos") {
		t.Fatalf("Roots[0] = %q, want %s/Projetos", cfg.Roots[0], home)
	}
	if cfg.Roots[1] != filepath.Join(home, "templates") {
		t.Fatalf("Roots[1] = %q, want %s/templates", cfg.Roots[1], home)
	}
}

func TestLoadConfigDefaultsWhenMissingKeys(t *testing.T) {
	path := writeConfig(t, "editor=nvim\n")

	cfg, err := LoadConfig(path)
	if err != nil {
		t.Fatal(err)
	}
	if cfg.MaxDepth != 2 {
		t.Fatalf("MaxDepth = %d, want default 2", cfg.MaxDepth)
	}
	if len(cfg.Roots) != 0 {
		t.Fatalf("Roots = %v, want empty", cfg.Roots)
	}
}

func TestLoadConfigMissingFileIsNotFatal(t *testing.T) {
	cfg, err := LoadConfig(filepath.Join(t.TempDir(), "nope.conf"))
	if err != nil {
		t.Fatalf("err = %v, want nil", err)
	}
	if cfg.MaxDepth != 2 {
		t.Fatalf("MaxDepth = %d, want 2", cfg.MaxDepth)
	}
}

func equal(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
