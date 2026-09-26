package main

import (
	"fmt"
	"strings"

	tea "charm.land/bubbletea/v2"
	"charm.land/lipgloss/v2"
)

// Paleta Solarized Osaka — mesma do tema tmux em config/.
const (
	colorBg        = "#001b22"
	colorBgHi      = "#003842"
	colorSurface   = "#07404d"
	colorFg        = "#839496"
	colorFgBright  = "#93a1a1"
	colorMuted     = "#5c6972"
	colorBlue      = "#268bd2"
	colorCyan      = "#2aa198"
	colorGreen     = "#859900"
	colorYellow    = "#b58900"
	colorOrange    = "#cb4b16"
	colorRed       = "#dc322f"
	colorMagenta   = "#d33682"
	colorViolet    = "#6c71c4"
	headerHeight   = 3
	footerHeight   = 3
	statusBarWidth = 26
)

var (
	titleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(lipgloss.Color(colorBg)).
			Background(lipgloss.Color(colorCyan)).
			Padding(0, 1)

	subtitleStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color(colorMuted))

	filterStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color(colorYellow))

	panelStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(lipgloss.Color(colorSurface))

	panelTitleStyle = lipgloss.NewStyle().
				Bold(true).
				Foreground(lipgloss.Color(colorCyan))

	cursorStyle = lipgloss.NewStyle().
			Foreground(lipgloss.Color(colorBg)).
			Background(lipgloss.Color(colorBlue)).
			Bold(true)

	normalItem = lipgloss.NewStyle().Foreground(lipgloss.Color(colorFg))

	footerKey = lipgloss.NewStyle().
			Foreground(lipgloss.Color(colorBg)).
			Background(lipgloss.Color(colorMuted)).
			Padding(0, 1)

	footerDesc = lipgloss.NewStyle().Foreground(lipgloss.Color(colorFgBright))

	dimStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(colorMuted))

	okStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color(colorGreen))
	badStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color(colorRed))
	infoStyle = lipgloss.NewStyle().Foreground(lipgloss.Color(colorBlue))
)

// panel monta a caixa com título no topo da borda.
func panel(title string, width, height int, content string) string {
	label := panelTitleStyle.Render(" " + title + " ")
	body := lipgloss.NewStyle().
		Width(width - 2).
		Height(height - 2).
		Padding(0, 1).
		Render(content)
	return panelStyle.
		Width(width).
		Height(height).
		Render(label + "\n" + body)
}

// typeColor devolve a cor do badge de linguagem.
func typeColor(kind string) string {
	switch kind {
	case "python":
		return colorBlue
	case "node":
		return colorGreen
	case "java":
		return colorOrange
	case "rust":
		return colorOrange
	case "go":
		return colorCyan
	case "make", "cmake", "just":
		return colorYellow
	case "docker":
		return colorBlue
	default:
		return colorMuted
	}
}

func (m model) View() tea.View {
	if m.quitting {
		return tea.NewView("")
	}

	if m.width == 0 || m.height == 0 {
		return tea.NewView(dimStyle.Render("carregando…"))
	}

	contentWidth := m.width - 4
	if contentWidth < 20 {
		contentWidth = 20
	}

	listWidth := contentWidth * 60 / 100
	if listWidth < 24 {
		listWidth = 24
	}
	detailWidth := contentWidth - listWidth - 1
	if detailWidth < 18 {
		detailWidth = 18
	}

	bodyHeight := m.height - headerHeight - footerHeight
	if bodyHeight < 5 {
		bodyHeight = 5
	}

	vis := m.visible()
	m.offset = scrollOffset(m.offset, m.cursor, bodyHeight-4, len(vis))

	var v strings.Builder
	v.WriteString(m.header())
	v.WriteString("\n")
	v.WriteString(lipgloss.JoinHorizontal(
		lipgloss.Top,
		m.renderList(vis, listWidth, bodyHeight),
		" ",
		m.renderDetail(vis, detailWidth, bodyHeight),
	))
	v.WriteString("\n")
	v.WriteString(m.footer())

	view := tea.NewView(v.String())
	view.AltScreen = true
	return view
}

func (m model) header() string {
	count := len(m.visible())
	head := titleStyle.Render(" termOS ") + " " +
		subtitleStyle.Render(fmt.Sprintf("dashboard · %d projeto(s)", count))

	if m.filtering || m.filter != "" {
		head += "  " + filterStyle.Render("["+m.filter+"]")
	}
	return lipgloss.NewStyle().MaxWidth(m.width).Render(head)
}

func (m model) renderList(projects []Project, width, height int) string {
	inner := width - 2
	rows := height - 2
	if rows < 1 {
		rows = 1
	}

	if len(projects) == 0 {
		empty := dimStyle.Render("nenhum projeto — ajuste project_roots no config")
		return panel("projetos", width, height, empty)
	}

	var lines []string
	for i, p := range projects {
		if i < m.offset || i >= m.offset+rows {
			continue
		}
		line := m.renderRow(p, inner, i == m.cursor)
		lines = append(lines, line)
	}
	for len(lines) < rows {
		lines = append(lines, "")
	}

	return panel("projetos", width, height, strings.Join(lines, "\n"))
}

func (m model) renderRow(p Project, width int, cursor bool) string {
	badge := lipgloss.NewStyle().
		Foreground(lipgloss.Color(colorBg)).
		Background(lipgloss.Color(typeColor(p.Type))).
		Padding(0, 1).
		Render(p.Type)

	// O resto da linha é texto puro quando há cursor, para que o
	// fundo do cursorStyle cubra a linha inteira sem os resets dos
	// estilos aninhados cortarem o destaque.
	marks := marksFor(p, cursor)

	name := p.Name
	rest := width - lipgloss.Width(badge)
	pad := rest - lipgloss.Width(marks) - 2
	if pad < 1 {
		pad = 1
	}
	if lipgloss.Width(name) > pad {
		name = name[:pad-1] + "…"
	}

	row := fmt.Sprintf(" %s%s%s", name, strings.Repeat(" ", pad-lipgloss.Width(name)), marks)

	if cursor {
		return badge + cursorStyle.Width(rest).Render(row)
	}
	return badge + normalItem.Width(rest).Render(row)
}

// marksFor monta os selos git/readme/docker; plain remove as cores
// para não brigar com o fundo do cursor.
func marksFor(p Project, plain bool) string {
	var parts []string
	if p.Git {
		parts = append(parts, "git")
	}
	if p.README {
		parts = append(parts, "readme")
	}
	if p.Docker {
		parts = append(parts, "docker")
	}
	if len(parts) == 0 {
		return ""
	}

	label := strings.Join(parts, " ")
	if plain {
		return label
	}

	out := label
	if p.Git {
		out = okStyle.Render("git")
	}
	if p.README {
		out = joinMarks(out, okStyle.Render("readme"))
	}
	if p.Docker {
		out = joinMarks(out, infoStyle.Render("docker"))
	}
	return out
}

func joinMarks(a, b string) string {
	if a == "" {
		return b
	}
	return a + " " + b
}

func (m model) renderDetail(projects []Project, width, height int) string {
	body := dimStyle.Render("selecione um projeto")

	if len(projects) > 0 {
		i := m.cursor
		if i >= len(projects) {
			i = len(projects) - 1
		}
		p := projects[i]

		var b strings.Builder
		b.WriteString(panelTitleStyle.Render(p.Name) + "\n")
		b.WriteString(dimStyle.Render(shorten(p.Path, width-4)) + "\n\n")

		b.WriteString(fmt.Sprintf("%s %s\n", label("tipo"), badge(p.Type, p.Type)))
		b.WriteString(fmt.Sprintf("%s %s\n", label("git"), mark(p.Git)))
		b.WriteString(fmt.Sprintf("%s %s\n", label("readme"), mark(p.README)))
		b.WriteString(fmt.Sprintf("%s %s\n", label("docker"), mark(p.Docker)))
		b.WriteString("\n" + dimStyle.Render("enter abre o workspace"))
		body = b.String()
	}

	return panel("detalhes", width, height, body)
}

func badge(kind, label string) string {
	return lipgloss.NewStyle().
		Foreground(lipgloss.Color(colorBg)).
		Background(lipgloss.Color(typeColor(kind))).
		Padding(0, 1).
		Render(label)
}

// label alinha a coluna de chaves do painel de detalhes.
func label(key string) string {
	return dimStyle.Render(fmt.Sprintf("%-8s", key))
}

// shorten corta o começo do caminho quando não cabe, preservando
// o final (é onde está o nome do projeto).
func shorten(path string, max int) string {
	if max < 4 || lipgloss.Width(path) <= max {
		return path
	}
	runes := []rune(path)
	return "…" + string(runes[len(runes)-max+1:])
}

func mark(ok bool) string {
	if ok {
		return okStyle.Render("✔")
	}
	return badStyle.Render("✘")
}

func (m model) footer() string {
	if m.filtering {
		return footerKey.Render(" enter ") + footerDesc.Render(" aplicar  ") +
			footerKey.Render(" esc ") + footerDesc.Render(" limpar  ") +
			dimStyle.Render("digite para filtrar")
	}
	return footerKey.Render(" ↑↓ ") + footerDesc.Render("navegar  ") +
		footerKey.Render(" / ") + footerDesc.Render("filtrar  ") +
		footerKey.Render(" enter ") + footerDesc.Render("abrir  ") +
		footerKey.Render(" q ") + footerDesc.Render("sair")
}

// scrollOffset mantém o cursor visível dentro da janela.
func scrollOffset(offset, cursor, pageSize, total int) int {
	if total <= pageSize {
		return 0
	}
	if cursor < offset {
		return cursor
	}
	if cursor >= offset+pageSize {
		return cursor - pageSize + 1
	}
	if offset > total-pageSize {
		return total - pageSize
	}
	return offset
}
