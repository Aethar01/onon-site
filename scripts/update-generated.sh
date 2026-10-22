#!/usr/bin/env bash
# Regenerates the pages made from the onon repository: the reference for
# the latest release, for main and for each older release, the changelog,
# and the release data the download buttons use.
#
#   scripts/update-generated.sh ../onon
#
# The checkout needs its tags (fetch-depth 0). Needs Go and what onon's
# cmd/builddocs builds with, and gh, signed in or given GH_TOKEN.
# A version's page is written once; FORCE=1 rewrites them all.
set -euo pipefail

onon=$(cd "${1:?usage: $0 path/to/onon}" && pwd)
site=$(cd "$(dirname "$0")/.." && pwd)
ref=$site/src/content/docs/docs/reference
mkdir -p "$ref/versions" "$site/src/data"
repo=Aethar01/onon

# builddocs writes docs/reference.md in the checkout it runs in.
generate() {
	(cd "$1" && go run ./cmd/builddocs >/dev/null)
}

# page TITLE DESCRIPTION ORDER SOURCE DEST [SLUG] writes SOURCE as a
# Starlight page, dropping its own heading, which the title replaces.
# Versions give a SLUG, since Astro drops the dots from file names.
page() {
	{
		printf -- '---\ntitle: "%s"\ndescription: "%s"\neditUrl: false\n' "$1" "$2"
		if [ -n "${6:-}" ]; then printf 'slug: %s\n' "$6"; fi
		if [ -n "$3" ]; then printf 'sidebar:\n  order: %s\n' "$3"; fi
		printf 'tableOfContents:\n  maxHeadingLevel: 2\n---\n\n'
		awk '/^<!-- Code generated/ { next } !done && /^# / { done = 1; next } { print }' "$4"
	} >"$5"
}

# Which name a version went by: releases before 0.8.0 were gopdf.
product() {
	if grep -q 'gopdf\.' "$1"; then echo gopdf; else echo onon; fi
}

generate "$onon"
page "Development version" "Reference for onon's main branch, which may change before the next release." "" \
	"$onon/docs/reference.md" "$ref/main.md"

latest=""
order=0
while IFS= read -r tag; do
	# Only releases whose builddocs writes docs/reference.md have a reference.
	if ! git -C "$onon" show "$tag:cmd/builddocs/main.go" 2>/dev/null | grep -q 'docs/reference.md'; then
		continue
	fi
	order=$((order + 1))
	dest=$ref/versions/$tag.md
	if [ -z "$latest" ]; then latest=$tag; fi
	if [ -f "$dest" ] && [ "${FORCE:-}" != 1 ] && [ "$tag" != "$latest" ]; then
		# Each new release moves the older ones down the sidebar.
		perl -pi -e "s/^  order: \d+\$/  order: $order/ if \$. < 10" "$dest"
		continue
	fi
	tree=$(mktemp -d)
	git -C "$onon" worktree add --quiet --detach "$tree" "$tag"
	generate "$tree"
	name=$(product "$tree/docs/reference.md")
	page "$name $tag" "Reference for $name $tag." "$order" "$tree/docs/reference.md" "$dest" "docs/reference/$tag"
	if [ "$tag" = "$latest" ]; then
		page "Reference" "Every option, command, Lua function, key and action in $name $tag." "" \
			"$tree/docs/reference.md" "$ref/index.md"
	fi
	git -C "$onon" worktree remove --force "$tree"
done < <(git -C "$onon" tag --sort=-version:refname)

gh api "repos/$repo/releases?per_page=100" >"$site/src/data/releases.raw.json"
python3 - "$site" <<'PY'
import json, re, sys
site = sys.argv[1]
releases = [r for r in json.load(open(f"{site}/src/data/releases.raw.json")) if not r["draft"]]

def shorten(body):
    # GitHub's generated notes link whole URLs; show them as #N.
    body = re.sub(r"https://github\.com/[^/\s]+/[^/\s]+/pull/(\d+)", r"[#\1](https://github.com/Aethar01/onon/pull/\1)", body or "")
    body = re.sub(r"^## ", "### ", body, flags=re.M)
    return body.strip()

lines = ["---", 'title: "Changelog"', 'description: "What changed in each release of onon, and of gopdf before it."', "editUrl: false", "tableOfContents:", "  maxHeadingLevel: 2", "---", ""]
for r in releases:
    lines += [f"## {r['tag_name']}", "", f"Released {r['published_at'][:10]}. [Downloads]({r['html_url']})", ""]
    body = shorten(r["body"])
    if body:
        lines += [body, ""]
open(f"{site}/src/content/docs/docs/changelog.md", "w").write("\n".join(lines))

stable = [r for r in releases if not r["prerelease"]]
latest = stable[0] if stable else None
data = {"tag": None, "url": "https://github.com/Aethar01/onon/releases/latest", "assets": {}}
if latest:
    data["tag"] = latest["tag_name"]
    data["url"] = latest["html_url"]
    data["date"] = latest["published_at"][:10]
    kinds = {
        "macos_arm64": r"-darwin-arm64\.dmg$",
        "macos_amd64": r"-darwin-amd64\.dmg$",
        "windows_installer": r"-windows-amd64-installer\.exe$",
        "windows_zip": r"-windows-amd64\.zip$",
        "linux_appimage": r"-linux-x86_64\.AppImage$",
    }
    for asset in latest["assets"]:
        for kind, pattern in kinds.items():
            if re.search(pattern, asset["name"]):
                data["assets"][kind] = {"name": asset["name"], "url": asset["browser_download_url"], "size": asset["size"]}
json.dump(data, open(f"{site}/src/data/release.json", "w"), indent=2)
PY
rm "$site/src/data/releases.raw.json"
echo "reference: latest $latest; changelog and release data written"
