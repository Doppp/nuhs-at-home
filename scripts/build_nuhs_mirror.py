#!/usr/bin/env python3

from __future__ import annotations

import posixpath
import re
from pathlib import Path, PurePosixPath

ROOT_DIR = Path(__file__).resolve().parents[1]
SITE_ROOT = "https://www.nuhs.edu.sg"
ALT_SITE_ROOTS = (
    SITE_ROOT,
    "https://nuhs.edu.sg",
    "http://www.nuhs.edu.sg",
    "http://nuhs.edu.sg",
)
PAGES = {
    "/patient-care/nuhs-at-home": ROOT_DIR / "reference/nuhs/index.raw.html",
    "/patient-care/nuhs-at-home/how-does-nuhs-home-work": ROOT_DIR / "reference/nuhs/how-it-works.raw.html",
    "/patient-care/nuhs-at-home/how-does-nuhs-home-work/why-choose-nuhs-home": ROOT_DIR / "reference/nuhs/why-choose.raw.html",
    "/patient-care/nuhs-at-home/how-does-nuhs-home-work/nuhs-home-resources": ROOT_DIR / "reference/nuhs/resources.raw.html",
    "/patient-care/nuhs-at-home/nuhs-home-articles": ROOT_DIR / "reference/nuhs/articles.raw.html",
    "/patient-care/nuhs-at-home/nuhs-home-events": ROOT_DIR / "reference/nuhs/events.raw.html",
    "/patient-care/nuhs-at-home/nuhs-home-leadership-team": ROOT_DIR / "reference/nuhs/leadership-team.raw.html",
    "/patient-care/nuhs-at-home/nuhs-home-in-the-news": ROOT_DIR / "reference/nuhs/in-the-news.raw.html",
}
LISTING_PAGES = {
    "/patient-care/nuhs-at-home": [
        ROOT_DIR / "reference/nuhs/listings/index.page-1.html",
    ],
    "/patient-care/nuhs-at-home/how-does-nuhs-home-work/nuhs-home-resources": [
        ROOT_DIR / "reference/nuhs/listings/resources.page-1.html",
    ],
    "/patient-care/nuhs-at-home/nuhs-home-articles": [
        ROOT_DIR / "reference/nuhs/listings/articles.page-1.html",
    ],
    "/patient-care/nuhs-at-home/nuhs-home-events": [
        ROOT_DIR / "reference/nuhs/listings/events.page-1.html",
    ],
    "/patient-care/nuhs-at-home/nuhs-home-in-the-news": [
        ROOT_DIR / "reference/nuhs/listings/in-the-news.page-1.html",
        ROOT_DIR / "reference/nuhs/listings/in-the-news.page-2.html",
    ],
}
ITEM_LISTING_SCRIPT = (
    '<script type="text/javascript" src="https://www.nuhs.edu.sg/Mvc/Views/ItemListing/itemlisting.js" defer></script>'
)
LOCAL_LISTING_SCRIPT_PATH = PurePosixPath("assets/js/local-item-listings.js")


def rewrite_html(html: str) -> str:
    html = html.replace('="/', f'="{SITE_ROOT}/')
    html = html.replace("='/", f"='{SITE_ROOT}/")
    html = html.replace('url("/', f'url("{SITE_ROOT}/')
    html = html.replace("url('/", f"url('{SITE_ROOT}/")
    html = html.replace("url(/", f"url({SITE_ROOT}/")
    return html


def relative_url(current_page: str, target_path: str, trailing_slash: bool = True) -> str:
    current_dir = PurePosixPath(current_page.lstrip("/"))
    target_dir = PurePosixPath(target_path.lstrip("/"))
    relative = posixpath.relpath(str(target_dir), str(current_dir))
    if relative == ".":
        return "./"
    if trailing_slash:
        return f"{relative}/"
    return relative


def localize_mirrored_paths(html: str, current_page: str) -> str:
    for path in sorted(PAGES, key=len, reverse=True):
        for root in ALT_SITE_ROOTS:
            pattern = re.compile(
                re.escape(f"{root}{path}") + r"(?P<suffix>(?:[?#][^\"'<>\\s]*)?)(?=[\"'<>\\s])"
            )
            html = pattern.sub(
                lambda match, target=path: f"{relative_url(current_page, target, trailing_slash=True)}{match.group('suffix')}",
                html,
            )

    return html


def extract_listing_items(fragment: str) -> str:
    marker = '<ul class="list-unstyled">'
    start = fragment.find(marker)
    if start == -1:
        raise ValueError("Could not find listing items wrapper.")

    start += len(marker)
    end = fragment.find("</ul>", start)
    if end == -1:
        raise ValueError("Could not find end of listing items wrapper.")

    return fragment[start:end].strip()


def build_listing_html(fragment_paths: list[Path], current_page: str) -> str:
    items = []
    for fragment_path in fragment_paths:
        fragment = fragment_path.read_text(encoding="utf-8")
        items.append(extract_listing_items(localize_mirrored_paths(rewrite_html(fragment), current_page)))

    combined_items = "\n".join(items)
    return (
        '    <div class="items-wrapper">\n'
        '            <ul class="list-unstyled">\n'
        f"{combined_items}\n"
        "            </ul>\n"
        "    </div>\n"
    )


def inject_listing_content(html: str, listing_html: str, current_page: str) -> str:
    match = re.search(r'class="itemListing"[^>]*data-uniqueid="([^"]+)"', html)
    if not match:
        raise ValueError("Could not find item listing unique id.")

    unique_id = match.group(1)
    list_div = f'<div id="{unique_id}-list"></div>'
    if list_div not in html:
        raise ValueError("Could not find item listing container.")

    html = html.replace(list_div, f'<div id="{unique_id}-list">\n{listing_html}</div>', 1)
    html = html.replace(ITEM_LISTING_SCRIPT, "")
    local_script = relative_url(current_page, str(LOCAL_LISTING_SCRIPT_PATH), trailing_slash=False)
    local_script_tag = f'<script src="{local_script}" defer></script>'
    if local_script_tag not in html:
        html = html.replace("</body>", f"{local_script_tag}\n  </body>", 1)
    return html


def build_page(path: str, source: Path) -> None:
    target = ROOT_DIR / path.lstrip("/") / "index.html"
    target.parent.mkdir(parents=True, exist_ok=True)
    html = source.read_text(encoding="utf-8")
    html = rewrite_html(html)
    html = localize_mirrored_paths(html, path)

    if path in LISTING_PAGES:
        html = inject_listing_content(html, build_listing_html(LISTING_PAGES[path], path), path)

    target.write_text(html, encoding="utf-8")
    print(f"Built {target.relative_to(ROOT_DIR)}")


def main() -> None:
    required_sources = list(PAGES.values()) + [page for pages in LISTING_PAGES.values() for page in pages]
    missing_sources = [source for source in required_sources if not source.exists()]
    if missing_sources:
        missing_list = ", ".join(str(path.relative_to(ROOT_DIR)) for path in missing_sources)
        raise SystemExit(f"Missing source files: {missing_list}")

    for path, source in PAGES.items():
        build_page(path, source)


if __name__ == "__main__":
    main()
