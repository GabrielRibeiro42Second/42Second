package main

import (
	"strings"

	tea "charm.land/bubbletea/v2"
)

// model é o estado do dashboard: lista de projetos, cursor,
// modo filtro e seleção final.
type model struct {
	projects  []Project
	cursor    int
	offset    int
	width     int
	height    int
	filtering bool
	filter    string
	selected  *Project
	quitting  bool
	err       error
}

// visible é a lista já aplicada o filtro — é o que a UI desenha.
func (m model) visible() []Project {
	return FilterProjects(m.projects, m.filter)
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width, m.height = msg.Width, msg.Height
		return m, nil

	case tea.KeyPressMsg:
		return m.handleKey(msg)
	}
	return m, nil
}

func (m model) handleKey(key tea.KeyPressMsg) (tea.Model, tea.Cmd) {
	if m.filtering {
		return m.filterKey(key)
	}

	switch key.String() {
	case "q", "ctrl+c":
		m.quitting = true
		return m, tea.Quit

	case "esc":
		if m.filter != "" {
			m.filter = ""
			m.cursor = 0
		}
		return m, nil

	case "/":
		m.filtering = true
		return m, nil

	case "up", "k":
		m.move(-1)
		return m, nil

	case "down", "j":
		m.move(1)
		return m, nil

	case "pgup":
		m.move(-m.pageSize())
		return m, nil

	case "pgdown":
		m.move(m.pageSize())
		return m, nil

	case "home", "g":
		m.cursor = 0
		m.clamp()
		return m, nil

	case "end", "G":
		m.cursor = len(m.visible()) - 1
		m.clamp()
		return m, nil

	case "enter":
		vis := m.visible()
		if len(vis) == 0 {
			return m, nil
		}
		m.clamp()
		sel := vis[m.cursor]
		m.selected = &sel
		m.quitting = true
		return m, tea.Quit
	}
	return m, nil
}

// filterKey trata o modo de digitação do filtro.
func (m model) filterKey(key tea.KeyPressMsg) (tea.Model, tea.Cmd) {
	switch key.String() {
	case "esc", "ctrl+c":
		m.filtering = false
		if key.String() == "ctrl+c" {
			m.quitting = true
			return m, tea.Quit
		}
		m.filter = ""
		m.cursor = 0
		return m, nil

	case "enter":
		m.filtering = false
		m.cursor = 0
		m.clamp()
		return m, nil

	case "backspace":
		if r := []rune(m.filter); len(r) > 0 {
			m.filter = string(r[:len(r)-1])
			m.cursor = 0
			m.clamp()
		}
		return m, nil

	case "up":
		m.move(-1)
		return m, nil

	case "down":
		m.move(1)
		return m, nil
	}

	if t := key.Text; t != "" && !strings.ContainsRune(t, 0x1b) {
		m.filter += t
		m.cursor = 0
		m.clamp()
	}
	return m, nil
}

func (m *model) move(delta int) {
	m.cursor += delta
	m.clamp()
}

func (m *model) clamp() {
	n := len(m.visible())
	if n == 0 {
		m.cursor = 0
		return
	}
	if m.cursor >= n {
		m.cursor = n - 1
	}
	if m.cursor < 0 {
		m.cursor = 0
	}
}

// pageSize é a altura útil da lista, usada por pgup/pgdown.
func (m model) pageSize() int {
	h := m.height - headerHeight - footerHeight - 4
	if h < 1 {
		return 1
	}
	return h
}
