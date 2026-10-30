// Linked into the Firefox profile by install.sh. Applied on every startup.

// Load chrome/userChrome.css and chrome/userContent.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Let macOS blur what's behind the window (not just behind the toolbar)
user_pref("widget.macos.titlebar-blend-mode.behind-window", true);

// Allow transparent backgrounds behind web content (new tab page)
user_pref("browser.tabs.allow_transparent_browser", true);
