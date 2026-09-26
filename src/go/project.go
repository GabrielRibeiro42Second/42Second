package main

import (
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// Project é um diretório candidato a workspace, com os mesmos
// marcadores usados por src/bash/workspace/detector.sh.
type Project struct {
	Name   string
	Path   string
	Type   string
	Git    bool
	README bool
	Docker bool
}

var languageMarkers = []struct {
	file string
	kind string
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

// pruneDirs espelha _filesystem_prune_dirs do bash: nada destes
// nomes vira projeto nem é descido durante o scan.
var pruneDirs = map[string]bool{
	"node_modules": true,
	"venv":         true,
	"__pycache__":  true,
	"target":       true,
	"dist":         true,
	"build":        true,
	"out":          true,
}

// DetectType replica detector::detect — a ordem da lista é a
// prioridade; sem marcador o tipo é "default".
func DetectType(dir string) string {
	for _, m := range languageMarkers {
		if fileExists(filepath.Join(dir, m.file)) {
			return m.kind
		}
	}
	return "default"
}

// ScanProjects varre os roots até maxDepth níveis e devolve apenas
// os diretórios que parecem projetos (marcador conhecido), ordenados
// por nome.
func ScanProjects(roots []string, maxDepth int) []Project {
	if maxDepth < 1 {
		maxDepth = 1
	}

	seen := map[string]bool{}
	var projects []Project

	for _, root := range roots {
		filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
			if err != nil || !d.IsDir() {
				return nil
			}

			name := d.Name()
			if path != root && (strings.HasPrefix(name, ".") || pruneDirs[name]) {
				return fs.SkipDir
			}

			rel, rerr := filepath.Rel(root, path)
			if rerr != nil {
				return nil
			}
			depth := 0
			if rel != "." {
				depth = strings.Count(rel, string(filepath.Separator)) + 1
			}
			if depth > maxDepth {
				return fs.SkipDir
			}
			if depth == 0 {
				return nil
			}

			p, ok := inspect(path)
			if ok && !seen[path] {
				seen[path] = true
				projects = append(projects, p)
			}
			return nil
		})
	}

	sort.Slice(projects, func(i, j int) bool {
		return projects[i].Name < projects[j].Name
	})
	return projects
}

// inspect monta o Project; só diretórios com marcador contam.
func inspect(dir string) (Project, bool) {
	kind := DetectType(dir)
	if kind == "default" {
		return Project{}, false
	}

	git := dirExists(filepath.Join(dir, ".git"))
	readme := fileExists(filepath.Join(dir, "README.md")) ||
		fileExists(filepath.Join(dir, "README"))
	docker := fileExists(filepath.Join(dir, "Dockerfile"))

	return Project{
		Name:   filepath.Base(dir),
		Path:   dir,
		Type:   kind,
		Git:    git,
		README: readme,
		Docker: docker,
	}, true
}

func fileExists(path string) bool {
	st, err := os.Stat(path)
	return err == nil && !st.IsDir()
}

func dirExists(path string) bool {
	st, err := os.Stat(path)
	return err == nil && st.IsDir()
}
