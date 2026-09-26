package main

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"
)

func touch(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(path, []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}
}

func TestScanFindsOnlyProjectsWithMarkers(t *testing.T) {
	root := t.TempDir()
	touch(t, filepath.Join(root, "alpha", "package.json"))
	touch(t, filepath.Join(root, "beta", "go.mod"))
	os.MkdirAll(filepath.Join(root, "empty"), 0o755)

	got := ScanProjects([]string{root}, 2)
	var names []string
	for _, p := range got {
		names = append(names, p.Name)
	}

	if !reflect.DeepEqual(names, []string{"alpha", "beta"}) {
		t.Fatalf("ScanProjects() = %v, want [alpha beta]", names)
	}
}

func TestScanPrunesJunkDirectories(t *testing.T) {
	root := t.TempDir()
	touch(t, filepath.Join(root, "app", "package.json"))
	touch(t, filepath.Join(root, "app", "node_modules", "left-pad", "package.json"))
	touch(t, filepath.Join(root, ".hidden", "package.json"))
	touch(t, filepath.Join(root, "build", "package.json"))

	got := ScanProjects([]string{root}, 2)
	var names []string
	for _, p := range got {
		names = append(names, p.Name)
	}

	if !reflect.DeepEqual(names, []string{"app"}) {
		t.Fatalf("ScanProjects() = %v, want [app]", names)
	}
}

func TestScanRespectsMaxDepth(t *testing.T) {
	root := t.TempDir()
	touch(t, filepath.Join(root, "shallow", "Makefile"))
	touch(t, filepath.Join(root, "deep", "nested", "Makefile"))

	got := ScanProjects([]string{root}, 1)
	var names []string
	for _, p := range got {
		names = append(names, p.Name)
	}

	if !reflect.DeepEqual(names, []string{"shallow"}) {
		t.Fatalf("ScanProjects() = %v, want [shallow]", names)
	}
}

func TestScanKeepsMarkerInfo(t *testing.T) {
	root := t.TempDir()
	dir := filepath.Join(root, "pyproj")
	touch(t, filepath.Join(dir, "pyproject.toml"))
	touch(t, filepath.Join(dir, "README.md"))
	touch(t, filepath.Join(dir, ".git", "HEAD"))

	got := ScanProjects([]string{root}, 2)
	if len(got) != 1 {
		t.Fatalf("len = %d, want 1", len(got))
	}
	p := got[0]
	if p.Type != "python" {
		t.Errorf("Type = %q, want python", p.Type)
	}
	if !p.Git {
		t.Error("Git = false, want true")
	}
	if !p.README {
		t.Error("README = false, want true")
	}
}
