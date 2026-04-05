import argparse
import json
from pathlib import Path
from typing import List, Dict, Any

REQUIRED_FILES = [
    'AGENTS.md',
    'CLAUDE.md',
    'README.md',
    'config/model_routing.yaml',
    'config/project_registry.yaml',
    'config/system_routes.yaml',
    'docs/system/root_repo_layout.md',
    'docs/system/subproject_onboarding.md',
]


def check_root(root: Path) -> Dict[str, Any]:
    missing = []
    for rel in REQUIRED_FILES:
        if not (root / rel).exists():
            missing.append(rel)

    dirs = ['projects', 'scripts', 'config', 'docs', 'obsidian_templates']
    missing_dirs = [d for d in dirs if not (root / d).exists()]

    return {
        'root': str(root),
        'missing_files': missing,
        'missing_dirs': missing_dirs,
        'status': 'pass' if not missing and not missing_dirs else 'warn'
    }


def check_registry(root: Path) -> Dict[str, Any]:
    registry_path = root / 'config' / 'project_registry.yaml'
    result = {'registry_exists': registry_path.exists(), 'projects_checked': []}
    if not registry_path.exists():
        result['status'] = 'fail'
        return result

    text = registry_path.read_text(encoding='utf-8', errors='ignore')
    project_ids = []
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith('id:'):
            project_ids.append(stripped.split(':', 1)[1].strip())

    for pid in project_ids:
        result['projects_checked'].append({'id': pid, 'status': 'registered'})

    result['status'] = 'pass' if project_ids else 'warn'
    return result


def render_md(root_info: Dict[str, Any], registry_info: Dict[str, Any]) -> str:
    lines = [
        '# System Health Report',
        '',
        f"- Root: `{root_info['root']}`",
        f"- Root status: `{root_info['status']}`",
        f"- Registry status: `{registry_info['status']}`",
        '',
    ]
    if root_info['missing_files']:
        lines.append('## Missing files')
        for item in root_info['missing_files']:
            lines.append(f'- {item}')
        lines.append('')
    if root_info['missing_dirs']:
        lines.append('## Missing directories')
        for item in root_info['missing_dirs']:
            lines.append(f'- {item}')
        lines.append('')
    lines.append('## Registered projects')
    for item in registry_info.get('projects_checked', []):
        lines.append(f"- {item['id']}: {item['status']}")
    lines.append('')
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', required=True)
    parser.add_argument('--output-json')
    parser.add_argument('--output-md')
    args = parser.parse_args()

    root = Path(args.root)
    root_info = check_root(root)
    registry_info = check_registry(root)
    payload = {'root_check': root_info, 'registry_check': registry_info}

    if args.output_json:
        Path(args.output_json).write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding='utf-8')
    if args.output_md:
        Path(args.output_md).write_text(render_md(root_info, registry_info), encoding='utf-8')
    if not args.output_json and not args.output_md:
        print(json.dumps(payload, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
