#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(
  "SKILL.md"
  "agents/openai.yaml"
  "rules/core-principles.md"
  "references/gotchas.md"
  "references/task-routing.md"
  "references/project-scaffold.md"
  "references/ios-foundation.md"
  "references/architecture-state.md"
  "references/ui-design-adaptation.md"
  "references/data-network-storage.md"
  "references/concurrency-lifecycle-performance.md"
  "references/quality-review-delivery.md"
  "workflows/scaffold-project.md"
  "workflows/add-feature.md"
  "workflows/fix-bug.md"
  "workflows/ui-adaptation.md"
  "workflows/review.md"
  "workflows/close-task.md"
)

for file in "${required[@]}"; do
  test -f "$root/$file" || { echo "missing: $file" >&2; exit 1; }
done

pattern="$(printf '%s|%s|%s|%s.*%s|%s' 'git''hub' '7 ''个' '七''个' '参考' '开''源' '开''源')"
if grep -R -Ei "$pattern" "$root" >/dev/null; then
  echo "forbidden wording found" >&2
  exit 1
fi

placeholder_pattern="$(printf '%s|%s|%s' 'TO''DO' 'T''BD' '占''位')"
if grep -R -En "$placeholder_pattern" "$root" >/dev/null; then
  echo "placeholder text found" >&2
  exit 1
fi

echo "ios-dev-standard smoke test passed"
