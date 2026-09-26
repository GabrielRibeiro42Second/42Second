package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	tea "charm.land/bubbletea/v2"
)

// openCommand monta o argv para abrir o workspace escolhido.
// Com TERMOS_HOME usa o binário do repositório/install; sem ele,
// deixa o PATH decidir.
func openCommand(termosHome, dir string) []string {
	bin := "termos"
	if termosHome != "" {
		bin = filepath.Join(termosHome, "bin", "termos")
	}
	return []string{bin, "start", dir}
}

func main() {
	cfgPath := DefaultConfigPath()
	cfg, err := LoadConfig(cfgPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "termos dashboard: %v\n", err)
		os.Exit(1)
	}

	if len(cfg.Roots) == 0 {
		fmt.Fprintln(os.Stderr, "termos dashboard: nenhuma project_roots configurada")
		fmt.Fprintf(os.Stderr, "  edite %s\n", cfgPath)
		os.Exit(1)
	}

	projects := ScanProjects(cfg.Roots, cfg.MaxDepth)

	m := model{projects: projects}
	p := tea.NewProgram(m)
	final, err := p.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "termos dashboard: %v\n", err)
		os.Exit(1)
	}

	fm, ok := final.(model)
	if !ok || fm.selected == nil {
		return
	}

	args := openCommand(os.Getenv("TERMOS_HOME"), fm.selected.Path)
	bin, lookErr := exec.LookPath(args[0])
	if lookErr != nil {
		fmt.Fprintf(os.Stderr, "termos dashboard: %s não encontrado\n", args[0])
		os.Exit(1)
	}

	if err := exec.Command(bin, args[1:]...).Run(); err != nil {
		fmt.Fprintf(os.Stderr, "termos dashboard: %v\n", err)
		os.Exit(1)
	}
}
