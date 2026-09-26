package main

import (
	"path/filepath"
	"testing"
)

func TestDetectTypeFollowsDetectorOrder(t *testing.T) {
	cases := []struct {
		file string
		want string
	}{
		{"pom.xml", "java"},
		{"build.gradle", "java"},
		{"build.gradle.kts", "java"},
		{"pyproject.toml", "python"},
		{"setup.py", "python"},
		{"requirements.txt", "python"},
		{"package.json", "node"},
		{"Cargo.toml", "rust"},
		{"go.mod", "go"},
		{"Makefile", "make"},
		{"CMakeLists.txt", "cmake"},
		{"justfile", "just"},
		{"Dockerfile", "docker"},
	}

	for _, tc := range cases {
		dir := t.TempDir()
		touch(t, filepath.Join(dir, tc.file))
		if got := DetectType(dir); got != tc.want {
			t.Errorf("DetectType(%s) = %q, want %q", tc.file, got, tc.want)
		}
	}
}

func TestDetectTypePrefersLanguageOverDocker(t *testing.T) {
	dir := t.TempDir()
	touch(t, filepath.Join(dir, "Dockerfile"))
	touch(t, filepath.Join(dir, "package.json"))

	if got := DetectType(dir); got != "node" {
		t.Fatalf("DetectType = %q, want node", got)
	}
}

func TestDetectTypeDefaultWhenNoMarker(t *testing.T) {
	dir := t.TempDir()
	if got := DetectType(dir); got != "default" {
		t.Fatalf("DetectType = %q, want default", got)
	}
}
