module.exports = {
  defaultBrowser: "Google Chrome",
  handlers: [
    {
      match: /zoom.us/,
      browser: "us.zoom.xos"
    },
    {
      match: /dangerdevices.net/,
      browser: {
              name: "Google Chrome",
              profile: "Default"
      }
    },
  ]
}
