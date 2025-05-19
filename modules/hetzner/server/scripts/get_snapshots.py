#!/usr/bin/env python3
import os, json, subprocess, argparse

def lookup_snapshot(name):
    try:
        out = subprocess.check_output([
            "hcloud", "image", "list", "--selector", "type=snapshot", "--output", "json"
        ])
        images = json.loads(out)
        for img in images:
            if img.get("description") == f"vm-snapshot-{name}":
                return img["id"]
    except Exception:
        pass
    return ""  # not found

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--names", required=True,
                   help="Space-separated list of node names")
    p.add_argument("--output", required=True,
                   help="Path to write JSON array")
    args = p.parse_args()

    ids = []
    for name in args.names.split():
        ids.append(lookup_snapshot(name))

    # write a JSON array of strings (empty if missing)
    with open(args.output, "w") as f:
        json.dump(ids, f, indent=2)

if __name__ == "__main__":
    main()
