import argparse
import json
from pathlib import Path


def parse_sources(path: Path):
    text = path.read_text(encoding='utf-8', errors='ignore')
    items = []
    current = {}
    for raw in text.splitlines():
        line = raw.rstrip()
        stripped = line.strip()
        if stripped.startswith('- name:'):
            if current:
                items.append(current)
            current = {'name': stripped.split(':', 1)[1].strip()}
        elif current and ':' in stripped:
            key, value = stripped.split(':', 1)
            current[key.strip()] = value.strip()
    if current:
        items.append(current)
    return items


def render_summary(items, dry_run: bool):
    lines = ['# Tech Scout Summary', '']
    lines.append(f'- Mode: {"dry-run" if dry_run else "live"}')
    lines.append(f'- Sources: {len(items)}')
    lines.append('')
    for item in items:
        lines.append(f"## {item.get('name', 'unknown')}")
        lines.append(f"- kind: {item.get('kind', '')}")
        lines.append(f"- url: {item.get('url', '')}")
        lines.append('')
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', required=True)
    parser.add_argument('--output-dir', required=True)
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()

    cfg = Path(args.config)
    out = Path(args.output_dir)
    out.mkdir(parents=True, exist_ok=True)
    items = parse_sources(cfg)

    (out / 'summary.md').write_text(render_summary(items, args.dry_run), encoding='utf-8')
    (out / 'sources.json').write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding='utf-8')
    print(f'Wrote scout summary to {out}')


if __name__ == '__main__':
    main()
