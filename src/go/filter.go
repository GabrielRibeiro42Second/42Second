package main

import "strings"

// FilterProjects filtra por nome ou caminho, sem diferenciar
// maiúsculas de minúsculas. Query vazia devolve tudo.
func FilterProjects(projects []Project, query string) []Project {
	query = strings.TrimSpace(query)
	if query == "" {
		return projects
	}
	q := strings.ToLower(query)

	var out []Project
	for _, p := range projects {
		if strings.Contains(strings.ToLower(p.Name), q) ||
			strings.Contains(strings.ToLower(p.Path), q) {
			out = append(out, p)
		}
	}
	return out
}
