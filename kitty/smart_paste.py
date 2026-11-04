from typing import Any

from kitty.boss import Boss
from kitty.clipboard import get_clipboard_string


def main(args: list[str]) -> None:
    pass


def handle_result(args: list[str], answer: Any, target_window_id: int, boss: Boss) -> None:
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    text = get_clipboard_string()
    if text:
        window.paste_with_actions(text)
    else:
        window.write_to_child('\x16')


handle_result.no_ui = True
