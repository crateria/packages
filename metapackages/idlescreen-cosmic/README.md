# idlescreen-cosmic metapackage

Product install for COSMIC users:

```text
idlescreen-cosmic
  Depends:    trance, trance-applet, trance-plugins-all
  Recommends: trance-tui, trance-cli
```

## Build a local .deb (equivs)

```bash
sudo apt install equivs
cd metapackages/idlescreen-cosmic
equivs-build control
```

Publish the resulting `.deb` through the normal packages import pipeline, or
vendor into release automation later.

Source app: [app-cosmic](https://github.com/idlescreen/app-cosmic).
