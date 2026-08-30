import curses

from ranger.ext import img_display
from ranger.gui.widgets import pager

_draw_image_over_everything = pager.Pager.draw_image
_print_placeholder_leaving_cursor_moved = img_display.KittyImageDisplayer._print_placeholder


def draw_image(self):
    browser = self.fm.ui.browser
    if browser is not None and (browser.draw_hints or browser.draw_bookmarks):
        return
    _draw_image_over_everything(self)


def _print_placeholder(self, image_id, x, y, width, height):
    _print_placeholder_leaving_cursor_moved(self, image_id, x, y, width, height)
    row, col = curses.getsyx()
    self._write(curses.tparm(curses.tigetstr("cup"), row, col), wrap=False)
    self.stdbout.flush()


pager.Pager.draw_image = draw_image
img_display.KittyImageDisplayer._print_placeholder = _print_placeholder
