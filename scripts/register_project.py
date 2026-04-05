import argparse
from pathlib import Path

TEMPLATE = '''  - id: {project_id}
    name: {name}
    type: {project_type}
    status: active
    role: {role}
    root_path: {root_path}
    manifest_path: projects/{name}/project_manifest.yaml
    local_agents_path: projects/{name}/AGENTS.local.md
    notes: >-
      Added via register_project.py
'''


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--registry', required=True)
    parser.add_argument('--project-id', required=True)
    parser.add_argument('--name', required=True)
    parser.add_argument('--type', default='pilot_project')
    parser.add_argument('--role', default='subproject')
    parser.add_argument('--root-path', required=True)
    args = parser.parse_args()

    reg = Path(args.registry)
    if not reg.exists():
        reg.write_text('projects:\n', encoding='utf-8')

    block = TEMPLATE.format(
        project_id=args.project_id,
        name=args.name,
        project_type=args.type,
        role=args.role,
        root_path=args.root_path,
    )
    with reg.open('a', encoding='utf-8') as f:
        f.write(block)
    print(f'Registered project: {args.name}')


if __name__ == '__main__':
    main()
