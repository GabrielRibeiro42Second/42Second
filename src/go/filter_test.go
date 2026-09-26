package main

import "testing"

func TestFilterMatchesNameCaseInsensitive(t *testing.T) {
	projects := []Project{
		{Name: "termOS"},
		{Name: "dotfiles"},
		{Name: "nvim-config"},
	}

	got := FilterProjects(projects, "TERM")
	var names []string
	for _, p := range got {
		names = append(names, p.Name)
	}

	if len(names) != 1 || names[0] != "termOS" {
		t.Fatalf("FilterProjects = %v, want [termOS]", names)
	}
}

func TestFilterMatchesPathSubstring(t *testing.T) {
	projects := []Project{
		{Name: "a", Path: "/home/u/Projetos/alpha"},
		{Name: "b", Path: "/home/u/templates/beta"},
	}

	got := FilterProjects(projects, "templates")
	if len(got) != 1 || got[0].Name != "b" {
		t.Fatalf("FilterProjects = %v, want [b]", got)
	}
}

func TestFilterEmptyQueryReturnsAll(t *testing.T) {
	projects := []Project{{Name: "a"}, {Name: "b"}}
	got := FilterProjects(projects, "")
	if len(got) != 2 {
		t.Fatalf("len = %d, want 2", len(got))
	}
}
