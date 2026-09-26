package main

import (
	"testing"

	tea "charm.land/bubbletea/v2"
)

func press(t *testing.T, m model, keys ...string) model {
	t.Helper()
	for _, k := range keys {
		next, _ := m.Update(tea.KeyPressMsg(tea.Key{Code: keyFor(k), Text: k}))
		m = next.(model)
	}
	return m
}

func keyFor(s string) rune {
	switch s {
	case "down":
		return tea.KeyDown
	case "up":
		return tea.KeyUp
	case "enter":
		return tea.KeyEnter
	case "esc":
		return tea.KeyEscape
	case "/":
		return '/'
	}
	return rune(s[0])
}

func TestCursorMovesAndClamps(t *testing.T) {
	m := model{projects: []Project{{Name: "a"}, {Name: "b"}}}

	m = press(t, m, "down", "down", "down")
	if m.cursor != 1 {
		t.Fatalf("cursor = %d after moving down, want 1 (clamped)", m.cursor)
	}

	m = press(t, m, "up", "up")
	if m.cursor != 0 {
		t.Fatalf("cursor = %d after moving up, want 0 (clamped)", m.cursor)
	}
}

func TestSlashEntersFilterModeAndTypingNarrowsList(t *testing.T) {
	m := model{projects: []Project{{Name: "alpha"}, {Name: "beta"}}}

	m = press(t, m, "/")
	if !m.filtering {
		t.Fatal("filtering = false after '/', want true")
	}

	m = press(t, m, "b")
	if len(m.visible()) != 1 || m.visible()[0].Name != "beta" {
		t.Fatalf("visible = %v, want [beta]", m.visible())
	}
}

func TestEnterSelectsVisibleProject(t *testing.T) {
	m := model{projects: []Project{{Name: "alpha"}, {Name: "beta"}}}

	m = press(t, m, "down", "enter")
	if m.selected == nil || m.selected.Name != "beta" {
		t.Fatalf("selected = %v, want beta", m.selected)
	}
	if !m.quitting {
		t.Fatal("quitting = false after enter, want true")
	}
}

func TestEscClearsFilterAndKeepsList(t *testing.T) {
	m := model{projects: []Project{{Name: "alpha"}, {Name: "beta"}}}
	m = press(t, m, "/", "b", "esc")

	if m.filtering {
		t.Fatal("filtering = true after esc, want false")
	}
	if len(m.visible()) != 2 {
		t.Fatalf("visible = %d, want 2", len(m.visible()))
	}
}
