config.load_autoconfig()

c.url.start_pages = "https://google.com/"
c.url.searchengines = {
    "DEFAULT": "https://google.com/search?q={}",
    "code": "https://github.com/search?utf8=✓&q={}&type=Code",
    "dd": "https://www.github.com/dangerdevices/{}",
    "w": "https://en.wikipedia.org/w/index.php?title=Special:Search&search={}",
    "y": "https://www.youtube.com/results?search_query={}",
}

c.editor.command = ["mvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]
config.bind("<Ctrl-e>", "edit-text", mode="insert")

c.input.insert_mode.auto_leave = False
