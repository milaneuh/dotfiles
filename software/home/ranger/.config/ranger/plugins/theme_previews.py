import os

from ranger.core import actions

STATE_FILE = os.path.join(
    os.environ.get("XDG_STATE_HOME") or os.path.expanduser("~/.local/state"), "theme")

_get_preview_from_cache = actions.Actions.get_preview


def _theme_variant():
    try:
        with open(STATE_FILE, encoding="utf-8") as state_file:
            return state_file.read().strip()
    except OSError:
        return ""


def get_preview(self, fobj, width, height):
    variant = _theme_variant()

    if variant != getattr(self, "theme_variant", variant):
        self.previews = {}

    self.theme_variant = variant
    return _get_preview_from_cache(self, fobj, width, height)


actions.Actions.get_preview = get_preview
