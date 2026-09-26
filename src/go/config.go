package main

import (
	"bufio"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

// Config é o termos.conf lido pelo CLI bash — mesmas chaves,
// mesma expansão de $HOME/~ (sem eval).
type Config struct {
	Roots    []string
	MaxDepth int
	// Editor/FileManager/etc ficam com o bash; o dashboard só
	// precisa das raízes para achar projetos.
}

// LoadConfig lê um termos.conf. Arquivo ausente não é erro:
// vêm os defaults, igual a config::load do bash.
func LoadConfig(path string) (Config, error) {
	cfg := Config{MaxDepth: 2}

	f, err := os.Open(path)
	if err != nil {
		return cfg, nil
	}
	defer f.Close()

	home, _ := os.UserHomeDir()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		key, value, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		key = strings.TrimSpace(key)
		value = strings.TrimSpace(value)
		if value == "" {
			continue
		}

		switch key {
		case "project_roots":
			for _, root := range strings.Split(value, ",") {
				root = strings.TrimSpace(root)
				if root == "" {
					continue
				}
				cfg.Roots = append(cfg.Roots, expandHome(root, home))
			}
		case "max_depth":
			if n, err := strconv.Atoi(value); err == nil && n > 0 {
				cfg.MaxDepth = n
			}
		}
	}

	return cfg, scanner.Err()
}

func expandHome(path, home string) string {
	if home == "" {
		return path
	}
	switch {
	case path == "~":
		return home
	case strings.HasPrefix(path, "~/"):
		return filepath.Join(home, strings.TrimPrefix(path, "~/"))
	}
	return os.Expand(path, func(k string) string {
		if k == "HOME" {
			return home
		}
		return os.Getenv(k)
	})
}

// DefaultConfigPath segue a mesma precedência do bash:
// TERMOS_CONFIG_FILE > $TERMOS_CONFIG_DIR/termos.conf > $TERMOS_HOME/config.
func DefaultConfigPath() string {
	if p := os.Getenv("TERMOS_CONFIG_FILE"); p != "" {
		return p
	}
	if d := os.Getenv("TERMOS_CONFIG_DIR"); d != "" {
		return filepath.Join(d, "termos.conf")
	}
	if h := os.Getenv("TERMOS_HOME"); h != "" {
		return filepath.Join(h, "config", "termos.conf")
	}
	if home, err := os.UserHomeDir(); err == nil {
		return filepath.Join(home, ".config", "termos", "config", "termos.conf")
	}
	return ""
}
